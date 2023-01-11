//
//  MKBXDAlarmNotiTypeController.m
//  MKBeaconXDButton_Example
//
//  Created by aa on 2022/2/20.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXDAlarmNotiTypeController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"

#import "MKHudManager.h"
#import "MKTableSectionLineHeader.h"
#import "MKNormalTextCell.h"
#import "MKTextFieldCell.h"

#import "MKBXDNotificationTypePickerView.h"

#import "MKBXDAlarmNotiTypeModel.h"

@interface MKBXDAlarmNotiTypeController ()<UITableViewDelegate,
UITableViewDataSource,
MKTextFieldCellDelegate,
MKBXDNotificationTypePickerViewDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)MKBXDNotificationTypePickerView *headerView;

@property (nonatomic, strong)MKBXDNotificationTypePickerViewModel *headerViewModel;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *section2List;

@property (nonatomic, strong)NSMutableArray *section3List;

@property (nonatomic, strong)NSMutableArray *headerList;

@property (nonatomic, strong)MKBXDAlarmNotiTypeModel *dataModel;

@end

@implementation MKBXDAlarmNotiTypeController

- (void)dealloc {
    NSLog(@"MKBXDAlarmNotiTypeController销毁");
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];
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
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [self heightForHeaderInSection:section];
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
    return [self loadNumberOfRows:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        //LED notification
        MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
        cell.dataModel = self.section0List[indexPath.row];
        return cell;
    }
    if (indexPath.section == 1) {
        MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:tableView];
        cell.dataModel = self.section1List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 2) {
        //Buzzer notification
        MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
        cell.dataModel = self.section2List[indexPath.row];
        return cell;
    }
    MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:tableView];
    cell.dataModel = self.section3List[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - MKTextFieldCellDelegate
/// textField内容发送改变时的回调事件
/// @param index 当前cell所在的index
/// @param value 当前textField的值
- (void)mk_deviceTextCellValueChanged:(NSInteger)index textValue:(NSString *)value {
    if (index == 0) {
        //Blinking time
        self.dataModel.blinkingTime = value;
        MKTextFieldCellModel *cellModel = self.section1List[0];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 1) {
        //Blinking interval
        self.dataModel.blinkingInterval = value;
        MKTextFieldCellModel *cellModel = self.section1List[1];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 2) {
        //Ringing time
        self.dataModel.ringingTime = value;
        MKTextFieldCellModel *cellModel = self.section3List[0];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 3) {
        //Ringing Interval
        self.dataModel.ringingInterval = value;
        MKTextFieldCellModel *cellModel = self.section3List[0];
        cellModel.textFieldValue = value;
        return;
    }
}

#pragma mark - MKBXDNotificationTypePickerViewDelegate
- (void)bxd_notiTypePickerViewTypeChanged:(NSInteger)type {
    self.dataModel.alarmNotiType = type;
    [self.tableView reloadData];
}

#pragma mark - loadCellDatas
- (NSInteger)loadNumberOfRows:(NSInteger)section {
    if (section == 0) {
        if (self.dataModel.alarmNotiType == 1 || self.dataModel.alarmNotiType == 3) {
            //LED/LED+Buzzer
            return self.section0List.count;
        }
    }
    if (section == 1) {
        if (self.dataModel.alarmNotiType == 1 || self.dataModel.alarmNotiType == 3) {
            //LED/LED+Vibration/LED+Buzzer
            return self.section1List.count;
        }
    }
    if (section == 2) {
        if (self.dataModel.alarmNotiType == 2 || self.dataModel.alarmNotiType == 3) {
            //Buzzer/LED+Buzzer
            return self.section2List.count;
        }
    }
    if (section == 3) {
        if (self.dataModel.alarmNotiType == 2 || self.dataModel.alarmNotiType == 3) {
            //Buzzer/LED+Buzzer
            return self.section3List.count;
        }
    }
    return 0;
}

- (CGFloat)heightForHeaderInSection:(NSInteger)section {
    if (self.dataModel.alarmNotiType == 1) {
        //LED
        if (section == 0) {
            return 10.f;
        }
    }
    if (self.dataModel.alarmNotiType == 2) {
        //Buzzer
        if (section == 2) {
            return 10.f;
        }
    }
    if (self.dataModel.alarmNotiType == 3) {
        //LED+Buzzer
        if (section == 0 || section == 2) {
            return 10.f;
        }
    }
    return 0.f;
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
        [self loadSectionDatas];
        [self.headerView updateNotificationType:self.dataModel.alarmNotiType];
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
    
    for (NSInteger i = 0; i < 4; i ++) {
        MKTableSectionLineHeaderModel *headerModel = [[MKTableSectionLineHeaderModel alloc] init];
        [self.headerList addObject:headerModel];
    }
    
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    MKNormalTextCellModel *cellModel = [[MKNormalTextCellModel alloc] init];
    cellModel.leftMsg = @"LED notification";
    [self.section0List addObject:cellModel];
}

- (void)loadSection1Datas {
    MKTextFieldCellModel *cellModel1 = [[MKTextFieldCellModel alloc] init];
    cellModel1.index = 0;
    cellModel1.msg = @"Blinking time";
    cellModel1.textPlaceholder = @"1~6000";
    cellModel1.textFieldValue = self.dataModel.blinkingTime;
    cellModel1.textFieldType = mk_realNumberOnly;
    cellModel1.unit = @"x100ms";
    cellModel1.maxLength = 4;
    [self.section1List addObject:cellModel1];
    
    MKTextFieldCellModel *cellModel2 = [[MKTextFieldCellModel alloc] init];
    cellModel2.index = 1;
    cellModel2.msg = @"Blinking interval";
    cellModel2.textPlaceholder = @"1~100";
    cellModel2.textFieldValue = self.dataModel.blinkingInterval;
    cellModel2.textFieldType = mk_realNumberOnly;
    cellModel2.unit = @"x100ms";
    cellModel2.maxLength = 3;
    [self.section1List addObject:cellModel2];
}

- (void)loadSection2Datas {
    MKNormalTextCellModel *cellModel = [[MKNormalTextCellModel alloc] init];
    cellModel.leftMsg = @"Buzzer notification";
    [self.section2List addObject:cellModel];
}

- (void)loadSection3Datas {
    MKTextFieldCellModel *cellModel1 = [[MKTextFieldCellModel alloc] init];
    cellModel1.index = 2;
    cellModel1.msg = @"Ringing time";
    cellModel1.textPlaceholder = @"1~6000";
    cellModel1.textFieldValue = self.dataModel.ringingTime;
    cellModel1.textFieldType = mk_realNumberOnly;
    cellModel1.unit = @"x100ms";
    cellModel1.maxLength = 4;
    [self.section3List addObject:cellModel1];
    
    MKTextFieldCellModel *cellModel2 = [[MKTextFieldCellModel alloc] init];
    cellModel2.index = 3;
    cellModel2.msg = @"Ringing interval";
    cellModel2.textPlaceholder = @"1~100";
    cellModel2.textFieldValue = self.dataModel.ringingInterval;
    cellModel2.textFieldType = mk_realNumberOnly;
    cellModel2.unit = @"x100ms";
    cellModel2.maxLength = 3;
    [self.section3List addObject:cellModel2];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Alarm notification type";
    self.view.backgroundColor = RGBCOLOR(242, 242, 242);
    [self.rightButton setImage:LOADICON(@"MKBeaconXDButton", @"MKBXDAlarmNotiTypeController", @"bxd_slotSaveIcon.png") forState:UIControlStateNormal];
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
        _tableView.tableHeaderView = self.headerView;
    }
    return _tableView;
}

- (MKBXDNotificationTypePickerView *)headerView {
    if (!_headerView) {
        _headerView = [[MKBXDNotificationTypePickerView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, 100.f)];
        _headerView.delegate = self;
        _headerView.dataModel = self.headerViewModel;
    }
    return _headerView;
}

- (MKBXDNotificationTypePickerViewModel *)headerViewModel {
    if (!_headerViewModel) {
        _headerViewModel = [[MKBXDNotificationTypePickerViewModel alloc] init];
        _headerViewModel.needButton = NO;
        _headerViewModel.typeLabelMsg = @"Alarm notification type";
    }
    return _headerViewModel;
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

- (NSMutableArray *)headerList {
    if (!_headerList) {
        _headerList = [NSMutableArray array];
    }
    return _headerList;
}

- (MKBXDAlarmNotiTypeModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKBXDAlarmNotiTypeModel alloc] init];
        _dataModel.alarmType = self.pageType;
    }
    return _dataModel;
}

@end
