//
//  CTMediator+MKBXDAdd.m
//  MKBeaconXDButton_Example
//
//  Created by aa on 2022/2/18.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "CTMediator+MKBXDAdd.h"

#import "MKBXPButtonDModuleKey.h"

@implementation CTMediator (MKBXDAdd)

/// 关于页面
- (UIViewController *)CTMediator_BXPButton_D_AboutPage {
    UIViewController *viewController = [self performTarget:kTarget_bxp_button_module
                                                    action:kAction_bxp_button_aboutPage
                                                    params:@{}
                                         shouldCacheTarget:NO];
    if ([viewController isKindOfClass:[UIViewController class]]) {
        return viewController;
    }
    return [self performTarget:kTarget_bxp_button_d_module
                        action:kAction_bxp_button_d_aboutPage
                        params:@{}
             shouldCacheTarget:NO];
}

#pragma mark - private method
- (UIViewController *)Action_LoRaApp_ViewControllerWithTarget:(NSString *)targetName
                                                       action:(NSString *)actionName
                                                       params:(NSDictionary *)params{
    UIViewController *viewController = [self performTarget:targetName
                                                    action:actionName
                                                    params:params
                                         shouldCacheTarget:NO];
    if ([viewController isKindOfClass:[UIViewController class]]) {
        // view controller 交付出去之后，可以由外界选择是push还是present
        return viewController;
    } else {
        // 这里处理异常场景，具体如何处理取决于产品
        return [[UIViewController alloc] init];
    }
}

@end
