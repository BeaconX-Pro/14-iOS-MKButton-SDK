//
//  MKBXDDeviceController.m
//  MKBeaconXDButton_Example
//
//  Created by aa on 2022/2/19.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXDDeviceController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"

#import "MKHudManager.h"
#import "MKNormalTextCell.h"
#import "MKTextFieldCell.h"
#import "MKAlertView.h"

#import "MKBXDConnectManager.h"

#import "MKBXDInterface+MKBXDConfig.h"

#import "MKBXDDeviceIDCell.h"

#import "MKBXDDevicePageModel.h"

#import "MKBXDQuickSwitchController.h"
#import "MKBXDUpdateController.h"
#import "MKBXDDeviceInfoController.h"

@interface MKBXDDeviceController ()<UITableViewDelegate,
UITableViewDataSource,
MKTextFieldCellDelegate,
MKBXDDeviceIDCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *section2List;

@property (nonatomic, strong)NSMutableArray *section3List;

@property (nonatomic, strong)NSMutableArray *section4List;

@property (nonatomic, strong)NSMutableArray *section5List;

@property (nonatomic, strong)MKBXDDevicePageModel *dataModel;

@property (nonatomic, assign)BOOL dfuMode;

@property (nonatomic, copy)NSString *passwordAsciiStr;

@property (nonatomic, copy)NSString *confirmAsciiStr;

@end

@implementation MKBXDDeviceController

- (void)dealloc {
    NSLog(@"MKBXDDeviceController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];
    if (!self.dfuMode) {
        [self readDataFromDevice];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self loadSectionDatas];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceDFUComplete)
                                                 name:@"mk_bxd_startDfuProcessNotification"
                                               object:nil];
}

#pragma mark - super method
- (void)leftButtonMethod {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_bxd_popToRootViewControllerNotification" object:nil];
}

- (void)rightButtonMethod {
    [self saveDataToDevice];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        //Quick switch
        [self pushQuickSwitchPage];
        return;
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        //Turn off Beacon
        [self turnOffBeacon];
        return;
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        //Reset Beacon
        [self resetBeacon];
        return;
    }
    if (indexPath.section == 2 && indexPath.row == 0) {
        //Modify password
        [self modifyPassword];
        return;
    }
    if (indexPath.section == 3 && indexPath.row == 0) {
        //DFU
        [self startDFU];
        return;
    }
    if (indexPath.section == 3 && indexPath.row == 1) {
        //Device Info
        [self pushDeviceInfoPage];
        return;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.section0List.count;
    }
    if (section == 1) {
        return ([MKBXDConnectManager shared].needPassword ? self.section1List.count : 0);
    }
    if (section == 2) {
        return (([MKBXDConnectManager shared].needPassword && ValidStr([MKBXDConnectManager shared].password)) ? self.section2List.count : 0);
    }
    if (section == 3) {
        return self.section3List.count;
    }
    if (section == 4) {
        return self.section4List.count;
    }
    if (section == 5) {
        return self.section5List.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
        cell.dataModel = self.section0List[indexPath.row];
        return cell;
    }
    if (indexPath.section == 1) {
        MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
        cell.dataModel = self.section1List[indexPath.row];
        return cell;
    }
    if (indexPath.section == 2) {
        MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
        cell.dataModel = self.section2List[indexPath.row];
        return cell;
    }
    if (indexPath.section == 3) {
        MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
        cell.dataModel = self.section3List[indexPath.row];
        return cell;
    }
    if (indexPath.section == 4) {
        MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:tableView];
        cell.dataModel = self.section4List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    MKBXDDeviceIDCell *cell = [MKBXDDeviceIDCell initCellWithTableView:self.tableView];
    cell.dataModel = self.section5List[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - MKTextFieldCellDelegate
/// textField内容发送改变时的回调事件
/// @param index 当前cell所在的index
/// @param value 当前textField的值
- (void)mk_deviceTextCellValueChanged:(NSInteger)index textValue:(NSString *)value {
    if (index == 0) {
        //Device Name
        self.dataModel.deviceName = value;
        MKTextFieldCellModel *cellModel = self.section4List[0];
        cellModel.textFieldValue = value;
        return;
    }
}

#pragma mark - MKBXDDeviceIDCellDelegate
- (void)bxd_deviceIDChanged:(NSString *)text {
    self.dataModel.deviceID = text;
    MKBXDDeviceIDCellModel *cellModel = self.section5List[0];
    cellModel.deviceID = text;
}

#pragma mark - note
- (void)deviceDFUComplete {
    self.dfuMode = YES;
}

#pragma mark - event method
- (void)pushQuickSwitchPage {
    MKBXDQuickSwitchController *vc = [[MKBXDQuickSwitchController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)turnOffBeacon {
    @weakify(self);
    MKAlertViewAction *cancelAction = [[MKAlertViewAction alloc] initWithTitle:@"Cancel" handler:^{
        
    }];
    
    MKAlertViewAction *confirmAction = [[MKAlertViewAction alloc] initWithTitle:@"OK" handler:^{
        @strongify(self);
        [self commandPowerOff];
    }];
    NSString *msg = @"Are you sure to turn off the Beacon?Please make sure the Beacon has a button to turn on!";
    MKAlertView *alertView = [[MKAlertView alloc] init];
    [alertView addAction:cancelAction];
    [alertView addAction:confirmAction];
    [alertView showAlertWithTitle:@"Warning!" message:msg notificationName:@"mk_bxd_needDismissAlert"];
}

- (void)resetBeacon {
    @weakify(self);
    MKAlertViewAction *cancelAction = [[MKAlertViewAction alloc] initWithTitle:@"Cancel" handler:^{
        
    }];
    
    MKAlertViewAction *confirmAction = [[MKAlertViewAction alloc] initWithTitle:@"OK" handler:^{
        @strongify(self);
        [self commandResetDevice];
    }];
    NSString *msg = @"Are you sure to reset the Beacon？";
    MKAlertView *alertView = [[MKAlertView alloc] init];
    [alertView addAction:cancelAction];
    [alertView addAction:confirmAction];
    [alertView showAlertWithTitle:@"Warning!" message:msg notificationName:@"mk_bxd_needDismissAlert"];
}

- (void)modifyPassword {
    @weakify(self);
    MKAlertViewAction *cancelAction = [[MKAlertViewAction alloc] initWithTitle:@"Cancel" handler:^{
    }];
    
    MKAlertViewAction *confirmAction = [[MKAlertViewAction alloc] initWithTitle:@"OK" handler:^{
        @strongify(self);
        [self setPasswordToDevice];
    }];
    MKAlertViewTextField *passwordField = [[MKAlertViewTextField alloc] initWithTextValue:@""
                                                                              placeholder:@"Enter new password"
                                                                            textFieldType:mk_normal
                                                                                maxLength:16
                                                                                  handler:^(NSString * _Nonnull text) {
        @strongify(self);
        self.passwordAsciiStr = text;
    }];
    
    MKAlertViewTextField *confirmField = [[MKAlertViewTextField alloc] initWithTextValue:@""
                                                                             placeholder:@"Enter new password again"
                                                                           textFieldType:mk_normal
                                                                               maxLength:16
                                                                                 handler:^(NSString * _Nonnull text) {
        @strongify(self);
        self.confirmAsciiStr = text;
    }];
    
    NSString *msg = @"Note: The password should not be exceed 16 characters in length.";
    MKAlertView *alertView = [[MKAlertView alloc] init];
    [alertView addAction:cancelAction];
    [alertView addAction:confirmAction];
    [alertView addTextField:passwordField];
    [alertView addTextField:confirmField];
    [alertView showAlertWithTitle:@"Modify password" message:msg notificationName:@"mk_bxd_needDismissAlert"];
}

- (void)startDFU {
    MKBXDUpdateController *vc = [[MKBXDUpdateController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushDeviceInfoPage {
    MKBXDDeviceInfoController *vc = [[MKBXDDeviceInfoController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - interface
- (void)saveDataToDevice {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel configDataWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success"];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)readDataFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel readDataWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        MKTextFieldCellModel *cellModel1 = self.section4List[0];
        cellModel1.textFieldValue = self.dataModel.deviceName;
        
        MKBXDDeviceIDCellModel *cellModel2 = self.section5List[0];
        cellModel2.deviceID = self.dataModel.deviceID;
        
        [self.tableView reloadData];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)commandPowerOff {
    [[MKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    [MKBXDInterface bxd_powerOffWithSucBlock:^{
        [[MKHudManager share] hide];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)commandResetDevice {
    [[MKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    [MKBXDInterface bxd_factoryResetWithSucBlock:^{
        [[MKHudManager share] hide];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)setPasswordToDevice {
    NSString *password = self.passwordAsciiStr;
    NSString *confirmpassword = self.confirmAsciiStr;
    if (!ValidStr(password) || !ValidStr(confirmpassword) || password.length > 16 || confirmpassword.length > 16) {
        [self.view showCentralToast:@"Length error."];
        return;
    }
    if (![password isEqualToString:confirmpassword]) {
        [self.view showCentralToast:@"Password do not match! Please try again."];
        return;
    }
    [[MKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    [MKBXDInterface bxd_configConnectPassword:password sucBlock:^{
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success"];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    [self loadSection0Datas];
    [self loadSection1Datas];
    [self loadSection2Datas];
    [self loadSection3Datas];
    [self loadSection4Datas];
    [self loadSection5Datas];
    
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    MKNormalTextCellModel *cellModel1 = [[MKNormalTextCellModel alloc] init];
    cellModel1.leftMsg = @"Quick switch";
    cellModel1.showRightIcon = YES;
    [self.section0List addObject:cellModel1];
    
    MKNormalTextCellModel *cellModel2 = [[MKNormalTextCellModel alloc] init];
    cellModel2.leftMsg = @"Turn off Beacon";
    cellModel2.showRightIcon = YES;
    [self.section0List addObject:cellModel2];
}

- (void)loadSection1Datas {
    MKNormalTextCellModel *cellModel = [[MKNormalTextCellModel alloc] init];
    cellModel.leftMsg = @"Reset Beacon";
    cellModel.showRightIcon = YES;
    [self.section1List addObject:cellModel];
}

- (void)loadSection2Datas {
    MKNormalTextCellModel *cellModel = [[MKNormalTextCellModel alloc] init];
    cellModel.leftMsg = @"Modify password";
    cellModel.showRightIcon = YES;
    [self.section2List addObject:cellModel];
}

- (void)loadSection3Datas {
    MKNormalTextCellModel *cellModel1 = [[MKNormalTextCellModel alloc] init];
    cellModel1.leftMsg = @"DFU";
    cellModel1.showRightIcon = YES;
    [self.section3List addObject:cellModel1];
    
    MKNormalTextCellModel *cellModel2 = [[MKNormalTextCellModel alloc] init];
    cellModel2.leftMsg = @"Device info";
    cellModel2.showRightIcon = YES;
    [self.section3List addObject:cellModel2];
}

- (void)loadSection4Datas {
    MKTextFieldCellModel *cellModel = [[MKTextFieldCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = @"Device Name";
    cellModel.textPlaceholder = @"1-10 characters";
    cellModel.textFieldType = mk_normal;
    cellModel.maxLength = 10;
    [self.section4List addObject:cellModel];
}

- (void)loadSection5Datas {
    MKBXDDeviceIDCellModel *cellModel = [[MKBXDDeviceIDCellModel alloc] init];
    [self.section5List addObject:cellModel];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"DEVICE";
    self.view.backgroundColor = RGBCOLOR(242, 242, 242);
    [self.rightButton setImage:LOADICON(@"MKBeaconXDButton", @"MKBXDDeviceController", @"bxd_slotSaveIcon.png") forState:UIControlStateNormal];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(defaultTopInset);
        make.bottom.mas_equalTo(-VirtualHomeHeight - 49.f);
    }];
}

#pragma mark - getter
- (MKBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)section0List {
    if (!_section0List) {
        _section0List = [NSMutableArray array];
    }
    return _section0List;
}

- (NSMutableArray *)section1List {
    if (!_section1List) {
        _section1List = [NSMutableArray array];
    }
    return _section1List;
}

- (NSMutableArray *)section2List {
    if (!_section2List) {
        _section2List = [NSMutableArray array];
    }
    return _section2List;
}

- (NSMutableArray *)section3List {
    if (!_section3List) {
        _section3List = [NSMutableArray array];
    }
    return _section3List;
}

- (NSMutableArray *)section4List {
    if (!_section4List) {
        _section4List = [NSMutableArray array];
    }
    return _section4List;
}

- (NSMutableArray *)section5List {
    if (!_section5List) {
        _section5List = [NSMutableArray array];
    }
    return _section5List;
}

- (MKBXDDevicePageModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKBXDDevicePageModel alloc] init];
    }
    return _dataModel;
}

@end
