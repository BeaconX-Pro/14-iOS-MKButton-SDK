//
//  MKBXDAlarmEventDBController.m
//  MKBeaconXDButton_Example
//
//  Created by aa on 2025/10/10.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import "MKBXDAlarmEventDBController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"
#import "NSString+MKAdd.h"

#import "MKHudManager.h"

#import "MKBXDConnectManager.h"

#import "MKBXDExcelManager.h"

#import "MKBXDInterface+MKBXDConfig.h"

#import "MKBXDAlarmEventDBCountCell.h"

#import "MKBXDAlarmEventDBDataModel.h"

@interface MKBXDAlarmEventDBController ()<UITableViewDelegate,
UITableViewDataSource,
MKBXDAlarmEventDBCountCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)MKBXDAlarmEventDBDataModel *dataModel;

@end

@implementation MKBXDAlarmEventDBController

- (void)dealloc {
    NSLog(@"MKBXDAlarmEventDBController销毁");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self readDatasFromDevice];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130.f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKBXDAlarmEventDBCountCell *cell = [MKBXDAlarmEventDBCountCell initCellWithTableView:tableView];
    cell.dataModel = self.dataList[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - MKBXDAlarmEventDBCountCellDelegate
- (void)bxd_alarmEventDBCell_mainClearButtonPressed:(NSInteger)index {
    [[MKHudManager share] showHUDWithTitle:@"Loading..." inView:self.view isPenetration:NO];
    if (index == 0) {
        //单击
        [MKBXDInterface bxd_clearSinglePressEventDataWithSucBlock:^{
            [[MKHudManager share] hide];
            self.dataModel.singleMainCount = @"0";
            MKBXDAlarmEventDBCountCellModel *cellModel1 = self.dataList[0];
            cellModel1.mainCount = self.dataModel.singleMainCount;
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
            self.dataModel.doubleMainCount = @"0";
            MKBXDAlarmEventDBCountCellModel *cellModel1 = self.dataList[1];
            cellModel1.mainCount = self.dataModel.doubleMainCount;
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
            self.dataModel.longMainCount = @"0";
            MKBXDAlarmEventDBCountCellModel *cellModel1 = self.dataList[2];
            cellModel1.mainCount = self.dataModel.longMainCount;
            [MKBXDExcelManager deleteDataListWithSucBlock:nil failedBlock:nil];
            [self.tableView reloadData];
        } failedBlock:^(NSError * _Nonnull error) {
            [[MKHudManager share] hide];
            [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        }];
        return;
    }
}

- (void)bxd_alarmEventDBCell_subClearButtonPressed:(NSInteger)index {
    [[MKHudManager share] showHUDWithTitle:@"Loading..." inView:self.view isPenetration:NO];
    if (index == 0) {
        //单击
        [MKBXDInterface bxd_clearSubButtonSinglePressEventDataWithSucBlock:^{
            [[MKHudManager share] hide];
            self.dataModel.singleSubCount = @"0";
            MKBXDAlarmEventDBCountCellModel *cellModel1 = self.dataList[0];
            cellModel1.subCount = self.dataModel.singleSubCount;
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
        [MKBXDInterface bxd_clearSubButtonDoublePressEventDataWithSucBlock:^{
            [[MKHudManager share] hide];
            self.dataModel.doubleSubCount = @"0";
            MKBXDAlarmEventDBCountCellModel *cellModel1 = self.dataList[1];
            cellModel1.subCount = self.dataModel.doubleSubCount;
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
        [MKBXDInterface bxd_clearSubButtonLongPressEventDataWithSucBlock:^{
            [[MKHudManager share] hide];
            self.dataModel.longSubCount = @"0";
            MKBXDAlarmEventDBCountCellModel *cellModel1 = self.dataList[2];
            cellModel1.subCount = self.dataModel.longSubCount;
            [MKBXDExcelManager deleteDataListWithSucBlock:nil failedBlock:nil];
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
    MKBXDAlarmEventDBCountCellModel *cellModel1 = [[MKBXDAlarmEventDBCountCellModel alloc] init];
    cellModel1.index = 0;
    cellModel1.msg = @"Single press count";
    cellModel1.mainCount = self.dataModel.singleMainCount;
    cellModel1.subCount = self.dataModel.singleSubCount;
    [self.dataList addObject:cellModel1];
    
    MKBXDAlarmEventDBCountCellModel *cellModel2 = [[MKBXDAlarmEventDBCountCellModel alloc] init];
    cellModel2.index = 1;
    cellModel2.msg = @"Double press count";
    cellModel2.mainCount = self.dataModel.doubleMainCount;
    cellModel2.subCount = self.dataModel.doubleSubCount;
    [self.dataList addObject:cellModel2];
    
    MKBXDAlarmEventDBCountCellModel *cellModel3 = [[MKBXDAlarmEventDBCountCellModel alloc] init];
    cellModel3.index = 2;
    cellModel3.msg = @"Long press count";
    cellModel3.mainCount = self.dataModel.longMainCount;
    cellModel3.subCount = self.dataModel.longSubCount;
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
        
        if ([[MKBXDConnectManager shared].deviceType integerValue] == 1) {
            _tableView.tableFooterView = [self tableFooterView];
        }
    }
    return _tableView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (MKBXDAlarmEventDBDataModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKBXDAlarmEventDBDataModel alloc] init];
    }
    return _dataModel;
}

- (UIView *)tableFooterView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, 80.f)];
    footerView.backgroundColor = RGBCOLOR(242, 242, 242);
    
    NSString *noteMsg = @"*The Alarm Count here mainly refers to the button press count in Advertising Mode under non-connected status.";
    CGSize noteSize = [NSString sizeWithText:noteMsg
                                     andFont:MKFont(12.f)
                                  andMaxSize:CGSizeMake(kViewWidth - 2 * 15.f, MAXFLOAT)];
    
    UILabel *noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 10.f, kViewWidth - 2 * 15.f, noteSize.height)];
    noteLabel.textColor = RGBCOLOR(118, 118, 118);
    noteLabel.textAlignment = NSTextAlignmentLeft;
    noteLabel.font = MKFont(12.f);
    noteLabel.text = noteMsg;
    noteLabel.numberOfLines = 0;
    
    [footerView addSubview:noteLabel];
    
    return footerView;
}

@end
