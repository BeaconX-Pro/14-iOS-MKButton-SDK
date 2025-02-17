//
//  MKBXDDeviceInfoController.m
//  MKBeaconXDButton_Example
//
//  Created by aa on 2022/3/3.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXDDeviceInfoController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"

#import "MKHudManager.h"
#import "MKNormalTextCell.h"

#import "MKBXDConnectManager.h"

#import "MKBXDDeviceInfoModel.h"

@interface MKBXDDeviceInfoController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)MKBXDDeviceInfoModel *dataModel;

@end

@implementation MKBXDDeviceInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self readDatasFromDevice];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
    cell.dataModel = self.dataList[indexPath.row];
    return cell;
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
    MKNormalTextCellModel *cellModel1 = [[MKNormalTextCellModel alloc] init];
    cellModel1.leftMsg = @"Battery voltage";
    cellModel1.rightMsg = [self.dataModel.voltage stringByAppendingString:@"mV"];
    [self.dataList addObject:cellModel1];
    
    if ([[MKBXDConnectManager shared].deviceType integerValue] == 1) {
        //新固件
        MKNormalTextCellModel *percentCellModel = [[MKNormalTextCellModel alloc] init];
        percentCellModel.leftMsg = @"Battery Percentage";
        percentCellModel.rightMsg = [self.dataModel.batteryPercent stringByAppendingString:@"%"];
        [self.dataList addObject:percentCellModel];
    }
    
    MKNormalTextCellModel *cellModel2 = [[MKNormalTextCellModel alloc] init];
    cellModel2.leftMsg = @"MAC address";
    cellModel2.rightMsg = SafeStr(self.dataModel.macAddress);
    [self.dataList addObject:cellModel2];
    
    MKNormalTextCellModel *cellModel3 = [[MKNormalTextCellModel alloc] init];
    cellModel3.leftMsg = @"Product model";
    cellModel3.rightMsg = SafeStr(self.dataModel.productMode);
    [self.dataList addObject:cellModel3];
    
    MKNormalTextCellModel *cellModel4 = [[MKNormalTextCellModel alloc] init];
    cellModel4.leftMsg = @"Software version";
    cellModel4.rightMsg = SafeStr(self.dataModel.software);
    [self.dataList addObject:cellModel4];
    
    MKNormalTextCellModel *cellModel5 = [[MKNormalTextCellModel alloc] init];
    cellModel5.leftMsg = @"Firmware version";
    cellModel5.rightMsg = SafeStr(self.dataModel.firmware);
    [self.dataList addObject:cellModel5];
    
    MKNormalTextCellModel *cellModel6 = [[MKNormalTextCellModel alloc] init];
    cellModel6.leftMsg = @"Hardware version";
    cellModel6.rightMsg = SafeStr(self.dataModel.hardware);
    [self.dataList addObject:cellModel6];
    
    MKNormalTextCellModel *cellModel7 = [[MKNormalTextCellModel alloc] init];
    cellModel7.leftMsg = @"Manufacture date";
    cellModel7.rightMsg = SafeStr(self.dataModel.manuDate);
    [self.dataList addObject:cellModel7];
    
    MKNormalTextCellModel *cellModel8 = [[MKNormalTextCellModel alloc] init];
    cellModel8.leftMsg = @"Manufacturer";
    cellModel8.rightMsg = SafeStr(self.dataModel.manu);
    [self.dataList addObject:cellModel8];
    
    [self.tableView reloadData];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Device info";
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
    }
    return _tableView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (MKBXDDeviceInfoModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKBXDDeviceInfoModel alloc] init];
    }
    return _dataModel;
}

@end
