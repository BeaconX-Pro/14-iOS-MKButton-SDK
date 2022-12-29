//
//  MKBXDAlarmEventController.m
//  MKBeaconXDButton_Example
//
//  Created by aa on 2022/2/22.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXDAlarmEventController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"

#import "MKHudManager.h"
#import "MKTableSectionLineHeader.h"
#import "MKNormalTextCell.h"

#import "MKBXDInterface+MKBXDConfig.h"

#import "MKBXDAlarmSyncTimeView.h"
#import "MKBXDAlarmEventCountCell.h"

#import "MKBXDAlarmEventDataModel.h"

#import "MKBXDAlarmDataExportController.h"

@interface MKBXDAlarmEventController ()<UITableViewDelegate,
UITableViewDataSource,
MKBXDAlarmSyncTimeViewDelegate,
MKBXDAlarmEventCountCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *headerList;

@property (nonatomic, strong)MKBXDAlarmSyncTimeView *headerView;

@property (nonatomic, strong)MKBXDAlarmEventDataModel *dataModel;

@end

@implementation MKBXDAlarmEventController

- (void)dealloc {
    NSLog(@"MKBXDAlarmEventController销毁");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self readDatasFromDevice];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self loadSectionDatas];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return 90.f;
    }
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
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
    if (section == 1) {
        return self.section1List.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
        cell.dataModel = self.section0List[indexPath.row];
        return cell;
    }
    MKBXDAlarmEventCountCell *cell = [MKBXDAlarmEventCountCell initCellWithTableView:tableView];
    cell.dataModel = self.section1List[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - MKBXDAlarmSyncTimeViewDelegate
- (void)bxd_alarmSyncTimeButtonPressed {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    NSDate *zoneDate = [NSDate dateWithTimeIntervalSinceNow:-8*60*60];
    NSTimeInterval interval = [zoneDate timeIntervalSince1970];
    [MKBXDInterface bxd_configDeviceTime:(interval * 1000) sucBlock:^{
        [[MKHudManager share] hide];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss.SSS"];
        NSString *tempValue = [formatter stringFromDate:date];
        NSArray *tempList = [tempValue componentsSeparatedByString:@" "];
        self.dataModel.timestamp = [NSString stringWithFormat:@"%@T%@Z",tempList[0],tempList[1]];
        [self.headerView updateTimestamp:self.dataModel.timestamp];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - MKBXDAlarmEventCountCellDelegate
- (void)bxd_alarmEvent_checkButtonPressed:(NSInteger)index {
    [[MKHudManager share] showHUDWithTitle:@"Loading..." inView:self.view isPenetration:NO];
    if (index == 0) {
        //单击
        [MKBXDInterface bxd_readSinglePressEventCountWithSucBlock:^(id  _Nonnull returnData) {
            [[MKHudManager share] hide];
            self.dataModel.singleCount = returnData[@"result"][@"count"];
            MKBXDAlarmEventCountCellModel *cellModel1 = self.section1List[0];
            cellModel1.count = self.dataModel.singleCount;
            [self.tableView reloadData];
        } failedBlock:^(NSError * _Nonnull error) {
            [[MKHudManager share] hide];
            [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        }];
        return;
    }
    if (index == 1) {
        //双击
        [MKBXDInterface bxd_readDoublePressEventCountWithSucBlock:^(id  _Nonnull returnData) {
            [[MKHudManager share] hide];
            self.dataModel.doubleCount = returnData[@"result"][@"count"];
            MKBXDAlarmEventCountCellModel *cellModel1 = self.section1List[1];
            cellModel1.count = self.dataModel.doubleCount;
            [self.tableView reloadData];
        } failedBlock:^(NSError * _Nonnull error) {
            [[MKHudManager share] hide];
            [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        }];
        return;
    }
    if (index == 2) {
        //长按
        [MKBXDInterface bxd_readLongPressEventCountWithSucBlock:^(id  _Nonnull returnData) {
            [[MKHudManager share] hide];
            self.dataModel.longCount = returnData[@"result"][@"count"];
            MKBXDAlarmEventCountCellModel *cellModel1 = self.section1List[2];
            cellModel1.count = self.dataModel.longCount;
            [self.tableView reloadData];
        } failedBlock:^(NSError * _Nonnull error) {
            [[MKHudManager share] hide];
            [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        }];
        return;
    }
}

- (void)bxd_alarmEvent_clearButtonPressed:(NSInteger)index {
    [[MKHudManager share] showHUDWithTitle:@"Loading..." inView:self.view isPenetration:NO];
    if (index == 0) {
        //单击
        [MKBXDInterface bxd_clearSinglePressEventDataWithSucBlock:^{
            [[MKHudManager share] hide];
            self.dataModel.singleCount = @"0";
            MKBXDAlarmEventCountCellModel *cellModel1 = self.section1List[0];
            cellModel1.count = self.dataModel.singleCount;
            [self.tableView reloadData];
        } failedBlock:^(NSError * _Nonnull error) {
            [[MKHudManager share] hide];
            [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        }];
        return;
    }
    if (index == 1) {
        //双击
        [MKBXDInterface bxd_clearDoublePressEventDataWithSucBlock:^{
            [[MKHudManager share] hide];
            self.dataModel.doubleCount = @"0";
            MKBXDAlarmEventCountCellModel *cellModel1 = self.section1List[1];
            cellModel1.count = self.dataModel.doubleCount;
            [self.tableView reloadData];
        } failedBlock:^(NSError * _Nonnull error) {
            [[MKHudManager share] hide];
            [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        }];
        return;
    }
    if (index == 2) {
        //长按
        [MKBXDInterface bxd_clearLongPressEventDataWithSucBlock:^{
            [[MKHudManager share] hide];
            self.dataModel.longCount = @"0";
            MKBXDAlarmEventCountCellModel *cellModel1 = self.section1List[2];
            cellModel1.count = self.dataModel.longCount;
            [self.tableView reloadData];
        } failedBlock:^(NSError * _Nonnull error) {
            [[MKHudManager share] hide];
            [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        }];
        return;
    }
}

- (void)bxd_alarmEvent_exportButtonPressed:(NSInteger)index {
    MKBXDAlarmDataExportController *vc = [[MKBXDAlarmDataExportController alloc] init];
    vc.pageType = index;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - interface
- (void)readDatasFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel readDataWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self updateCellState];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)updateCellState {
    [self.headerView updateTimestamp:self.dataModel.timestamp];
    
    MKBXDAlarmEventCountCellModel *cellModel1 = self.section1List[0];
    cellModel1.count = self.dataModel.singleCount;
    
    MKBXDAlarmEventCountCellModel *cellModel2 = self.section1List[1];
    cellModel2.count = self.dataModel.doubleCount;
    
    MKBXDAlarmEventCountCellModel *cellModel3 = self.section1List[2];
    cellModel3.count = self.dataModel.longCount;
    
    [self.tableView reloadData];
}

#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    [self loadSection0Datas];
    [self loadSection1Datas];
    
    for (NSInteger i = 0; i < 2; i ++) {
        MKTableSectionLineHeaderModel *headerModel = [[MKTableSectionLineHeaderModel alloc] init];
        [self.headerList addObject:headerModel];
    }
    
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    MKNormalTextCellModel *cellModel = [[MKNormalTextCellModel alloc] init];
    cellModel.leftMsg = @"Alarm event data";
    [self.section0List addObject:cellModel];
}

- (void)loadSection1Datas {
    MKBXDAlarmEventCountCellModel *cellModel1 = [[MKBXDAlarmEventCountCellModel alloc] init];
    cellModel1.index = 0;
    cellModel1.msg = @"Single press event count";
    cellModel1.count = @"0";
    [self.section1List addObject:cellModel1];
    
    MKBXDAlarmEventCountCellModel *cellModel2 = [[MKBXDAlarmEventCountCellModel alloc] init];
    cellModel2.index = 1;
    cellModel2.msg = @"Double press event count";
    cellModel2.count = @"0";
    [self.section1List addObject:cellModel2];
    
    MKBXDAlarmEventCountCellModel *cellModel3 = [[MKBXDAlarmEventCountCellModel alloc] init];
    cellModel3.index = 2;
    cellModel3.msg = @"Long press event count";
    cellModel3.count = @"0";
    [self.section1List addObject:cellModel3];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Alarm event";
    self.view.backgroundColor = RGBCOLOR(242, 242, 242);
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(defaultTopInset);
        make.bottom.mas_equalTo(-VirtualHomeHeight);
    }];
}

#pragma mark - getter
- (MKBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.backgroundColor = RGBCOLOR(242, 242, 242);
        _tableView.tableHeaderView = [self tableHeaderView];
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

- (NSMutableArray *)headerList {
    if (!_headerList) {
        _headerList = [NSMutableArray array];
    }
    return _headerList;
}

- (MKBXDAlarmSyncTimeView *)headerView {
    if (!_headerView) {
        _headerView = [[MKBXDAlarmSyncTimeView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, 70.f)];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (MKBXDAlarmEventDataModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKBXDAlarmEventDataModel alloc] init];
    }
    return _dataModel;
}

- (UIView *)tableHeaderView {
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, 80.f)];
    tableHeaderView.backgroundColor = RGBCOLOR(242, 242, 242);
    
    [tableHeaderView addSubview:self.headerView];
    
    return tableHeaderView;
}

@end
