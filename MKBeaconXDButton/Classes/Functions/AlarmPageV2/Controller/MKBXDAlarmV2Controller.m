//
//  MKBXDAlarmV2Controller.m
//  MKBeaconXDButton_Example
//
//  Created by aa on 2024/11/25.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "MKBXDAlarmV2Controller.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"

#import "MKHudManager.h"
#import "MKNormalTextCell.h"
#import "MKTableSectionLineHeader.h"

#import "MKBXDCentralManager.h"
#import "MKBXDInterface+MKBXDConfig.h"

#import "MKBXDConnectManager.h"

#import "MKBXDAlarmEventCell.h"
#import "MKBXDAlarmMsgCell.h"

#import "MKBXDAlarmV2Model.h"

#import "MKBXDAlarmV2EventCell.h"

#import "MKBXDAlarmModeConfigV2Controller.h"
#import "MKBXDAlarmNotiTypeController.h"

@interface MKBXDAlarmV2Controller ()<UITableViewDelegate,
UITableViewDataSource,
MKBXDAlarmEventCellDelegate,
MKBXDAlarmV2EventCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *section2List;

@property (nonatomic, strong)NSMutableArray *section3List;

@property (nonatomic, strong)NSMutableArray *section4List;

@property (nonatomic, strong)NSMutableArray *section5List;

@property (nonatomic, strong)NSMutableArray *headerList;

@property (nonatomic, strong)MKBXDAlarmV2Model *dataModel;

@end

@implementation MKBXDAlarmV2Controller

- (void)dealloc {
    NSLog(@"MKBXDAlarmV2Controller销毁");
    [[MKBXDCentralManager shared] notifyLongConModeData:NO];
    if ([MKBXDConnectManager shared].doubleBtn) {
        [[MKBXDCentralManager shared] notifySubClickData:NO];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self readDatasFromDevice];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self loadSectionDatas];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveLongConModeData:)
                                                 name:mk_bxd_receiveLongConnectionModeDataNotification
                                               object:nil];
    [[MKBXDCentralManager shared] notifyLongConModeData:YES];
    if ([MKBXDConnectManager shared].doubleBtn) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveSubClickData:)
                                                     name:mk_bxd_receiveSubClickDataNotification
                                                   object:nil];
        [[MKBXDCentralManager shared] notifySubClickData:YES];
    }
}

#pragma mark - super method
- (void)leftButtonMethod {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_bxd_popToRootViewControllerNotification" object:nil];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        MKBXDAlarmMsgCellModel *cellModel = self.section2List[indexPath.row];
        return [cellModel fetchCellHeight];
    }
    if (indexPath.section == 3) {
        if ([MKBXDConnectManager shared].doubleBtn) {
            return 110.f;
        }
        return 80.f;
    }
    if (indexPath.section == 5) {
        MKBXDAlarmMsgCellModel *cellModel = self.section5List[indexPath.row];
        return [cellModel fetchCellHeight];
    }
    
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 3) {
        return 25.f;
    }
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MKTableSectionLineHeader *header = [MKTableSectionLineHeader initHeaderViewWithTableView:tableView];
    header.headerModel = self.headerList[section];
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKBXDAlarmModeConfigV2Controller *vc = [[MKBXDAlarmModeConfigV2Controller alloc] init];
        vc.pageType = indexPath.row;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.section == 1) {
        MKBXDAlarmModeConfigV2Controller *vc = [[MKBXDAlarmModeConfigV2Controller alloc] init];
        vc.pageType = MKBXDAlarmModeConfigV2ControllerType_abnormal;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.section == 4) {
        MKBXDAlarmNotiTypeController *vc = [[MKBXDAlarmNotiTypeController alloc] init];
        vc.pageType = MKBXDAlarmNotiTypeControllerType_longConnMode;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.headerList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.section0List.count;
    }
    if (section == 1) {
        return ([MKBXDConnectManager shared].threeSensor ? self.section1List.count : 0);
    }
    if (section == 2) {
        return self.section2List.count;
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
        MKBXDAlarmMsgCell *cell = [MKBXDAlarmMsgCell initCellWithTableView:tableView];
        cell.dataModel = self.section2List[indexPath.row];
        return cell;
    }
    if (indexPath.section == 3) {
        if ([MKBXDConnectManager shared].doubleBtn) {
            MKBXDAlarmV2EventCell *cell = [MKBXDAlarmV2EventCell initCellWithTableView:tableView];
            cell.dataModel = self.section3List[indexPath.row];
            cell.delegate = self;
            return cell;
        }
        MKBXDAlarmEventCell *cell = [MKBXDAlarmEventCell initCellWithTableView:tableView];
        cell.dataModel = self.section3List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 4) {
        MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
        cell.dataModel = self.section4List[indexPath.row];
        return cell;
    }
    MKBXDAlarmMsgCell *cell = [MKBXDAlarmMsgCell initCellWithTableView:tableView];
    cell.dataModel = self.section5List[indexPath.row];
    return cell;
}

#pragma mark - MKBXDAlarmEventCellDelegate
- (void)bxd_alarmEventCell_clearButtonPressed {
    [self dismissAlarm];
}

#pragma mark - MKBXDAlarmV2EventCellDelegate
- (void)bxd_alarmV2EventCell_clearButtonPressed {
    [self dismissAlarm];
}

#pragma mark - note
- (void)receiveLongConModeData:(NSNotification *)note {
    NSDictionary *dic = note.userInfo;
    if (!ValidDict(dic)) {
        return;
    }
    if ([MKBXDConnectManager shared].doubleBtn) {
        MKBXDAlarmV2EventCellModel *cellModel = self.section3List[0];
        cellModel.mainCount = dic[@"count"];
    }else {
        MKBXDAlarmEventCellModel *cellModel = self.section3List[0];
        cellModel.count = dic[@"count"];
    }
    
    
    [self.tableView mk_reloadSection:3 withRowAnimation:UITableViewRowAnimationNone];
}

- (void)receiveSubClickData:(NSNotification *)note {
    NSDictionary *dic = note.userInfo;
    if (!ValidDict(dic)) {
        return;
    }
    
    MKBXDAlarmV2EventCellModel *cellModel = self.section3List[0];
    cellModel.subCount = dic[@"count"];
    
    [self.tableView mk_reloadSection:3 withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - interface
- (void)readDatasFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel readDataWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self updateCellValue];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)updateCellValue {
    MKNormalTextCellModel *cellModel1 = self.section0List[0];
    cellModel1.rightMsg = (self.dataModel.singleIsOn ? @"ON" : @"OFF");
    
    MKNormalTextCellModel *cellModel2 = self.section0List[1];
    cellModel2.rightMsg = (self.dataModel.doubleIsOn ? @"ON" : @"OFF");
    
    MKNormalTextCellModel *cellModel3 = self.section0List[2];
    cellModel3.rightMsg = (self.dataModel.longIsOn ? @"ON" : @"OFF");
    
    MKNormalTextCellModel *cellModel4 = self.section1List[0];
    cellModel4.rightMsg = (self.dataModel.inactivityIsOn ? @"ON" : @"OFF");
    
    [self.tableView reloadData];
}

- (void)dismissAlarm {
    [[MKHudManager share] showHUDWithTitle:@"Waiting..." inView:self.view isPenetration:NO];
    [MKBXDInterface bxd_configDismissAlarmWithSucBlock:^{
        [[MKHudManager share] hide];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    [self loadSection0List];
    [self loadSection1List];
    [self loadSection2List];
    [self loadSection3List];
    [self loadSection4List];
    [self loadSection5List];
    
    for (NSInteger i = 0; i < 6; i ++) {
        MKTableSectionLineHeaderModel *headerModel = [[MKTableSectionLineHeaderModel alloc] init];
        if (i == 0) {
            headerModel.text = @"Advertising Mode";
        }
        [self.headerList addObject:headerModel];
    }
    
    [self.tableView reloadData];
}

- (void)loadSection0List {
    MKNormalTextCellModel *cellModel1 = [[MKNormalTextCellModel alloc] init];
    cellModel1.leftMsg = @"Single press mode";
    cellModel1.showRightIcon = YES;
    [self.section0List addObject:cellModel1];
    
    MKNormalTextCellModel *cellModel2 = [[MKNormalTextCellModel alloc] init];
    cellModel2.leftMsg = @"Double press mode";
    cellModel2.showRightIcon = YES;
    [self.section0List addObject:cellModel2];
    
    MKNormalTextCellModel *cellModel3 = [[MKNormalTextCellModel alloc] init];
    cellModel3.leftMsg = @"Long press mode";
    cellModel3.showRightIcon = YES;
    [self.section0List addObject:cellModel3];
}

- (void)loadSection1List {
    MKNormalTextCellModel *cellModel = [[MKNormalTextCellModel alloc] init];
    cellModel.leftMsg = @"Abnormal inactivity mode";
    cellModel.showRightIcon = YES;
    [self.section1List addObject:cellModel];
}

- (void)loadSection2List {
    MKBXDAlarmMsgCellModel *cellModel = [[MKBXDAlarmMsgCellModel alloc] init];
    cellModel.msg = @"*Advertising mode mainly refers to the configuration of channel parameters for broadcasting in a non-connected state and the parameter settings related to alarm events, which are different from the parameters in long connection mode.";
    [self.section2List addObject:cellModel];
}

- (void)loadSection3List {
    if ([MKBXDConnectManager shared].doubleBtn) {
        MKBXDAlarmV2EventCellModel *cellModel = [[MKBXDAlarmV2EventCellModel alloc] init];
        cellModel.mainCount = @"0";
        cellModel.subCount = @"0";
        [self.section3List addObject:cellModel];
    }else {
        MKBXDAlarmEventCellModel *cellModel = [[MKBXDAlarmEventCellModel alloc] init];
        cellModel.count = @"0";
        [self.section3List addObject:cellModel];
    }
}

- (void)loadSection4List {
    MKNormalTextCellModel *cellModel = [[MKNormalTextCellModel alloc] init];
    cellModel.leftMsg = @"Alarm Type Setting";
    cellModel.showRightIcon = YES;
    [self.section4List addObject:cellModel];
}

- (void)loadSection5List {
    MKBXDAlarmMsgCellModel *cellModel = [[MKBXDAlarmMsgCellModel alloc] init];
    cellModel.msg = @"*Long connection mode mainly refers to the parameter settings related to alarm events and event monitoring display in a long connection state. To ensure the beacon can be connected, you need to make sure that at least one slot is enabled in Advertising Mode setting, allowing the device to continue broadcasting while in a non-connected state";
    [self.section5List addObject:cellModel];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"ALARM";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).mas_offset(-49.f);
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

- (NSMutableArray *)headerList {
    if (!_headerList) {
        _headerList = [NSMutableArray array];
    }
    return _headerList;
}

- (MKBXDAlarmV2Model *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKBXDAlarmV2Model alloc] init];
    }
    return _dataModel;
}

@end
