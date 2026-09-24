//
//  SceneDelegate.h
//  MKBeaconXDButton_Example
//
//  Created by aa on 2026/9/24.
//  Copyright © 2026 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreBluetooth/CoreBluetooth.h>

#import <UserNotifications/UserNotifications.h>

NS_ASSUME_NONNULL_BEGIN

@interface SceneDelegate : UIResponder <UIWindowSceneDelegate, UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;

@end

NS_ASSUME_NONNULL_END
