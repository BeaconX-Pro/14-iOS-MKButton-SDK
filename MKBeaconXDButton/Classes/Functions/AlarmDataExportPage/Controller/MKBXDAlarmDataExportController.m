//
//  MKBXDAlarmDataExportController.m
//  MKBeaconXDButton_Example
//
//  Created by aa on 2022/3/9.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXDAlarmDataExportController.h"

#import <MessageUI/MessageUI.h>
#import <sys/utsname.h>

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"

#import "MKHudManager.h"
#import "MKCustomUIAdopter.h"

#import "MKBLEBaseLogManager.h"

#import "MKBXDCentralManager.h"
#import "MKBXDInterface+MKBXDConfig.h"

#import "MKBXDAlarmDataExportButton.h"

@interface MKBXDAlarmDataExportController ()

@property (nonatomic, strong)UIView *bottomView;

@property (nonatomic, strong)UIImageView *syncIcon;

@property (nonatomic, strong)UIButton *syncButton;

@property (nonatomic, strong)UILabel *syncLabel;

@property (nonatomic, strong)MKBXDAlarmDataExportButton *deleteButton;

@property (nonatomic, strong)MKBXDAlarmDataExportButton *exportButton;

@property (nonatomic, strong)UITextView *textView;

@property (nonatomic, strong)NSDateFormatter *formatter;

@end

@implementation MKBXDAlarmDataExportController

- (void)dealloc {
    NSLog(@"MKBXDAlarmDataExportController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self notifyAlarmEventData:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //本页面禁止右划退出手势
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self addNotifications];
    self.textView.text = [self readDataWithFileName];
}

#pragma mark - super method
- (void)leftButtonMethod {
    [self saveDataToLocal:SafeStr(self.textView.text)];
    [super leftButtonMethod];
}

#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    switch (result) {
        case MFMailComposeResultCancelled:  //取消
            break;
        case MFMailComposeResultSaved:      //用户保存
            break;
        case MFMailComposeResultSent:       //用户点击发送
            [self.view showCentralToast:@"send success"];
            break;
        case MFMailComposeResultFailed: //用户尝试保存或发送邮件失败
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - note
- (void)receiveAlarmEventData:(NSNotification *)note {
    NSDictionary *dic = note.userInfo;
    if (!ValidDict(dic)) {
        return;
    }
    NSString *state = @"Single press mode";
    if ([dic[@"alarmType"] isEqualToString:@"01"]) {
        state = @"Double press mode";
    }else if ([dic[@"alarmType"] isEqualToString:@"02"]) {
        state = @"Long press mode";
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:([dic[@"timestamp"] longLongValue] / 1000.0)];
    NSString *tempValue = [self.formatter stringFromDate:date];
    NSArray *tempList = [tempValue componentsSeparatedByString:@" "];
    NSString *timestamp = [NSString stringWithFormat:@"%@T%@Z",tempList[0],tempList[1]];
    
    NSString *text = [NSString stringWithFormat:@"\n%@\t\t%@",timestamp,state];
//    [self saveDataToLocal:text];
    self.textView.text = [text stringByAppendingString:self.textView.text];
//    [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length, 1)];
}

#pragma mark - event method
- (void)syncButtonPressed {
    self.syncButton.selected = !self.syncButton.selected;
    [self.syncIcon.layer removeAnimationForKey:@"synIconAnimationKey"];
    
    if (self.syncButton.selected) {
        //开始旋转
        [self notifyAlarmEventData:YES];
        [self.syncIcon.layer addAnimation:[MKCustomUIAdopter refreshAnimation:2.f] forKey:@"synIconAnimationKey"];
        self.syncLabel.text = @"Stop";
        return;
    }
    [self notifyAlarmEventData:NO];
    self.syncLabel.text = @"Sync";
}

- (void)deleteButtonPressed {
    [MKBLEBaseLogManager deleteLogWithFileName:[NSString stringWithFormat:@"/%@",[self currentDataName]]];
    [self.textView setText:@""];
    self.syncButton.selected = NO;
    [self.syncIcon.layer removeAnimationForKey:@"synIconAnimationKey"];
    [self notifyAlarmEventData:self.syncButton.selected];
    self.syncLabel.text = @"Sync";
}

- (void)exportButtonPressed {
    if (![MFMailComposeViewController canSendMail]) {
        //如果是未绑定有效的邮箱，则跳转到系统自带的邮箱去处理
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"MESSAGE://"]
                                           options:@{}
                                 completionHandler:nil];
        return;
    }
    
    NSData *emailData = [MKBLEBaseLogManager readDataWithFileName:[NSString stringWithFormat:@"/%@",[self currentDataName]]];
    if (!ValidData(emailData)) {
        [self.view showCentralToast:@"Log file does not exist"];
        return;
    }
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *bodyMsg = [NSString stringWithFormat:@"APP Version: %@ + + OS: %@",
                         version,
                         kSystemVersionString];
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    mailComposer.mailComposeDelegate = self;
    
    //收件人
    [mailComposer setToRecipients:@[@"Development@mokotechnology.com"]];
    //邮件主题
    [mailComposer setSubject:@"Feedback of mail"];
    [mailComposer addAttachmentData:emailData
                           mimeType:@"application/txt"
                           fileName:[NSString stringWithFormat:@"%@.txt",[self currentDataName]]];
    [mailComposer setMessageBody:bodyMsg isHTML:NO];
    [self presentViewController:mailComposer animated:YES completion:nil];
}

#pragma mark - private method
- (void)notifyAlarmEventData:(BOOL)notify {
    if (self.pageType == MKBXDAlarmDataExportControllerType_single) {
        [[MKBXDCentralManager shared] notifySinglePressEventData:notify];
        return;
    }
    if (self.pageType == MKBXDAlarmDataExportControllerType_double) {
        [[MKBXDCentralManager shared] notifyDoublePressEventData:notify];
        return;
    }
    if (self.pageType == MKBXDAlarmDataExportControllerType_long) {
        [[MKBXDCentralManager shared] notifyLongPressEventData:notify];
        return;
    }
}

- (NSString *)currentDataName {
    if (self.pageType == MKBXDAlarmDataExportControllerType_single) {
        return @"Single press trigger event";
    }
    if (self.pageType == MKBXDAlarmDataExportControllerType_double) {
        return @"Double press trigger event";
    }
    if (self.pageType == MKBXDAlarmDataExportControllerType_long) {
        return @"Long press trigger event";
    }
    return @"";
}

- (NSString *)currentTitle {
    if (self.pageType == MKBXDAlarmDataExportControllerType_single) {
        return @"Single press event";
    }
    if (self.pageType == MKBXDAlarmDataExportControllerType_double) {
        return @"Double press event";
    }
    if (self.pageType == MKBXDAlarmDataExportControllerType_long) {
        return @"Long press event";
    }
    return @"";
}

- (BOOL)saveDataToLocal:(NSString *)text {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES)lastObject];
    NSString *localFileName = [NSString stringWithFormat:@"/%@.txt",[NSString stringWithFormat:@"/%@",[self currentDataName]]];
    NSString *filePath = [path stringByAppendingString:localFileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
        
    BOOL directory = NO;
    BOOL existed = [fileManager fileExistsAtPath:filePath isDirectory:&directory];
    
    if (!existed) {
        
        NSString *newFilePath = [path stringByAppendingPathComponent:localFileName];
        BOOL createResult = [fileManager createFileAtPath:newFilePath contents:nil attributes:nil];
        if (!createResult) {
            return NO;
        }
    }
    
    NSError *error = nil;
    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:filePath error:&error];
    if (error || !ValidDict(fileAttributes)) {
        return NO;
    }
    //写数据部分
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
    [fileHandle seekToEndOfFile];   //将节点跳到文件的末尾
    NSData *stringData = [text dataUsingEncoding:NSUTF8StringEncoding];
    [fileHandle writeData:stringData];
    [fileHandle closeFile];
    return YES;
}

- (NSString *)readDataWithFileName {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES) lastObject];
    NSString *localFileName = [NSString stringWithFormat:@"/%@.txt",[NSString stringWithFormat:@"/%@",[self currentDataName]]];
    NSString *filePath = [path stringByAppendingString:localFileName];
    NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    return content;
}

- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveAlarmEventData:)
                                                 name:mk_bxd_receiveAlarmEventDataNotification
                                               object:nil];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = [self currentTitle];
    self.view.backgroundColor = RGBCOLOR(242, 242, 242);
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.right.mas_equalTo(-10.f);
        make.top.mas_equalTo(defaultTopInset + 10.f);
        make.bottom.mas_equalTo(-VirtualHomeHeight - 10.f);
    }];
    [self.bottomView addSubview:self.syncButton];
    [self.bottomView addSubview:self.syncLabel];
    [self.syncButton addSubview:self.syncIcon];
    CGFloat buttonWidth = 70.f;
    CGFloat space = (kViewWidth - 2 * 10 - 3 * 30) / 4;
    [self.syncButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(space);
        make.width.mas_equalTo(buttonWidth);
        make.top.mas_equalTo(15.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.syncIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.syncButton.mas_centerX);
        make.centerY.mas_equalTo(self.syncButton.mas_centerY);
        make.width.mas_equalTo(25.f);
        make.height.mas_equalTo(25.f);
    }];
    [self.syncLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.syncButton.mas_centerX);
        make.width.mas_equalTo(buttonWidth);
        make.top.mas_equalTo(self.syncButton.mas_bottom).mas_offset(2.f);
        make.height.mas_equalTo(MKFont(10.f).lineHeight);
    }];
    [self.bottomView addSubview:self.exportButton];
    [self.exportButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-space);
        make.width.mas_equalTo(buttonWidth);
        make.top.mas_equalTo(10.f);
        make.height.mas_equalTo(50.f);
    }];
    [self.bottomView addSubview:self.deleteButton];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bottomView.mas_centerX);
        make.width.mas_equalTo(buttonWidth);
        make.centerY.mas_equalTo(self.exportButton.mas_centerY);
        make.height.mas_equalTo(50.f);
    }];
    
    [self.bottomView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5.f);
        make.right.mas_equalTo(-5.f);
        make.top.mas_equalTo(self.exportButton.mas_bottom).mas_offset(10.f);
        make.bottom.mas_equalTo(-VirtualHomeHeight - 10.f);
    }];
}

#pragma mark - getter

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = COLOR_WHITE_MACROS;
        _bottomView.layer.masksToBounds = YES;
        _bottomView.layer.cornerRadius = 6.f;
    }
    return _bottomView;
}

- (UIButton *)syncButton {
    if (!_syncButton) {
        _syncButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_syncButton addTapAction:self selector:@selector(syncButtonPressed)];
    }
    return _syncButton;
}

- (UIImageView *)syncIcon {
    if (!_syncIcon) {
        _syncIcon = [[UIImageView alloc] init];
        _syncIcon.image = LOADICON(@"MKBeaconXDButton", @"MKBXDAlarmDataExportController", @"bxd_threeAxisAcceLoadingIcon.png");
    }
    return _syncIcon;
}

- (UILabel *)syncLabel {
    if (!_syncLabel) {
        _syncLabel = [[UILabel alloc] init];
        _syncLabel.textColor = DEFAULT_TEXT_COLOR;
        _syncLabel.textAlignment = NSTextAlignmentCenter;
        _syncLabel.font = MKFont(10.f);
        _syncLabel.text = @"Sync";
    }
    return _syncLabel;
}

- (MKBXDAlarmDataExportButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [[MKBXDAlarmDataExportButton alloc] init];
        MKBXDAlarmDataExportButtonModel *model = [[MKBXDAlarmDataExportButtonModel alloc] init];
        model.msg = @"Empty list";
        model.icon = LOADICON(@"MKBeaconXDButton", @"MKBXDAlarmDataExportController", @"bxd_slotExportDeleteIcon.png");
        _deleteButton.dataModel = model;
        [_deleteButton addTarget:self
                          action:@selector(deleteButtonPressed)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

- (MKBXDAlarmDataExportButton *)exportButton {
    if (!_exportButton) {
        _exportButton = [[MKBXDAlarmDataExportButton alloc] init];
        MKBXDAlarmDataExportButtonModel *model = [[MKBXDAlarmDataExportButtonModel alloc] init];
        model.msg = @"Export";
        model.icon = LOADICON(@"MKBeaconXDButton", @"MKBXDAlarmDataExportController", @"bxd_slotExportEnableIcon.png");
        _exportButton.dataModel = model;
        [_exportButton addTarget:self
                          action:@selector(exportButtonPressed)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _exportButton;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.backgroundColor = COLOR_WHITE_MACROS;
        _textView.font = MKFont(12.f);
        _textView.layoutManager.allowsNonContiguousLayout = NO;
        _textView.editable = NO;
        _textView.textColor = DEFAULT_TEXT_COLOR;
    }
    return _textView;
}

- (UILabel *)loadTextLabel:(NSString *)text {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = DEFAULT_TEXT_COLOR;
    label.font = MKFont(13.f);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = text;
    return label;
}

- (NSDateFormatter *)formatter {
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss.SSS"];
    }
    return _formatter;
}

@end
