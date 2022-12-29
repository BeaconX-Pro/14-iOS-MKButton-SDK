//
//  MKBXDAccelerationController.m
//  MKBeaconXDButton_Example
//
//  Created by aa on 2021/3/3.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXDAccelerationController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"

#import "MKHudManager.h"
#import "MKNormalTextCell.h"
#import "MKTextButtonCell.h"
#import "MKTextFieldCell.h"

#import "MKBXDCentralManager.h"

#import "MKBXDAccelerationModel.h"

#import "MKBXDAccelerationHeaderView.h"

@interface MKBXDAccelerationController ()<UITableViewDelegate,
UITableViewDataSource,
MKTextButtonCellDelegate,
MKTextFieldCellDelegate,
MKBXDAccelerationHeaderViewDelegate>

@property (nonatomic, strong)MKBXDAccelerationHeaderView *headerView;

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *section2List;

@property (nonatomic, strong)MKBXDAccelerationModel *dataModel;

@end

@implementation MKBXDAccelerationController

- (void)dealloc {
    NSLog(@"MKBXDAccelerationController销毁");
    [[MKBXDCentralManager shared] notifyThreeAxisData:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //本页面禁止右划退出手势
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self readDataFromDevice];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveAxisDatas:)
                                                 name:mk_bxd_receiveThreeAxisDataNotification
                                               object:nil];
}

#pragma mark - super method
- (void)rightButtonMethod {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel configWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success"];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.section0List.count;
    }
    if (section == 1) {
        return self.section1List.count;
    }
    if (section == 2) {
        return self.section2List.count;
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
        MKTextButtonCell *cell = [MKTextButtonCell initCellWithTableView:tableView];
        cell.dataModel = self.section1List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:tableView];
    cell.dataModel = self.section2List[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - MKTextButtonCellDelegate
/// 右侧按钮点击触发的回调事件
/// @param index 当前cell所在的index
/// @param dataListIndex 点击按钮选中的dataList里面的index
/// @param value dataList[dataListIndex]
- (void)mk_loraTextButtonCellSelected:(NSInteger)index
                        dataListIndex:(NSInteger)dataListIndex
                                value:(NSString *)value {
    if (index == 0) {
        //Full-scale
        self.dataModel.scale = dataListIndex;
        MKTextButtonCellModel *cellModel = self.section1List[0];
        cellModel.dataListIndex = dataListIndex;
        [self updateMotionThresholdUnit];
        [self.tableView reloadData];
        return;
    }
    if (index == 1) {
        //Sampling rate
        self.dataModel.samplingRate = dataListIndex;
        MKTextButtonCellModel *cellModel = self.section1List[1];
        cellModel.dataListIndex = dataListIndex;
        return;
    }
}

#pragma mark - MKTextFieldCellDelegate
/// textField内容发送改变时的回调事件
/// @param index 当前cell所在的index
/// @param value 当前textField的值
- (void)mk_deviceTextCellValueChanged:(NSInteger)index textValue:(NSString *)value {
    if (index == 0) {
        //Motion threshold
        self.dataModel.threshold = value;
        MKTextFieldCellModel *cellModel = self.section2List[0];
        cellModel.textFieldValue = value;
        return;
    }
}

#pragma mark - MKBXDAccelerationHeaderViewDelegate
- (void)bxd_updateThreeAxisNotifyStatus:(BOOL)notify {
    [[MKBXDCentralManager shared] notifyThreeAxisData:notify];
}

#pragma mark - 通知
- (void)receiveAxisDatas:(NSNotification *)note {
    NSDictionary *dic = note.userInfo;
    if (!ValidDict(dic)) {
        return;
    }
    [self.headerView updateDataWithXData:dic[@"x-Data"] yData:dic[@"y-Data"] zData:dic[@"z-Data"]];
}

#pragma mark - 读取数据
- (void)readDataFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel readWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self loadSectionDatas];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - 列表加载
- (void)loadSectionDatas {
    [self loadSection0Datas];
    [self loadSection1Datas];
    [self loadSection2Datas];
    [self updateMotionThresholdUnit];
    
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    MKNormalTextCellModel *cellModel = [[MKNormalTextCellModel alloc] init];
    cellModel.leftMsg = @"Sensor parameters";
    [self.section0List addObject:cellModel];
}

- (void)loadSection1Datas {
    MKTextButtonCellModel *cellModel1 = [[MKTextButtonCellModel alloc] init];
    cellModel1.index = 0;
    cellModel1.msg = @"Full-scale";
    cellModel1.dataList = @[@"±2g",@"±4g",@"±8g",@"±16g"];
    cellModel1.dataListIndex = self.dataModel.scale;
    [self.section1List addObject:cellModel1];
    
    MKTextButtonCellModel *cellModel2 = [[MKTextButtonCellModel alloc] init];
    cellModel2.msg = @"Sampling rate";
    cellModel2.index = 1;
    cellModel2.dataList = @[@"1hz",@"10hz",@"25hz",@"50hz",@"100hz"];
    cellModel2.dataListIndex = self.dataModel.samplingRate;
    [self.section1List addObject:cellModel2];
}

- (void)loadSection2Datas {
    MKTextFieldCellModel *cellModel = [[MKTextFieldCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = @"Motion threshold";
    cellModel.textFieldValue = self.dataModel.threshold;
    cellModel.textPlaceholder = @"1 ~ 2048";
    cellModel.textFieldType = mk_realNumberOnly;
    cellModel.maxLength = 4;
    [self.section2List addObject:cellModel];
}

- (void)updateMotionThresholdUnit {
    MKTextFieldCellModel *cellModel = self.section2List[0];
    if (self.dataModel.scale == 0) {
        cellModel.unit = @"x 1mg";
    }else if (self.dataModel.scale == 1) {
        cellModel.unit = @"x 2mg";
    }else if (self.dataModel.scale == 2) {
        cellModel.unit = @"x 4mg";
    }else if (self.dataModel.scale == 3) {
        cellModel.unit = @"x 12mg";
    }
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"3-axis accelerometer";
    [self.rightButton setImage:LOADICON(@"MKBeaconXDButton", @"MKBXDAccelerationController", @"bxd_slotSaveIcon.png") forState:UIControlStateNormal];
    self.view.backgroundColor = RGBCOLOR(242, 242, 242);
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5.f);
        make.right.mas_equalTo(-5.f);
        make.top.mas_equalTo(defaultTopInset);
        make.bottom.mas_equalTo(-VirtualHomeHeight);
    }];
}

#pragma mark - getter
- (MKBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = RGBCOLOR(242, 242, 242);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableHeaderView = [self tableHeaderView];
    }
    return _tableView;
}

- (MKBXDAccelerationHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[MKBXDAccelerationHeaderView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, 55.f)];
        _headerView.delegate = self;
    }
    return _headerView;
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

- (MKBXDAccelerationModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKBXDAccelerationModel alloc] init];
    }
    return _dataModel;
}

- (UIView *)tableHeaderView {
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, 65.f)];
    tempView.backgroundColor = RGBCOLOR(242, 242, 242);
    [tempView addSubview:self.headerView];
    return tempView;
}

@end
