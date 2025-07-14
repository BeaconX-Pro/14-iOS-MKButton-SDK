//
//  MKBXDExportEventDataController.m
//  MKBeaconXDButton_Example
//
//  Created by aa on 2025/3/19.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import "MKBXDExportEventDataController.h"

#import <MessageUI/MessageUI.h>
#import <sys/utsname.h>

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"

#import "MKHudManager.h"
#import "MKCustomUIAdopter.h"

#import "MKBXDBaseSDKAdopter.h"

#import "MKBXDExcelManager.h"
#import "MKBXDInterface+MKBXDConfig.h"

#import "MKBXDCentralManager.h"

#import "MKBXDSyncEventHeaderView.h"

static NSTimeInterval const parseDataInterval = 0.05;

@interface MKBXDExportEventDataController ()<MFMailComposeViewControllerDelegate,
MKBXDSyncEventHeaderViewDelegate,
mk_bxd_centralManagerAlarmEventDelegate>

@property (nonatomic, strong)MKBXDSyncEventHeaderView *headerView;

@property (nonatomic, strong)UITextView *textView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)NSDateFormatter *dateFormatter;

@property (nonatomic, strong)NSMutableArray *contentList;

/// 定时解析数据
@property (nonatomic, strong)dispatch_source_t parseTimer;

@end

@implementation MKBXDExportEventDataController

- (void)dealloc {
    NSLog(@"MKBXDExportEventDataController销毁");
    if (self.parseTimer) {
        dispatch_cancel(self.parseTimer);
    }
    if (self.vcType == MKBXDExportEventDataControllerTypeSingle) {
        [[MKBXDCentralManager shared] notifySingleClickData:NO];
        return;
    }
    if (self.vcType == MKBXDExportEventDataControllerTypeDouble) {
        [[MKBXDCentralManager shared] notifyDoubleClickData:NO];
        return;
    }
    if (self.vcType == MKBXDExportEventDataControllerTypeLong) {
        [[MKBXDCentralManager shared] notifyLongClickData:NO];
        return;
    }
    if (self.vcType == MKBXDExportEventDataControllerTypeConnectionMode) {
        [[MKBXDCentralManager shared] notifyLongConnectClickData:NO];
        return;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [MKBXDCentralManager shared].eventDelegate = self;
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

#pragma mark - mk_bxd_centralManagerAlarmEventDelegate
/// Receive Alarm Event Data.
/// - Parameters:
///   - content: content
- (void)mk_bxd_receiveAlarmEventData:(NSDictionary *)contentData {
    [self.contentList addObject:contentData];
}

#pragma mark - MKBXDSyncEventHeaderViewDelegate
- (void)bxd_syncEventHeaderView_syncBtnPressed:(BOOL)selected {
    if (self.parseTimer) {
        dispatch_cancel(self.parseTimer);
    }
    if (selected) {
        //开始监听
        [self.textView setText:@""];
        [self.dataList removeAllObjects];
        [self.contentList removeAllObjects];
        [self addTimerForRefresh];
    }
    if (self.vcType == MKBXDExportEventDataControllerTypeSingle) {
        [[MKBXDCentralManager shared] notifySingleClickData:selected];
        return;
    }
    if (self.vcType == MKBXDExportEventDataControllerTypeDouble) {
        [[MKBXDCentralManager shared] notifyDoubleClickData:selected];
        return;
    }
    if (self.vcType == MKBXDExportEventDataControllerTypeLong) {
        [[MKBXDCentralManager shared] notifyLongClickData:selected];
        return;
    }
    if (self.vcType == MKBXDExportEventDataControllerTypeConnectionMode) {
        [[MKBXDCentralManager shared] notifyLongConnectClickData:selected];
        return;
    }
}

- (void)bxd_syncEventHeaderView_deleteBtnPressed {
    if (self.vcType == MKBXDExportEventDataControllerTypeSingle) {
        [MKBXDInterface bxd_clearSinglePressEventDataWithSucBlock:^{
            [[MKHudManager share] hide];
            [[MKBXDCentralManager shared] notifySingleClickData:NO];
            [self clearAllStatus];
        } failedBlock:^(NSError * _Nonnull error) {
            [[MKHudManager share] hide];
            [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        }];
        return;
    }
    if (self.vcType == MKBXDExportEventDataControllerTypeDouble) {
        [MKBXDInterface bxd_clearDoublePressEventDataWithSucBlock:^{
            [[MKHudManager share] hide];
            [[MKBXDCentralManager shared] notifyDoubleClickData:NO];
            [self clearAllStatus];
        } failedBlock:^(NSError * _Nonnull error) {
            [[MKHudManager share] hide];
            [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        }];
        return;
    }
    if (self.vcType == MKBXDExportEventDataControllerTypeLong) {
        [MKBXDInterface bxd_clearLongPressEventDataWithSucBlock:^{
            [[MKHudManager share] hide];
            [[MKBXDCentralManager shared] notifyLongClickData:NO];
            [self clearAllStatus];
        } failedBlock:^(NSError * _Nonnull error) {
            [[MKHudManager share] hide];
            [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        }];
        return;
    }
    if (self.vcType == MKBXDExportEventDataControllerTypeConnectionMode) {
        [MKBXDInterface bxd_clearLongConnectionModeEventDataWithSucBlock:^{
            [[MKHudManager share] hide];
            [[MKBXDCentralManager shared] notifyLongConnectClickData:NO];
            [self clearAllStatus];
        } failedBlock:^(NSError * _Nonnull error) {
            [[MKHudManager share] hide];
            [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        }];
        return;
    }
}

- (void)bxd_syncEventHeaderView_exportBtnPressed {
    [[MKHudManager share] showHUDWithTitle:@"Waiting..." inView:self.view isPenetration:NO];
    [MKBXDExcelManager exportExcelWithEventDataList:self.dataList sucBlock:^{
        [[MKHudManager share] hide];
        [self sharedExcel];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - Private method
- (void)sharedExcel {
    if (![MFMailComposeViewController canSendMail]) {
        //如果是未绑定有效的邮箱，则跳转到系统自带的邮箱去处理
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"MESSAGE://"]
                                          options:@{}
                                completionHandler:nil];
        return;
    }
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [documentPath stringByAppendingPathComponent:@"eventData.xlsx"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [self.view showCentralToast:@"File not exist"];
        return;
    }
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
    if (!ValidData(data)) {
        [self.view showCentralToast:@"Load file error"];
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
    [mailComposer addAttachmentData:data
                           mimeType:@"application/xlsx"
                           fileName:@"eventData.xlsx"];
    [mailComposer setMessageBody:bodyMsg isHTML:NO];
    [self presentViewController:mailComposer animated:YES completion:nil];
}

- (void)clearAllStatus {
    [self.textView setText:@""];
    [self.dataList removeAllObjects];
    self.headerView.sync = NO;
}

#pragma mark - 刷新
- (void)addTimerForRefresh {
    self.parseTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,dispatch_get_global_queue(0, 0));
    dispatch_source_set_timer(self.parseTimer, dispatch_time(DISPATCH_TIME_NOW, parseDataInterval * NSEC_PER_SEC),  parseDataInterval * NSEC_PER_SEC, 0);
    @weakify(self);
    dispatch_source_set_event_handler(self.parseTimer, ^{
        @strongify(self);
        moko_dispatch_main_safe(^{
            [self parseContentDatas];
        });
    });
    dispatch_resume(self.parseTimer);
}

- (void)parseContentDatas {
    if (self.contentList.count == 0) {
        return;
    }
    NSDictionary *contentDic = self.contentList[0];
    [self.contentList removeObjectAtIndex:0];
    
    NSString *content = contentDic[@"content"];
    NSInteger alarmType = [contentDic[@"alarmType"] integerValue];
    
    long long timeValue = [MKBXDBaseSDKAdopter getDecimalWithHex:content range:NSMakeRange(0, 16)];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:(timeValue / 1000.0)];
    NSString *dateString = [self.dateFormatter stringFromDate:date];
    
    NSString *eventType = @"";
    if (alarmType == 0 || alarmType == 1 || alarmType == 2) {
        NSInteger type = [MKBXDBaseSDKAdopter getDecimalWithHex:content range:NSMakeRange(16, 2)];
        if (type == 0) {
            eventType = @"Single press mode";
        }else if (type == 1) {
            eventType = @"Double press mode";
        }else if (type == 2) {
            eventType = @"Long press mode";
        }
    }else {
        //Long Connection Mode
        eventType = [MKBXDBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(16, 2)];
    }
    
    NSDictionary *dic = @{
        @"timestamp":dateString,
        @"eventType":eventType
    };
    [self.dataList addObject:dic];
    NSString *space = (alarmType > 2 ? @"\t\t\t\t\t" : @"\t\t\t");
    NSString *text = [NSString stringWithFormat:@"\n%@%@%@",dateString,space,eventType];
    moko_dispatch_main_safe(^{
        self.textView.text = [text stringByAppendingString:self.textView.text];
    });
}

#pragma mark - UI
- (void)loadSubViews {
    NSString *title = @"Single press event";
    if (self.vcType == MKBXDExportEventDataControllerTypeDouble) {
        title = @"Double press event";
    }else if (self.vcType == MKBXDExportEventDataControllerTypeLong) {
        title = @"Long press event";
    }else {
        title = @"Alarm event";
    }
    self.defaultTitle = title;
    self.view.backgroundColor = RGBCOLOR(242, 242, 242);
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.height.mas_equalTo(100.f);
    }];
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.headerView.mas_bottom);
        make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
    }];
}

#pragma mark - getter
- (MKBXDSyncEventHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[MKBXDSyncEventHeaderView alloc] init];
        _headerView.delegate = self;
        _headerView.modeMsg = (self.vcType == MKBXDExportEventDataControllerTypeConnectionMode) ? @"Button Clicks" : @"Trigger mode";
    }
    return _headerView;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.font = MKFont(13.f);
        _textView.layoutManager.allowsNonContiguousLayout = NO;
        _textView.editable = NO;
        _textView.textColor = DEFAULT_TEXT_COLOR;
    }
    return _textView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (NSMutableArray *)contentList {
    if (!_contentList) {
        _contentList = [NSMutableArray array];
    }
    return _contentList;
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z"];
    }
    return _dateFormatter;
}

@end
