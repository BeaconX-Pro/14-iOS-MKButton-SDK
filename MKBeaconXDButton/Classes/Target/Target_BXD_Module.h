//
//  Target_BXD_Module.h
//  MKBeaconXDButton_Example
//
//  Created by aa on 2022/2/18.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Target_BXD_Module : NSObject

/// 扫描页面
- (UIViewController *)Action_BXPButton_D_Module_ScanController:(NSDictionary *)params;

/// 关于页面
- (UIViewController *)Action_BXPButton_D_Module_AboutController:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
