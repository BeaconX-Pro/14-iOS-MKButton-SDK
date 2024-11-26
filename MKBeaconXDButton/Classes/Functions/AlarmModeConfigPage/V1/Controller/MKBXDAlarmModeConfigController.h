//
//  MKBXDAlarmModeConfigController.h
//  MKBeaconXDButton_Example
//
//  Created by aa on 2022/2/19.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseViewController.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MKBXDAlarmModeConfigControllerType) {
    MKBXDAlarmModeConfigControllerType_single,
    MKBXDAlarmModeConfigControllerType_double,
    MKBXDAlarmModeConfigControllerType_long,
    MKBXDAlarmModeConfigControllerType_abnormal,
};

@interface MKBXDAlarmModeConfigController : MKBaseViewController

@property (nonatomic, assign)MKBXDAlarmModeConfigControllerType pageType;

@end

NS_ASSUME_NONNULL_END
