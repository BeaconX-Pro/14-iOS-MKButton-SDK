//
//  SceneDelegate.m
//  MKBeaconXDButton_Example
//
//  Created by aa on 2026/9/24.
//  Copyright © 2026 aadyx2007@163.com. All rights reserved.
//

#import "SceneDelegate.h"

#import "MKBXDCentralManager.h"

#import "MKBXDScanController.h"

@interface SceneDelegate ()<mk_bxd_stateRestorationDelegate>

@property (nonatomic, strong)UIWindow *window;

@property (nonatomic, strong)UIView *launchView;

@end

@implementation SceneDelegate

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    if (![scene isKindOfClass:[UIWindowScene class]]) {
        return;
    }
    
    // 设置通知代理
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    
    // 设置状态恢复代理
    [MKBXDCentralManager shared].restorationDelegate = self;
    
    // 设置状态恢复完成回调
    [MKBXDCentralManager setStateRestorationCompletion:^(NSArray<CBPeripheral *> *restoredPeripherals) {
        NSLog(@"✅ 状态恢复完成，恢复了 %lu 个设备", (unsigned long)restoredPeripherals.count);
        
        for (CBPeripheral *peripheral in restoredPeripherals) {
            NSLog(@"恢复的设备: %@, 状态: %ld", peripheral.name ?: peripheral.identifier.UUIDString, (long)peripheral.state);
            
            if (peripheral.state == CBPeripheralStateConnected) {
                NSLog(@"设备已连接，可以重新验证密码并订阅通知");
                // 发送通知到扫描页面
                [[NSNotificationCenter defaultCenter] postNotificationName:@"MKBXDDeviceRestoredNotification"
                                                                    object:nil
                                                                  userInfo:@{@"peripheral": peripheral}];
            }
        }
        
        // 可选：发送本地通知提示用户
        if (restoredPeripherals.count > 0) {
            [self sendLocalNotification:[NSString stringWithFormat:@"恢复了 %lu 个设备", (unsigned long)restoredPeripherals.count]];
        }
    }];
    
    // 检查是否从状态恢复启动
    if ([MKBXDCentralManager isLaunchedFromStateRestoration]) {
        NSLog(@"✅ 应用从终止状态被系统唤醒（蓝牙事件触发）");
        [self sendLocalNotification:@"应用已被唤醒，正在恢复蓝牙连接"];
    } else {
        NSLog(@"✅ 应用正常启动");
    }
    
    // 设置窗口和根视图
    UIWindowScene *windowScene = (UIWindowScene *)scene;
    self.window = [[UIWindow alloc] initWithWindowScene:windowScene];
    self.window.backgroundColor = [UIColor whiteColor];
    MKBXDScanController *vc = [[MKBXDScanController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    [self addLaunchScreen];
}

- (void)sceneDidDisconnect:(UIScene *)scene {
    // 场景被释放时调用（不一定会调用）
}

- (void)sceneDidBecomeActive:(UIScene *)scene {
    // 场景从非活跃状态进入活跃状态
}

- (void)sceneWillResignActive:(UIScene *)scene {
    // 场景即将从活跃状态进入非活跃状态
}

- (void)sceneWillEnterForeground:(UIScene *)scene {
    // 场景即将进入前台
}

- (void)sceneDidEnterBackground:(UIScene *)scene {
    // 标记应用进入后台，用于下次启动时检测状态恢复
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"MKBXD_WAS_TERMINATED"];
    [defaults synchronize];
    
    NSLog(@"📱 应用进入后台");
}

#pragma mark - mk_bxd_stateRestorationDelegate
- (void)mk_bxd_didRestoreStateWithPeripherals:(NSArray<CBPeripheral *> *)peripherals {
    NSLog(@"✅ 代理回调：状态恢复了 %lu 个设备", (unsigned long)peripherals.count);
    
    for (CBPeripheral *peripheral in peripherals) {
        NSLog(@"代理回调 - 设备: %@, 状态: %ld", peripheral.name ?: peripheral.identifier.UUIDString, (long)peripheral.state);
    }
    
    // 发送通知给其他ViewController
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MKBXDStateRestorationNotification"
                                                        object:nil
                                                      userInfo:@{@"peripherals": peripherals}];
}

#pragma mark - Local Notification
- (void)sendLocalNotification:(NSString *)message {
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"MKBeaconXDButton";
    content.body = message;
    content.sound = [UNNotificationSound defaultSound];
    
    // 1秒后触发
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];
    
    // 创建请求
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"MKBXDStateRestoration"
                                                                          content:content
                                                                          trigger:trigger];
    
    // 发送通知
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request
                                                            withCompletionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"❌ 发送本地通知失败: %@", error);
        } else {
            NSLog(@"✅ 本地通知已发送: %@", message);
        }
    }];
}

#pragma mark - UNUserNotificationCenterDelegate
// 应用在前台时也显示通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    // iOS 18 环境下使用新 API
    completionHandler(UNNotificationPresentationOptionList | UNNotificationPresentationOptionBanner | UNNotificationPresentationOptionSound);
}

#pragma mark - Private Methods
- (void)addLaunchScreen {
    UIViewController *viewController = [[UIStoryboard storyboardWithName:@"LaunchScreen" bundle:nil] instantiateViewControllerWithIdentifier:@"LaunchImageBoard"];
    self.launchView = viewController.view;
    [self.window addSubview:self.launchView];
    [self.window bringSubviewToFront:self.launchView];
    
    [self performSelector:@selector(launchViewRemoved) withObject:nil afterDelay:1.f];
}

- (void)launchViewRemoved {
    if (!self.launchView || !self.launchView.superview) {
        return;
    }
    [UIView animateWithDuration:.5f animations:^{
        self.launchView.alpha = 0.0;
        self.launchView.transform = CGAffineTransformMakeScale(1.2, 1.2);
     }completion:^(BOOL finished) {
        [self.launchView removeFromSuperview];
         self.launchView = nil;
    }];
}

@end
