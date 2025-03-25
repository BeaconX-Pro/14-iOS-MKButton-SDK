//
//  MKBXDAlarmModeConfigV2Controller.m
//  MKBeaconXDButton_Example
//
//  Created by aa on 2024/11/25.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "MKBXDAlarmModeConfigV2Controller.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKBaseTableView.h"
#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"

#import "MKHudManager.h"
#import "MKTableSectionLineHeader.h"
#import "MKNormalTextCell.h"
#import "MKTextSwitchCell.h"
#import "MKTextFieldCell.h"

#import "MKBXDConnectManager.h"

#import "MKBXDAlarmModeConfigV2Model.h"

#import "MKBXDSlotFramePickCell.h"
#import "MKBXDSlotBeaconCell.h"
#import "MKBXDSlotUIDCell.h"

#import "MKBXDSlotParamCell.h"
#import "MKBXDAbnormalInactivityTimeCell.h"
#import "MKBXDTxPowerCell.h"
#import "MKBXDTriggerTypeClickCell.h"
#import "MKBXDAlarmTypePickCell.h"

@interface MKBXDAlarmModeConfigV2Controller ()<UITableViewDelegate,
UITableViewDataSource,
mk_textSwitchCellDelegate,
MKTextFieldCellDelegate,
MKBXDSlotFramePickCellDelegate,
MKBXDSlotBeaconCellDelegate,
MKBXDSlotUIDCellDelegate,
MKBXDSlotParamCellDelegate,
MKBXDAbnormalInactivityTimeCellDelegate,
MKBXDTxPowerCellDelegate,
MKBXDTriggerTypeClickCellDelegate,
MKBXDAlarmTypePickCellDelegate>

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

@property (nonatomic, strong)NSMutableArray *section11List;

@property (nonatomic, strong)NSMutableArray *section12List;

@property (nonatomic, strong)NSMutableArray *headerList;

@property (nonatomic, strong)MKBXDAlarmModeConfigV2Model *dataModel;

@end

@implementation MKBXDAlarmModeConfigV2Controller

- (void)dealloc {
    NSLog(@"MKBXDAlarmModeConfigV2Controller销毁");
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
    [self readDataFromDevice];
}

#pragma mark - super method
- (void)rightButtonMethod {
    [self saveDataToDevice];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return 130.f;
    }
    if (indexPath.section == 2 && indexPath.row == 0) {
        if (self.dataModel.slotType == bxd_slotType_uid) {
            return 120.f;
        }
        if (self.dataModel.slotType == bxd_slotType_beacon) {
            return 160.f;
        }
        return 0.f;
    }
    if (indexPath.section == 3 && indexPath.row == 0) {
        return 180.f;
    }
    if (indexPath.section == 5 && indexPath.row == 0) {
        return 95.f;
    }
    if (indexPath.section == 7) {
        return 60.f;
    }
    
    if (indexPath.section == 9) {
        return 180.f;
    }
    
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10.f;
    }
    if (!self.dataModel.advIsOn) {
        return 0;
    }
    if (section == 1 || section == 2 || section == 3 || section == 4 || section == 8) {
        return 10.f;
    }
    if (self.dataModel.alarmMode && self.dataModel.showTriggerType) {
        if (section == 10) {
            BOOL need = NO;
            if (self.dataModel.alarmNotiType == 1) {
                //LED
                need = YES;
            }else if ([MKBXDConnectManager shared].isCR && (self.dataModel.alarmNotiType == 4 || self.dataModel.alarmNotiType == 5)) {
                //BXP-C:  LED+Vibration/LED+Buzzer
                need = YES;
            }else if (![MKBXDConnectManager shared].isCR && self.dataModel.alarmNotiType == 3) {
                //BXP-B-D:  LED+Buzzer
                need = YES;
            }
            return (need ? 25.f : 0.f);
        }
        if (section == 11) {
            BOOL need = NO;
            if ([MKBXDConnectManager shared].isCR && (self.dataModel.alarmNotiType == 2 || self.dataModel.alarmNotiType == 4)) {
                //Vibaration/LED+Vibration
                need = YES;
            }
            return (need ? 25.f : 0.f);
        }
        if (section == 12) {
            BOOL need = NO;
            if ([MKBXDConnectManager shared].isCR && (self.dataModel.alarmNotiType == 3 || self.dataModel.alarmNotiType == 5)) {
                //BXP-C:  Buzzer/LED+Buzzer
                need = YES;
            }else if (![MKBXDConnectManager shared].isCR && (self.dataModel.alarmNotiType == 2 || self.dataModel.alarmNotiType == 3)) {
                //BXP-B-D:  Buzzer/LED+Buzzer
                need = YES;
            }
            return (need ? 25.f : 0.f);
        }
    }
    
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MKTableSectionLineHeader *headerView = [MKTableSectionLineHeader initHeaderViewWithTableView:tableView];
    headerView.headerModel = self.headerList[section];
    return headerView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.headerList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
        return (self.dataModel.slotType == bxd_slotType_alarmInfo ? 0 : self.section2List.count);
    }
    if (section == 3) {
        return self.section3List.count;
    }
    if (section == 4) {
        //section4List里面包含Alarm mode和Stay advertising before triggered，Alarm mode关闭的时候Stay advertising before triggered需要隐藏
        return (self.dataModel.alarmMode ? self.section4List.count : 1);
    }
    if (!self.dataModel.alarmMode) {
        return 0;
    }
    if (section == 5) {
        return (self.pageType == MKBXDAlarmModeConfigV2ControllerType_abnormal ? self.section5List.count : 0);
    }
    if (section == 6) {
        return self.section6List.count;
    }
    if (section == 7) {
        return self.section7List.count;
    }
    if (section == 8) {
        return self.section8List.count;
    }
    if (self.dataModel.showTriggerType) {
        if (section == 9) {
            //Alarm notification type
            return self.section9List.count;
        }
        if (section == 10) {
            BOOL need = NO;
            if (self.dataModel.alarmNotiType == 1) {
                //LED
                need = YES;
            }else if ([MKBXDConnectManager shared].isCR && (self.dataModel.alarmNotiType == 4 || self.dataModel.alarmNotiType == 5)) {
                //BXP-C:  LED+Vibration/LED+Buzzer
                need = YES;
            }else if (![MKBXDConnectManager shared].isCR && self.dataModel.alarmNotiType == 3) {
                //BXP-B-D:  LED+Buzzer
                need = YES;
            }
            return (need ? self.section10List.count : 0);
        }
        if (section == 11) {
            BOOL need = NO;
            if ([MKBXDConnectManager shared].isCR && (self.dataModel.alarmNotiType == 2 || self.dataModel.alarmNotiType == 4)) {
                //Vibaration/LED+Vibration
                need = YES;
            }
            return (need ? self.section11List.count : 0);
        }
        if (section == 12) {
            BOOL need = NO;
            if ([MKBXDConnectManager shared].isCR && (self.dataModel.alarmNotiType == 3 || self.dataModel.alarmNotiType == 5)) {
                //BXP-C:  Buzzer/LED+Buzzer
                need = YES;
            }else if (![MKBXDConnectManager shared].isCR && (self.dataModel.alarmNotiType == 2 || self.dataModel.alarmNotiType == 3)) {
                //BXP-B-D:  Buzzer/LED+Buzzer
                need = YES;
            }
            return (need ? self.section12List.count : 0);
        }
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKTextSwitchCell *cell = [MKTextSwitchCell initCellWithTableView:tableView];
        cell.dataModel = self.section0List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 1) {
        MKBXDSlotFramePickCell *cell = [MKBXDSlotFramePickCell initCellWithTableView:tableView];
        cell.dataModel = self.section1List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 2) {
        return [self loadSection2Cell:indexPath.row];
    }
    if (indexPath.section == 3) {
        MKBXDSlotParamCell *cell = [MKBXDSlotParamCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section3List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 4) {
        //Alarm mode/Stay advertising before triggered
        MKTextSwitchCell *cell = [MKTextSwitchCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section4List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 5) {
        //Abnormal inactivity time
        MKBXDAbnormalInactivityTimeCell *cell = [MKBXDAbnormalInactivityTimeCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section5List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 6) {
        //Advertising time/Adv interval
        MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section6List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 7) {
        //Alarm mode Tx Power
        MKBXDTxPowerCell *cell = [MKBXDTxPowerCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section7List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 8) {
        //Trigger notification type
        MKBXDTriggerTypeClickCell *cell = [MKBXDTriggerTypeClickCell initCellWithTableView:tableView];
        cell.dataModel = self.section8List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 9) {
        //Alarm notification type
        MKBXDAlarmTypePickCell *cell = [MKBXDAlarmTypePickCell initCellWithTableView:tableView];
        cell.dataModel = self.section9List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 10) {
        //LED notification
        MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section10List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 11) {
        //Vibration notification
        MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section11List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    //Buzzer notification
    MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:self.tableView];
    cell.dataModel = self.section12List[indexPath.row];
    cell.delegate = self;
    return cell;
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
        MKTextSwitchCellModel *cellModel = self.section4List[0];
        cellModel.isOn = isOn;
        [self.tableView reloadData];
        return;
    }
    if (index == 2) {
        //Stay advertising before triggered
        self.dataModel.stayAdv = isOn;
        MKTextSwitchCellModel *cellModel = self.section4List[1];
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
        //Advertising time
        self.dataModel.alarmMode_advTime = value;
        MKTextFieldCellModel *cellModel1 = self.section6List[0];
        cellModel1.textFieldValue = value;
        if (self.pageType == MKBXDAlarmModeConfigV2ControllerType_abnormal) {
            MKBXDAbnormalInactivityTimeCellModel *cellModel2 = self.section5List[0];
            cellModel2.advTime = value;
            [self.tableView mk_reloadSection:5 withRowAnimation:UITableViewRowAnimationNone];
        }
        return;
    }
    if (index == 1) {
        //Adv interval
        self.dataModel.alarmMode_advInterval = value;
        MKTextFieldCellModel *cellModel = self.section6List[1];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 2) {
        //Blinking time
        self.dataModel.blinkingTime = value;
        MKTextFieldCellModel *cellModel = self.section10List[0];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 3) {
        //Blinking interval
        self.dataModel.blinkingInterval = value;
        MKTextFieldCellModel *cellModel = self.section10List[1];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 4) {
        //Vibrating time
        self.dataModel.vibratingTime = value;
        MKTextFieldCellModel *cellModel = self.section11List[0];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 5) {
        //Vibrating Interval
        self.dataModel.vibratingInterval = value;
        MKTextFieldCellModel *cellModel = self.section11List[0];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 6) {
        //Ringing time
        self.dataModel.ringingTime = value;
        MKTextFieldCellModel *cellModel = self.section12List[0];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 7) {
        //Ringing Interval
        self.dataModel.ringingInterval = value;
        MKTextFieldCellModel *cellModel = self.section12List[0];
        cellModel.textFieldValue = value;
        return;
    }
}

#pragma mark - MKBXDSlotFramePickCellDelegate
- (void)bxd_slotFrameTypeChanged:(bxd_slotType)frameType {
    self.dataModel.slotType = frameType;
    MKBXDSlotFramePickCellModel *cellModel = self.section1List[0];
    cellModel.frameType = frameType;
    
    [self loadSection2Datas];
    
    [self.tableView mk_reloadSection:2 withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - MKBXDSlotBeaconCellDelegate
- (void)bxd_advContent_majorChanged:(NSString *)major {
    self.dataModel.major = major;
    MKBXDSlotBeaconCellModel *cellModel = self.section2List[0];
    cellModel.major = major;
}

- (void)bxd_advContent_minorChanged:(NSString *)minor {
    self.dataModel.minor = minor;
    MKBXDSlotBeaconCellModel *cellModel = self.section2List[0];
    cellModel.minor = minor;
}

- (void)bxd_advContent_uuidChanged:(NSString *)uuid {
    self.dataModel.uuid = uuid;
    MKBXDSlotBeaconCellModel *cellModel = self.section2List[0];
    cellModel.uuid = uuid;
}

#pragma mark - MKBXDSlotUIDCellDelegate
- (void)bxd_advContent_namespaceIDChanged:(NSString *)text {
    self.dataModel.namespaceID = text;
    MKBXDSlotUIDCellModel *cellModel = self.section2List[0];
    cellModel.namespaceID = text;
}

- (void)bxd_advContent_instanceIDChanged:(NSString *)text {
    self.dataModel.instanceID = text;
    MKBXDSlotUIDCellModel *cellModel = self.section2List[0];
    cellModel.instanceID = text;
}

#pragma mark - MKBXDSlotParamCellDelegate
- (void)bxd_slotParam_advIntervalChanged:(NSString *)interval {
    self.dataModel.advInterval = interval;
    MKBXDSlotParamCellModel *cellModel = self.section3List[0];
    cellModel.interval = interval;
}

- (void)bxd_slotParam_rssiChanged:(NSInteger)rssi {
    self.dataModel.rangingData = rssi;
    MKBXDSlotParamCellModel *cellModel = self.section3List[0];
    cellModel.rssi = rssi;
}

- (void)bxd_slotParam_txPowerChanged:(NSInteger)txPower {
    self.dataModel.txPower = txPower;
    MKBXDSlotParamCellModel *cellModel = self.section3List[0];
    cellModel.txPower = txPower;
}

#pragma mark - MKBXDAbnormalInactivityTimeCellDelegate
- (void)bxd_abnormalInactivityTimeChanged:(NSString *)time {
    //Abnormal inactivity time
    self.dataModel.abnormalTime = time;
    MKBXDAbnormalInactivityTimeCellModel *cellModel = self.section5List[0];
    cellModel.time = time;
    return;
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
        //Alarm mode Tx Power
        self.dataModel.alarmMode_txPower = txPower;
        MKBXDTxPowerCellModel *cellModel = self.section7List[0];
        cellModel.txPower = txPower;
        return;
    }
}

#pragma mark - MKBXDTriggerTypeClickCellDelegate
- (void)bxd_triggerTypeClickCell_pressed:(BOOL)selected {
    self.dataModel.showTriggerType = selected;
    MKBXDTriggerTypeClickCellModel *cellModel = self.section8List[0];
    cellModel.selected = selected;
    
    NSIndexSet *sectionsToReload = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(9, 4)];
    
    [self.tableView reloadSections:sectionsToReload withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - MKBXDAlarmTypePickCellDelegate
- (void)bxd_triggerAlarmTypeChanged:(NSInteger)triggerAlarmType {
    self.dataModel.alarmNotiType = triggerAlarmType;
    MKBXDAlarmTypePickCellModel *cellModel = self.section9List[0];
    cellModel.triggerAlarmType = triggerAlarmType;
    
    NSIndexSet *sectionsToReload = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(10, 3)];
    
    [self.tableView reloadSections:sectionsToReload withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - interface
- (void)readDataFromDevice {
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

#pragma mark - private method
- (UITableViewCell *)loadSection2Cell:(NSInteger)row {
    if (self.dataModel.slotType == bxd_slotType_uid) {
        MKBXDSlotUIDCell *cell = [MKBXDSlotUIDCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section2List[row];
        cell.delegate = self;
        return cell;
    }
    if (self.dataModel.slotType == bxd_slotType_beacon) {
        MKBXDSlotBeaconCell *cell = [MKBXDSlotBeaconCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section2List[row];
        cell.delegate = self;
        return cell;
    }
    MKBaseCell *cell = [[MKBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKBXDAlarmModeConfigV2ControllerCell"];
    return cell;
}

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
    [self loadSection11Datas];
    [self loadSection12Datas];
        
    for (NSInteger i = 0; i < 13; i ++) {
        MKTableSectionLineHeaderModel *headerModel = [[MKTableSectionLineHeaderModel alloc] init];
        if (i == 10) {
            headerModel.text = @"LED notification";
        }else if (i == 11) {
            headerModel.text = @"Vibration notification";
        }else if (i == 12) {
            headerModel.text = @"Buzzer notification";
        }
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
    MKBXDSlotFramePickCellModel *cellModel = [[MKBXDSlotFramePickCellModel alloc] init];
    cellModel.frameType = self.dataModel.slotType;
    [self.section1List addObject:cellModel];
}

- (void)loadSection2Datas {
    [self.section2List removeAllObjects];
    
    if (self.dataModel.slotType == bxd_slotType_uid) {
        MKBXDSlotUIDCellModel *cellModel = [[MKBXDSlotUIDCellModel alloc] init];
        cellModel.namespaceID = self.dataModel.namespaceID;
        cellModel.instanceID = self.dataModel.instanceID;
        [self.section2List addObject:cellModel];
        return;
    }
    if (self.dataModel.slotType == bxd_slotType_beacon) {
        MKBXDSlotBeaconCellModel *cellModel = [[MKBXDSlotBeaconCellModel alloc] init];
        cellModel.major = self.dataModel.major;
        cellModel.minor = self.dataModel.minor;
        cellModel.uuid = self.dataModel.uuid;
        [self.section2List addObject:cellModel];
        return;
    }
}

- (void)loadSection3Datas {
    MKBXDSlotParamCellModel *cellModel = [[MKBXDSlotParamCellModel alloc] init];
    cellModel.cellType = self.dataModel.slotType;
    cellModel.interval = self.dataModel.advInterval;
    cellModel.rssi = self.dataModel.rangingData;
    cellModel.txPower = self.dataModel.txPower;
    [self.section3List addObject:cellModel];
}

- (void)loadSection4Datas {
    MKTextSwitchCellModel *cellModel1 = [[MKTextSwitchCellModel alloc] init];
    cellModel1.index = 1;
    cellModel1.msg = @"Alarm mode";
    cellModel1.isOn = self.dataModel.alarmMode;
    [self.section4List addObject:cellModel1];
    
    MKTextSwitchCellModel *cellModel2 = [[MKTextSwitchCellModel alloc] init];
    cellModel2.index = 2;
    cellModel2.msg = @"Stay advertising before triggered";
    cellModel2.isOn = self.dataModel.stayAdv;
    [self.section4List addObject:cellModel2];
}

- (void)loadSection5Datas {
    MKBXDAbnormalInactivityTimeCellModel *cellModel = [[MKBXDAbnormalInactivityTimeCellModel alloc] init];
    cellModel.time = self.dataModel.abnormalTime;
    cellModel.advTime = self.dataModel.alarmMode_advTime;
    [self.section5List addObject:cellModel];
}

- (void)loadSection6Datas {
    MKTextFieldCellModel *cellModel1 = [[MKTextFieldCellModel alloc] init];
    cellModel1.index = 0;
    cellModel1.msg = @"Advertising time";
    cellModel1.textPlaceholder = @"1~65535";
    cellModel1.textFieldType = mk_realNumberOnly;
    cellModel1.textFieldValue = self.dataModel.alarmMode_advTime;
    cellModel1.maxLength = 5;
    cellModel1.unit = @"s";
    [self.section6List addObject:cellModel1];
    
    MKTextFieldCellModel *cellModel2 = [[MKTextFieldCellModel alloc] init];
    cellModel2.index = 1;
    cellModel2.msg = @"Adv interval";
    cellModel2.textPlaceholder = @"1~500";
    cellModel2.textFieldType = mk_realNumberOnly;
    cellModel2.textFieldValue = self.dataModel.alarmMode_advInterval;
    cellModel2.maxLength = 3;
    cellModel2.unit = @"x20ms";
    [self.section6List addObject:cellModel2];
}

- (void)loadSection7Datas {
    MKBXDTxPowerCellModel *cellModel = [[MKBXDTxPowerCellModel alloc] init];
    cellModel.index = 0;
    cellModel.txPower = self.dataModel.alarmMode_txPower;
    [self.section7List addObject:cellModel];
}

- (void)loadSection8Datas {
    MKBXDTriggerTypeClickCellModel *cellModel = [[MKBXDTriggerTypeClickCellModel alloc] init];
    cellModel.selected = self.dataModel.showTriggerType;
    [self.section8List addObject:cellModel];
}

- (void)loadSection9Datas {
    MKBXDAlarmTypePickCellModel *cellModel = [[MKBXDAlarmTypePickCellModel alloc] init];
    cellModel.triggerAlarmType = self.dataModel.alarmNotiType;
    if ([MKBXDConnectManager shared].isCR) {
        cellModel.typeList = @[@"Silent",@"LED",@"Vibration",@"Buzzer",@"LED+Vibration",@"LED+Buzzer"];
    }else {
        cellModel.typeList = @[@"Silent",@"LED",@"Buzzer",@"LED+Buzzer"];
    }
    [self.section9List addObject:cellModel];
}

- (void)loadSection10Datas {
    MKTextFieldCellModel *cellModel1 = [[MKTextFieldCellModel alloc] init];
    cellModel1.index = 2;
    cellModel1.msg = @"Blinking time";
    cellModel1.textPlaceholder = @"1~6000";
    cellModel1.textFieldValue = self.dataModel.blinkingTime;
    cellModel1.textFieldType = mk_realNumberOnly;
    cellModel1.unit = @"x100ms";
    cellModel1.maxLength = 4;
    [self.section10List addObject:cellModel1];
    
    MKTextFieldCellModel *cellModel2 = [[MKTextFieldCellModel alloc] init];
    cellModel2.index = 3;
    cellModel2.msg = @"Blinking interval";
    cellModel2.textPlaceholder = @"0~100";
    cellModel2.textFieldValue = self.dataModel.blinkingInterval;
    cellModel2.textFieldType = mk_realNumberOnly;
    cellModel2.unit = @"x100ms";
    cellModel2.maxLength = 3;
    [self.section10List addObject:cellModel2];
}

- (void)loadSection11Datas {
    MKTextFieldCellModel *cellModel1 = [[MKTextFieldCellModel alloc] init];
    cellModel1.index = 4;
    cellModel1.msg = @"Vibrating time";
    cellModel1.textPlaceholder = @"1~6000";
    cellModel1.textFieldValue = self.dataModel.vibratingTime;
    cellModel1.textFieldType = mk_realNumberOnly;
    cellModel1.unit = @"x100ms";
    cellModel1.maxLength = 4;
    [self.section11List addObject:cellModel1];
    
    MKTextFieldCellModel *cellModel2 = [[MKTextFieldCellModel alloc] init];
    cellModel2.index = 5;
    cellModel2.msg = @"Vibrating interval";
    cellModel2.textPlaceholder = @"0~100";
    cellModel2.textFieldValue = self.dataModel.vibratingInterval;
    cellModel2.textFieldType = mk_realNumberOnly;
    cellModel2.unit = @"x100ms";
    cellModel2.maxLength = 3;
    [self.section11List addObject:cellModel2];
}

- (void)loadSection12Datas {
    MKTextFieldCellModel *cellModel1 = [[MKTextFieldCellModel alloc] init];
    cellModel1.index = 6;
    cellModel1.msg = @"Ringing time";
    cellModel1.textPlaceholder = @"1~6000";
    cellModel1.textFieldValue = self.dataModel.ringingTime;
    cellModel1.textFieldType = mk_realNumberOnly;
    cellModel1.unit = @"x100ms";
    cellModel1.maxLength = 4;
    [self.section12List addObject:cellModel1];
    
    MKTextFieldCellModel *cellModel2 = [[MKTextFieldCellModel alloc] init];
    cellModel2.index = 7;
    cellModel2.msg = @"Ringing interval";
    cellModel2.textPlaceholder = @"0~100";
    cellModel2.textFieldValue = self.dataModel.ringingInterval;
    cellModel2.textFieldType = mk_realNumberOnly;
    cellModel2.unit = @"x100ms";
    cellModel2.maxLength = 3;
    [self.section12List addObject:cellModel2];
}

#pragma mark - UI
- (void)loadSubViews {
    if (self.pageType == MKBXDAlarmModeConfigV2ControllerType_single) {
        self.defaultTitle = @"Single press mode";
    }else if (self.pageType == MKBXDAlarmModeConfigV2ControllerType_double) {
        self.defaultTitle = @"Double press mode";
    }else if (self.pageType == MKBXDAlarmModeConfigV2ControllerType_long) {
        self.defaultTitle = @"Long press mode";
    }else if (self.pageType == MKBXDAlarmModeConfigV2ControllerType_abnormal) {
        self.defaultTitle = @"Abnormal inactivity mode";
    }
    self.view.backgroundColor = RGBCOLOR(242, 242, 242);
    [self.rightButton setImage:LOADICON(@"MKBeaconXDButton", @"MKBXDAlarmModeConfigV2Controller", @"bxd_slotSaveIcon.png") forState:UIControlStateNormal];
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
        _tableView.backgroundColor = RGBCOLOR(242, 242, 242);
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

- (NSMutableArray *)section11List {
    if (!_section11List) {
        _section11List = [NSMutableArray array];
    }
    return _section11List;
}

- (NSMutableArray *)section12List {
    if (!_section12List) {
        _section12List = [NSMutableArray array];
    }
    return _section12List;
}

- (MKBXDAlarmModeConfigV2Model *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKBXDAlarmModeConfigV2Model alloc] init];
        _dataModel.alarmType = self.pageType;
    }
    return _dataModel;
}

- (NSMutableArray *)headerList {
    if (!_headerList) {
        _headerList = [NSMutableArray array];
    }
    return _headerList;
}

@end
