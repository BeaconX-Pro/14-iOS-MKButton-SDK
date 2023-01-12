//
//  Target_BXD_Module.m
//  MKBeaconXDButton_Example
//
//  Created by aa on 2022/2/18.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "Target_BXD_Module.h"

#import "MKBXDScanController.h"
#import "MKBXDAboutController.h"

@implementation Target_BXD_Module

/// 扫描页面
- (UIViewController *)Action_BXPButton_D_Module_ScanController:(NSDictionary *)params {
    return [[MKBXDScanController alloc] init];
}

/// 关于页面
- (UIViewController *)Action_BXPButton_D_Module_AboutController:(NSDictionary *)params {
    return [[MKBXDAboutController alloc] init];
}

@end
