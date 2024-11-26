//
//  MKBXDAlarmModeConfigV2Controller.h
//  MKBeaconXDButton_Example
//
//  Created by aa on 2024/11/25.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseViewController.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MKBXDAlarmModeConfigV2ControllerType) {
    MKBXDAlarmModeConfigV2ControllerType_single,
    MKBXDAlarmModeConfigV2ControllerType_double,
    MKBXDAlarmModeConfigV2ControllerType_long,
    MKBXDAlarmModeConfigV2ControllerType_abnormal,
};

@interface MKBXDAlarmModeConfigV2Controller : MKBaseViewController

@property (nonatomic, assign)MKBXDAlarmModeConfigV2ControllerType pageType;

@end

NS_ASSUME_NONNULL_END
