//
//  MKBXDTabBarController.m
//  MKBeaconXDButton_Example
//
//  Created by aa on 2022/2/19.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXDTabBarController.h"

#import "MKMacroDefines.h"
#import "MKBaseNavigationController.h"

#import "MKAlertView.h"

#import "MKBXDBaseLogManager.h"

#import "MKBXDCentralManager.h"

#import "MKBXDConnectManager.h"

#import "MKBXDAlarmController.h"
#import "MKBXDAlarmV2Controller.h"
#import "MKBXDSettingController.h"
#import "MKBXDDeviceController.h"

@interface MKBXDTabBarController ()

/// 当触发
/// 01:表示连接成功后，1分钟内没有通过密码验证（未输入密码，或者连续输入密码错误）认为超时，返回结果， 然后断开连接
/// 02:修改密码成功后，返回结果，断开连接
/// 03:恢复出厂设置
/// 04:关机

@property (nonatomic, assign)BOOL disconnectType;

@end

@implementation MKBXDTabBarController

- (void)dealloc {
    NSLog(@"MKBXDTabBarController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (![[self.navigationController viewControllers] containsObject:self]){
        [[MKBXDCentralManager shared] disconnect];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubPages];
    [self addNotifications];
}

- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gotoScanPage)
                                                 name:@"mk_bxd_popToRootViewControllerNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dfuUpdateComplete)
                                                 name:@"mk_bxd_centralDeallocNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(centralManagerStateChanged)
                                                 name:mk_bxd_centralManagerStateChangedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(disconnectTypeNotification:)
                                                 name:mk_bxd_deviceDisconnectTypeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceConnectStateChanged)
                                                 name:mk_bxd_peripheralConnectStateChangedNotification
                                               object:nil];
}

#pragma mark - notes
- (void)gotoScanPage {
    @weakify(self);
    [self dismissViewControllerAnimated:YES completion:^{
        @strongify(self);
        if ([self.delegate respondsToSelector:@selector(mk_bxd_needResetScanDelegate:)]) {
            [self.delegate mk_bxd_needResetScanDelegate:NO];
        }
    }];
}

- (void)dfuUpdateComplete {
    @weakify(self);
    [self dismissViewControllerAnimated:YES completion:^{
        @strongify(self);
        if ([self.delegate respondsToSelector:@selector(mk_bxd_needResetScanDelegate:)]) {
            [self.delegate mk_bxd_needResetScanDelegate:YES];
        }
    }];
}

- (void)disconnectTypeNotification:(NSNotification *)note {
    NSString *type = note.userInfo[@"type"];
    //02:修改密码成功后，返回结果，断开连接
    //03:恢复出厂设置
    //04:关机
    self.disconnectType = YES;
    if ([type isEqualToString:@"02"]) {
        [self showAlertWithMsg:@"Modify password success! Please reconnect the Device." title:@""];
        return;
    }
    if ([type isEqualToString:@"03"]) {
        [self showAlertWithMsg:@"Factory reset successfully!Please reconnect the device." title:@"Factory Reset"];
        return;
    }
    if ([type isEqualToString:@"04"]) {
        [self gotoScanPage];
//        [self showAlertWithMsg:@"Beacon is disconnected." title:@"Reset success!"];
        return;
    }
}

- (void)centralManagerStateChanged{
    if (self.disconnectType) {
        return;
    }
    if ([MKBXDCentralManager shared].centralStatus != mk_bxd_centralManagerStatusEnable) {
        [self showAlertWithMsg:@"The current system of bluetooth is not available!" title:@"Dismiss"];
    }
}

- (void)deviceConnectStateChanged {
     if (self.disconnectType) {
        return;
    }
    [self showAlertWithMsg:@"The device is disconnected." title:@"Dismiss"];
    return;
}

#pragma mark - private method
- (void)showAlertWithMsg:(NSString *)msg title:(NSString *)title{
    //让setting页面推出的alert消失
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_bxd_needDismissAlert" object:nil];
    //让所有MKPickView消失
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_customUIModule_dismissPickView" object:nil];
    
    @weakify(self);
    MKAlertViewAction *confirmAction = [[MKAlertViewAction alloc] initWithTitle:@"OK" handler:^{
        @strongify(self);
        [self gotoScanPage];
    }];
    MKAlertView *alertView = [[MKAlertView alloc] init];
    [alertView addAction:confirmAction];
    [alertView showAlertWithTitle:title message:msg notificationName:@"mk_bxd_needDismissAlert"];
}

- (void)loadSubPages {
    UIViewController *alarmPage = nil;
    if ([[MKBXDConnectManager shared].deviceType integerValue] == 1) {
        //1  新固件
        alarmPage = [[MKBXDAlarmV2Controller alloc] init];
        
    }else {
        //0  旧固件
        alarmPage = [[MKBXDAlarmController alloc] init];
    }
    alarmPage.tabBarItem.title = @"ALARM";
    alarmPage.tabBarItem.image = LOADICON(@"MKBeaconXDButton", @"MKBXDTabBarController", @"bxd_slotTabBarItemUnselected.png");
    alarmPage.tabBarItem.selectedImage = LOADICON(@"MKBeaconXDButton", @"MKBXDTabBarController", @"bxd_slotTabBarItemSelected.png");
    MKBaseNavigationController *alarmNav = [[MKBaseNavigationController alloc] initWithRootViewController:alarmPage];
    
    MKBXDSettingController *settingPage = [[MKBXDSettingController alloc] init];
    settingPage.tabBarItem.title = @"SETTING";
    settingPage.tabBarItem.image = LOADICON(@"MKBeaconXDButton", @"MKBXDTabBarController", @"bxd_settingTabBarItemUnselected.png");
    settingPage.tabBarItem.selectedImage = LOADICON(@"MKBeaconXDButton", @"MKBXDTabBarController", @"bxd_settingTabBarItemSelected.png");
    MKBaseNavigationController *settingNav = [[MKBaseNavigationController alloc] initWithRootViewController:settingPage];

    MKBXDDeviceController *devicePage = [[MKBXDDeviceController alloc] init];
    devicePage.tabBarItem.title = @"DEVICE";
    devicePage.tabBarItem.image = LOADICON(@"MKBeaconXDButton", @"MKBXDTabBarController", @"bxd_deviceTabBarItemUnselected.png");
    devicePage.tabBarItem.selectedImage = LOADICON(@"MKBeaconXDButton", @"MKBXDTabBarController", @"bxd_deviceTabBarItemSelected.png");
    MKBaseNavigationController *deviceNav = [[MKBaseNavigationController alloc] initWithRootViewController:devicePage];
    
    self.viewControllers = @[alarmNav,settingNav,deviceNav];
}

@end
