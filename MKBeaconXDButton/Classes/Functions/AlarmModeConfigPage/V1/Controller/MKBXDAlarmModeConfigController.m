//
//  MKBXDAlarmModeConfigController.m
//  MKBeaconXDButton_Example
//
//  Created by aa on 2022/2/19.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXDAlarmModeConfigController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"

#import "MKHudManager.h"
#import "MKCustomUIAdopter.h"
#import "MKTableSectionLineHeader.h"
#import "MKNormalTextCell.h"
#import "MKTextFieldCell.h"
#import "MKTextSwitchCell.h"
#import "MKNormalSliderCell.h"
#import "MKAlertView.h"

#import "MKBXDAlarmModeConfigModel.h"

#import "MKBXDDeviceIDCell.h"
#import "MKBXDTxPowerCell.h"
#import "MKBXDAbnormalInactivityTimeCell.h"

#import "MKBXDAlarmNotiTypeController.h"

@interface MKBXDAlarmModeConfigController ()<UITableViewDelegate,
UITableViewDataSource,
mk_textSwitchCellDelegate,
MKTextFieldCellDelegate,
MKNormalSliderCellDelegate,
MKBXDDeviceIDCellDelegate,
MKBXDTxPowerCellDelegate,
MKBXDAbnormalInactivityTimeCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *section2List;

@property (nonatomic, strong)NSMutableArray *section3List;

@property (nonatomic, strong)NSMutableArray *section4List;

@property (nonatomic, strong)NSMutableArray *section5List;

@property (nonatomic, strong)NSMutableArray *section6List;

@property (nonatomic, strong)NSMutableArray *section7List;

@property (nonatomic, strong)NSMutableArray *section8List;

@property (nonatomic, strong)NSMutableArray *section9List;

@property (nonatomic, strong)NSMutableArray *section10List;

@property (nonatomic, strong)NSMutableArray *headerList;

@property (nonatomic, strong)MKBXDAlarmModeConfigModel *dataModel;

@end

@implementation MKBXDAlarmModeConfigController

- (void)dealloc {
    NSLog(@"MKBXDAlarmModeConfigController销毁");
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];
    //本页面禁止右划退出手势
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self readDatasFromDevice];
}

#pragma mark - super method
- (void)rightButtonMethod {
    [self saveDataToDevice];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 7) {
        return 95.f;
    }
    if (indexPath.section == 4 || indexPath.section == 5 || indexPath.section == 9) {
        return 60.f;
    }
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }
    if (self.dataModel.advIsOn && section == 1) {
        return 10;
    }
    if (self.dataModel.alarmMode && section == 6) {
        return 10;
    }
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MKTableSectionLineHeader *headerView = [MKTableSectionLineHeader initHeaderViewWithTableView:tableView];
    headerView.headerModel = self.headerList[section];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 10 && indexPath.row == 0) {
        MKBXDAlarmNotiTypeController *vc = [[MKBXDAlarmNotiTypeController alloc] init];
        vc.pageType = self.pageType;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.headerList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self loadSectionNumbersWithSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self loadCellWithIndexPath:indexPath];
}

#pragma mark - mk_textSwitchCellDelegate
/// 开关状态发生改变了
/// @param isOn 当前开关状态
/// @param index 当前cell所在的index
- (void)mk_textSwitchCellStatusChanged:(BOOL)isOn index:(NSInteger)index {
    if (index == 0) {
        //SLOT advertisement
        self.dataModel.advIsOn = isOn;
        MKTextSwitchCellModel *cellModel = self.section0List[0];
        cellModel.isOn = isOn;
        [self.tableView reloadData];
        return;
    }
    if (index == 1) {
        //Alarm mode
        self.dataModel.alarmMode = isOn;
        MKTextSwitchCellModel *cellModel = self.section6List[0];
        cellModel.isOn = isOn;
        [self.tableView reloadData];
        return;
    }
    if (index == 2) {
        //Stay advertising before triggered
        self.dataModel.stayAdv = isOn;
        MKTextSwitchCellModel *cellModel = self.section6List[1];
        cellModel.isOn = isOn;
        return;
    }
}

#pragma mark - MKTextFieldCellDelegate
/// textField内容发送改变时的回调事件
/// @param index 当前cell所在的index
/// @param value 当前textField的值
- (void)mk_deviceTextCellValueChanged:(NSInteger)index textValue:(NSString *)value {
    if (index == 0) {
        //Adv interval
        self.dataModel.advInterval = value;
        MKTextFieldCellModel *cellModel = self.section3List[0];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 1) {
        //Advertising time
        self.dataModel.alarmMode_advTime = value;
        MKTextFieldCellModel *cellModel1 = self.section8List[0];
        cellModel1.textFieldValue = value;
        if (self.pageType == MKBXDAlarmModeConfigControllerType_abnormal) {
            MKBXDAbnormalInactivityTimeCellModel *cellModel2 = self.section7List[0];
            cellModel2.advTime = value;
            [self.tableView mk_reloadSection:7 withRowAnimation:UITableViewRowAnimationNone];
        }
        return;
    }
    if (index == 2) {
        //Adv interval
        self.dataModel.alarmMode_advInterval = value;
        MKTextFieldCellModel *cellModel = self.section8List[1];
        cellModel.textFieldValue = value;
        return;
    }
}

#pragma mark - MKNormalSliderCellDelegate
/// slider值发生改变的回调事件
/// @param value 当前slider的值
/// @param index 当前cell所在的index
- (void)mk_normalSliderValueChanged:(NSInteger)value index:(NSInteger)index {
    if (index == 0) {
        //Ranging data
        self.dataModel.rangingData = value;
        MKNormalSliderCellModel *cellModel = self.section4List[0];
        cellModel.sliderValue = value;
        return;
    }
}

#pragma mark - MKBXDDeviceIDCellDelegate
- (void)bxd_deviceIDChanged:(NSString *)text {
    self.dataModel.deviceID = text;
    MKBXDDeviceIDCellModel *cellModel = self.section2List[0];
    cellModel.deviceID = text;
}

#pragma mark - MKBXDTxPowerCellDelegate
/*
 0:-40dBm
 1:-20dBm
 2:-16dBm
 3:-12dBm
 4:-8dBm
 5:-4dBm
 6:0dBm
 7:+3dBm
 8:+4dBm
 */
- (void)bxd_txPowerChanged:(NSInteger)index txPower:(NSInteger)txPower {
    if (index == 0) {
        //Tx Power
        self.dataModel.txPower = txPower;
        MKBXDTxPowerCellModel *cellModel = self.section5List[0];
        cellModel.txPower = txPower;
        return;
    }
    if (index == 1) {
        //Alarm mode Tx Power
        self.dataModel.alarmMode_txPower = txPower;
        MKBXDTxPowerCellModel *cellModel = self.section9List[0];
        cellModel.txPower = txPower;
        return;
    }
}

#pragma mark - MKBXDAbnormalInactivityTimeCellDelegate
- (void)bxd_abnormalInactivityTimeChanged:(NSString *)time {
    //Abnormal inactivity time
    self.dataModel.abnormalTime = time;
    MKBXDAbnormalInactivityTimeCellModel *cellModel = self.section7List[0];
    cellModel.time = time;
    return;
}

#pragma mark - loadCellDatas
- (UITableViewCell *)loadCellWithIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        //SLOT advertisement
        MKTextSwitchCell *cell = [MKTextSwitchCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section0List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 1) {
        //Parameters
        MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section1List[indexPath.row];
        return cell;
    }
    if (indexPath.section == 2) {
        //Device ID
        MKBXDDeviceIDCell *cell = [MKBXDDeviceIDCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section2List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 3) {
        //Adv interval
        MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section3List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 4) {
        //Ranging data
        MKNormalSliderCell *cell = [MKNormalSliderCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section4List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 5) {
        //Tx Power
        MKBXDTxPowerCell *cell = [MKBXDTxPowerCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section5List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 6) {
        //Alarm mode/Stay advertising before triggered
        MKTextSwitchCell *cell = [MKTextSwitchCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section6List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 7) {
        //Abnormal inactivity time
        MKBXDAbnormalInactivityTimeCell *cell = [MKBXDAbnormalInactivityTimeCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section7List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 8) {
        //Advertising time/Adv interval
        MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section8List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 9) {
        //Alarm mode Tx Power
        MKBXDTxPowerCell *cell = [MKBXDTxPowerCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section9List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:self.tableView];
    cell.dataModel = self.section10List[indexPath.row];
    return cell;
}

- (NSInteger)loadSectionNumbersWithSection:(NSInteger)section {
    if (section == 0) {
        return self.section0List.count;
    }
    if (!self.dataModel.advIsOn) {
        return 0;
    }
    if (section == 1) {
        return self.section1List.count;
    }
    if (section == 2) {
        //隐藏deviceID
        return 0;
//        return self.section2List.count;
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
    if (section == 6) {
        //section6List里面包含Alarm mode和Stay advertising before triggered，Alarm mode关闭的时候Stay advertising before triggered需要隐藏
        return (self.dataModel.alarmMode ? self.section6List.count : 1);
    }
    if (section == 7 && self.dataModel.alarmMode) {
        return (self.pageType == MKBXDAlarmModeConfigControllerType_abnormal ? self.section7List.count : 0);
    }
    if (section == 8 && self.dataModel.alarmMode) {
        return self.section8List.count;
    }
    if (section == 9 && self.dataModel.alarmMode) {
        return self.section9List.count;
    }
    if (section == 10 && self.dataModel.alarmMode) {
        return self.section10List.count;
    }
    return 0;
}

#pragma mark - interface
- (void)readDatasFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel readDataWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self loadSectionDatas];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)saveDataToDevice {
    if (!self.dataModel.advIsOn) {
        BOOL valid = YES;
        if (self.pageType == MKBXDAlarmModeConfigControllerType_single) {
            if (!self.dataModel.doubleIsOn && !self.dataModel.longIsOn && !self.dataModel.inactivityIsOn) {
                valid = NO;
            }
        } else if (self.pageType == MKBXDAlarmModeConfigControllerType_double) {
            if (!self.dataModel.singleIsOn && !self.dataModel.longIsOn && !self.dataModel.inactivityIsOn) {
                valid = NO;
            }
        } else if (self.pageType == MKBXDAlarmModeConfigControllerType_long) {
            if (!self.dataModel.singleIsOn && !self.dataModel.doubleIsOn  && !self.dataModel.inactivityIsOn) {
                valid = NO;
            }
        } else if (self.pageType == MKBXDAlarmModeConfigControllerType_abnormal) {
            if (!self.dataModel.singleIsOn && !self.dataModel.doubleIsOn  && !self.dataModel.longIsOn) {
                valid = NO;
            }
        }
        if (!valid) {
            MKAlertViewAction *cancelAction = [[MKAlertViewAction alloc] initWithTitle:@"OK" handler:^{
                
            }];
            NSString *msg = @"*Please ensure that at lease 1 SLOT is enabled";
            MKAlertView *alertView = [[MKAlertView alloc] init];
            [alertView addAction:cancelAction];
            [alertView showAlertWithTitle:@"Warning!" message:msg notificationName:@"mk_bxd_needDismissAlert"];
            return;
        }
    }
    
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

#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    [self loadSection0Datas];
    [self loadSection1Datas];
    [self loadSection2Datas];
    [self loadSection3Datas];
    [self loadSection4Datas];
    [self loadSection5Datas];
    [self loadSection6Datas];
    [self loadSection7Datas];
    [self loadSection8Datas];
    [self loadSection9Datas];
    [self loadSection10Datas];
    
    for (NSInteger i = 0; i < 11; i ++) {
        MKTableSectionLineHeaderModel *headerModel = [[MKTableSectionLineHeaderModel alloc] init];
        [self.headerList addObject:headerModel];
    }
    
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    MKTextSwitchCellModel *cellModel = [[MKTextSwitchCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = @"SLOT advertisement";
    cellModel.isOn = self.dataModel.advIsOn;
    [self.section0List addObject:cellModel];
}

- (void)loadSection1Datas {
    MKNormalTextCellModel *cellModel = [[MKNormalTextCellModel alloc] init];
    cellModel.leftMsg = @"Parameters";
    [self.section1List addObject:cellModel];
}

- (void)loadSection2Datas {
    MKBXDDeviceIDCellModel *cellModel = [[MKBXDDeviceIDCellModel alloc] init];
    cellModel.deviceID = self.dataModel.deviceID;
    [self.section2List addObject:cellModel];
}

- (void)loadSection3Datas {
    MKTextFieldCellModel *cellModel = [[MKTextFieldCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = @"Adv interval";
    cellModel.textPlaceholder = @"1~500";
    cellModel.textFieldType = mk_realNumberOnly;
    cellModel.textFieldValue = self.dataModel.advInterval;
    cellModel.maxLength = 3;
    cellModel.unit = @"x20ms";
    [self.section3List addObject:cellModel];
}

- (void)loadSection4Datas {
    MKNormalSliderCellModel *cellModel = [[MKNormalSliderCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = [MKCustomUIAdopter attributedString:@[@"Ranging data",@"   (-100dBm~0dBm)"] fonts:@[MKFont(15.f),MKFont(13.f)] colors:@[DEFAULT_TEXT_COLOR,RGBCOLOR(223, 223, 223)]];
    cellModel.sliderMinValue = -100;
    cellModel.sliderValue = self.dataModel.rangingData;
    [self.section4List addObject:cellModel];
}

- (void)loadSection5Datas {
    MKBXDTxPowerCellModel *cellModel = [[MKBXDTxPowerCellModel alloc] init];
    cellModel.index = 0;
    cellModel.txPower = self.dataModel.txPower;
    [self.section5List addObject:cellModel];
}

- (void)loadSection6Datas {
    MKTextSwitchCellModel *cellModel1 = [[MKTextSwitchCellModel alloc] init];
    cellModel1.index = 1;
    cellModel1.msg = @"Alarm mode";
    cellModel1.isOn = self.dataModel.alarmMode;
    [self.section6List addObject:cellModel1];
    
    MKTextSwitchCellModel *cellModel2 = [[MKTextSwitchCellModel alloc] init];
    cellModel2.index = 2;
    cellModel2.msg = @"Stay advertising before triggered";
    cellModel2.isOn = self.dataModel.stayAdv;
    [self.section6List addObject:cellModel2];
}

- (void)loadSection7Datas {
    MKBXDAbnormalInactivityTimeCellModel *cellModel = [[MKBXDAbnormalInactivityTimeCellModel alloc] init];
    cellModel.time = self.dataModel.abnormalTime;
    cellModel.advTime = self.dataModel.alarmMode_advTime;
    [self.section7List addObject:cellModel];
}

- (void)loadSection8Datas {
    MKTextFieldCellModel *cellModel1 = [[MKTextFieldCellModel alloc] init];
    cellModel1.index = 1;
    cellModel1.msg = @"Advertising time";
    cellModel1.textPlaceholder = @"1~65535";
    cellModel1.textFieldType = mk_realNumberOnly;
    cellModel1.textFieldValue = self.dataModel.alarmMode_advTime;
    cellModel1.maxLength = 5;
    cellModel1.unit = @"s";
    [self.section8List addObject:cellModel1];
    
    MKTextFieldCellModel *cellModel2 = [[MKTextFieldCellModel alloc] init];
    cellModel2.index = 2;
    cellModel2.msg = @"Adv interval";
    cellModel2.textPlaceholder = @"1~500";
    cellModel2.textFieldType = mk_realNumberOnly;
    cellModel2.textFieldValue = self.dataModel.alarmMode_advInterval;
    cellModel2.maxLength = 3;
    cellModel2.unit = @"x20ms";
    [self.section8List addObject:cellModel2];
}

- (void)loadSection9Datas {
    MKBXDTxPowerCellModel *cellModel = [[MKBXDTxPowerCellModel alloc] init];
    cellModel.index = 1;
    cellModel.txPower = self.dataModel.alarmMode_txPower;
    [self.section9List addObject:cellModel];
}

- (void)loadSection10Datas {
    MKNormalTextCellModel *cellModel = [[MKNormalTextCellModel alloc] init];
    cellModel.leftMsg = @"Trigger notification type";
    cellModel.showRightIcon = YES;
    [self.section10List addObject:cellModel];
}

#pragma mark - UI
- (void)loadSubViews {
    if (self.pageType == MKBXDAlarmModeConfigControllerType_single) {
        self.defaultTitle = @"Single press mode";
    }else if (self.pageType == MKBXDAlarmModeConfigControllerType_double) {
        self.defaultTitle = @"Double press mode";
    }else if (self.pageType == MKBXDAlarmModeConfigControllerType_long) {
        self.defaultTitle = @"Long press mode";
    }else if (self.pageType == MKBXDAlarmModeConfigControllerType_abnormal) {
        self.defaultTitle = @"Abnormal inactivity mode";
    }
    self.view.backgroundColor = RGBCOLOR(242, 242, 242);
    [self.rightButton setImage:LOADICON(@"MKBeaconXDButton", @"MKBXDAlarmModeConfigController", @"bxd_slotSaveIcon.png") forState:UIControlStateNormal];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
    }];
}

#pragma mark - getter
- (MKBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.backgroundColor = RGBCOLOR(242, 242, 242);
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

- (NSMutableArray *)section6List {
    if (!_section6List) {
        _section6List = [NSMutableArray array];
    }
    return _section6List;
}

- (NSMutableArray *)section7List {
    if (!_section7List) {
        _section7List = [NSMutableArray array];
    }
    return _section7List;
}

- (NSMutableArray *)section8List {
    if (!_section8List) {
        _section8List = [NSMutableArray array];
    }
    return _section8List;
}

- (NSMutableArray *)section9List {
    if (!_section9List) {
        _section9List = [NSMutableArray array];
    }
    return _section9List;
}

- (NSMutableArray *)section10List {
    if (!_section10List) {
        _section10List = [NSMutableArray array];
    }
    return _section10List;
}

- (NSMutableArray *)headerList {
    if (!_headerList) {
        _headerList = [NSMutableArray array];
    }
    return _headerList;
}

- (MKBXDAlarmModeConfigModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKBXDAlarmModeConfigModel alloc] init];
        _dataModel.alarmType = self.pageType;
    }
    return _dataModel;
}

@end
