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

#import "MKBXDInterface+MKBXDConfig.h"

#import "MKBXDAlarmEventCountCell.h"

#import "MKBXDAlarmEventDataModel.h"

@interface MKBXDAlarmEventController ()<UITableViewDelegate,
UITableViewDataSource,
MKBXDAlarmEventCountCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)MKBXDAlarmEventDataModel *dataModel;

@end

@implementation MKBXDAlarmEventController

- (void)dealloc {
    NSLog(@"MKBXDAlarmEventController销毁");
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

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKBXDAlarmEventCountCell *cell = [MKBXDAlarmEventCountCell initCellWithTableView:tableView];
    cell.dataModel = self.dataList[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - MKBXDAlarmEventCountCellDelegate
- (void)bxd_alarmEvent_clearButtonPressed:(NSInteger)index {
    [[MKHudManager share] showHUDWithTitle:@"Loading..." inView:self.view isPenetration:NO];
    if (index == 0) {
        //单击
        [MKBXDInterface bxd_clearSinglePressEventDataWithSucBlock:^{
            [[MKHudManager share] hide];
            self.dataModel.singleCount = @"0";
            MKBXDAlarmEventCountCellModel *cellModel1 = self.dataList[0];
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
            MKBXDAlarmEventCountCellModel *cellModel1 = self.dataList[1];
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
            MKBXDAlarmEventCountCellModel *cellModel1 = self.dataList[2];
            cellModel1.count = self.dataModel.longCount;
            [self.tableView reloadData];
        } failedBlock:^(NSError * _Nonnull error) {
            [[MKHudManager share] hide];
            [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        }];
        return;
    }
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

#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    MKBXDAlarmEventCountCellModel *cellModel1 = [[MKBXDAlarmEventCountCellModel alloc] init];
    cellModel1.index = 0;
    cellModel1.msg = @"Single press event count";
    cellModel1.count = self.dataModel.singleCount;
    [self.dataList addObject:cellModel1];
    
    MKBXDAlarmEventCountCellModel *cellModel2 = [[MKBXDAlarmEventCountCellModel alloc] init];
    cellModel2.index = 1;
    cellModel2.msg = @"Double press event count";
    cellModel2.count = self.dataModel.doubleCount;
    [self.dataList addObject:cellModel2];
    
    MKBXDAlarmEventCountCellModel *cellModel3 = [[MKBXDAlarmEventCountCellModel alloc] init];
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
    }
    return _tableView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (MKBXDAlarmEventDataModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKBXDAlarmEventDataModel alloc] init];
    }
    return _dataModel;
}

@end
