//
//  MKBXDAlarmEventCRController.m
//  MKBeaconXDButton_Example
//
//  Created by aa on 2025/3/19.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import "MKBXDAlarmEventCRController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"
#import "NSString+MKAdd.h"

#import "MKHudManager.h"
#import "MKTableSectionLineHeader.h"
#import "MKCustomUIAdopter.h"

#import "MKBXDConnectManager.h"

#import "MKBXDExcelManager.h"

#import "MKBXDInterface+MKBXDConfig.h"

#import "MKBXDAlarmSyncTimeView.h"

#import "MKBXDAlarmEventCRModeCell.h"

#import "MKBXDAlarmEventCRModel.h"

#import "MKBXDExportEventDataController.h"

@interface MKBXDAlarmEventCRController ()<UITableViewDelegate,
UITableViewDataSource,
MKBXDAlarmSyncTimeViewDelegate,
MKBXDAlarmEventCRModeCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)MKBXDAlarmSyncTimeView *tableHeaderView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)NSMutableArray *headerList;

@property (nonatomic, strong)MKBXDAlarmEventCRModel *dataModel;

@property (nonatomic, strong)NSDateFormatter *dateFormatter;

@end

@implementation MKBXDAlarmEventCRController

- (void)dealloc {
    NSLog(@"MKBXDAlarmEventCRController销毁");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self readDatasFromDevice];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25.f;
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
        return self.dataList.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKBXDAlarmEventCRModeCell *cell = [MKBXDAlarmEventCRModeCell initCellWithTableView:tableView];
    cell.dataModel = self.dataList[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - MKBXDAlarmSyncTimeViewDelegate
- (void)bxd_alarmSyncTimeButtonPressed {
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    long long millisecondsSince1970 = (long long)(timeInterval * 1000);
    [[MKHudManager share] showHUDWithTitle:@"Sync..." inView:self.view isPenetration:NO];
    [MKBXDInterface bxd_configDeviceTimestamp:millisecondsSince1970 sucBlock:^{
        [[MKHudManager share] hide];
        [self readTimestamp];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - MKBXDAlarmEventCRModeCellDelegate
- (void)bxd_alarmEventCRModeCell_clearBtnPressed:(NSInteger)index {
    [[MKHudManager share] showHUDWithTitle:@"Loading..." inView:self.view isPenetration:NO];
    if (index == 0) {
        //单击
        [MKBXDInterface bxd_clearSinglePressEventDataWithSucBlock:^{
            [[MKHudManager share] hide];
            self.dataModel.singleCount = @"0";
            MKBXDAlarmEventCRModeCellModel *cellModel1 = self.dataList[0];
            cellModel1.count = self.dataModel.singleCount;
            [MKBXDExcelManager deleteDataListWithSucBlock:nil failedBlock:nil];
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
            MKBXDAlarmEventCRModeCellModel *cellModel1 = self.dataList[1];
            cellModel1.count = self.dataModel.doubleCount;
            [MKBXDExcelManager deleteDataListWithSucBlock:nil failedBlock:nil];
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
            MKBXDAlarmEventCRModeCellModel *cellModel1 = self.dataList[2];
            cellModel1.count = self.dataModel.longCount;
            [MKBXDExcelManager deleteDataListWithSucBlock:nil failedBlock:nil];
            [self.tableView reloadData];
        } failedBlock:^(NSError * _Nonnull error) {
            [[MKHudManager share] hide];
            [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        }];
        return;
    }
}

- (void)bxd_alarmEventCRModeCell_exportBtnPressed:(NSInteger)index {
    //单击、双击、长按
    MKBXDExportEventDataController *vc = [[MKBXDExportEventDataController alloc] init];
    vc.vcType = index;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - event method
- (void)longConnectionExport {
    //长连接
    MKBXDExportEventDataController *vc = [[MKBXDExportEventDataController alloc] init];
    vc.vcType = MKBXDExportEventDataControllerTypeConnectionMode;
    [self.navigationController pushViewController:vc animated:YES];
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

- (void)readTimestamp {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    [MKBXDInterface bxd_readDeviceTimestampWithSucBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
        long long timestamp = [returnData[@"result"][@"timestamp"] longLongValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:(timestamp / 1000.0)];
        self.dataModel.timestamp = [self.dateFormatter stringFromDate:date];
        [self.tableHeaderView updateTimestamp:self.dataModel.timestamp];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    [self.tableHeaderView updateTimestamp:self.dataModel.timestamp];
    MKTableSectionLineHeaderModel *headerModel = [[MKTableSectionLineHeaderModel alloc] init];
    headerModel.text = @"Advertising Mode";
    [self.headerList addObject:headerModel];
    
    MKBXDAlarmEventCRModeCellModel *cellModel1 = [[MKBXDAlarmEventCRModeCellModel alloc] init];
    cellModel1.index = 0;
    cellModel1.msg = @"Single press event count";
    cellModel1.count = self.dataModel.singleCount;
    [self.dataList addObject:cellModel1];
    
    MKBXDAlarmEventCRModeCellModel *cellModel2 = [[MKBXDAlarmEventCRModeCellModel alloc] init];
    cellModel2.index = 1;
    cellModel2.msg = @"Double press event count";
    cellModel2.count = self.dataModel.doubleCount;
    [self.dataList addObject:cellModel2];
    
    MKBXDAlarmEventCRModeCellModel *cellModel3 = [[MKBXDAlarmEventCRModeCellModel alloc] init];
    cellModel3.index = 2;
    cellModel3.msg = @"Long press event count";
    cellModel3.count = self.dataModel.longCount;
    [self.dataList addObject:cellModel3];
    
    [self.tableView reloadData];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Alarm event";
    self.view.backgroundColor = RGBCOLOR(242, 242, 242);
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
        
        _tableView.tableFooterView = [self tableFooterView];
        _tableView.tableHeaderView = self.tableHeaderView;
    }
    return _tableView;
}

- (MKBXDAlarmSyncTimeView *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [[MKBXDAlarmSyncTimeView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, 90.f)];
        _tableHeaderView.delegate = self;
    }
    return _tableHeaderView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (NSMutableArray *)headerList {
    if (!_headerList) {
        _headerList = [NSMutableArray array];
    }
    return _headerList;
}

- (MKBXDAlarmEventCRModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKBXDAlarmEventCRModel alloc] init];
    }
    return _dataModel;
}

- (UIView *)tableFooterView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, 80.f)];
    footerView.backgroundColor = RGBCOLOR(242, 242, 242);
    
    UILabel *msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 10.f, kViewWidth - 2 * 15.f, MKFont(15.f).lineHeight)];
    msgLabel.textColor = DEFAULT_TEXT_COLOR;
    msgLabel.textAlignment = NSTextAlignmentLeft;
    msgLabel.font = MKFont(15.f);
    msgLabel.text = @"Long Connection Mode";
    
    [footerView addSubview:msgLabel];
    
    UILabel *alarmLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 10.f + MKFont(15.f).lineHeight + 25.f, 130.f, MKFont(13.f).lineHeight)];
    alarmLabel.textColor = DEFAULT_TEXT_COLOR;
    alarmLabel.textAlignment = NSTextAlignmentLeft;
    alarmLabel.font = MKFont(15.f);
    alarmLabel.text = @"Alarm event";
    
    [footerView addSubview:alarmLabel];
    
    UIButton *exportBtn = [MKCustomUIAdopter customButtonWithTitle:@"Export"
                                                            target:self
                                                            action:@selector(longConnectionExport)];
    exportBtn.titleLabel.font = MKFont(13.f);
    exportBtn.frame = CGRectMake(kViewWidth - 15.f - 60.f, 10.f + MKFont(15.f).lineHeight + 10.f, 60.f, 35.f);
    [footerView addSubview:exportBtn];
    
    return footerView;
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z"];
    }
    return _dateFormatter;
}

@end
