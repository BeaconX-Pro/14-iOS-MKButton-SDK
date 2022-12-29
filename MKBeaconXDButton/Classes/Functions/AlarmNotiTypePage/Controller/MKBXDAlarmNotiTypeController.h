//
//  MKBXDAlarmNotiTypeController.h
//  MKBeaconXDButton_Example
//
//  Created by aa on 2022/2/20.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseViewController.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MKBXDAlarmNotiTypeControllerType) {
    MKBXDAlarmNotiTypeControllerType_single,
    MKBXDAlarmNotiTypeControllerType_double,
    MKBXDAlarmNotiTypeControllerType_long,
    MKBXDAlarmNotiTypeControllerType_abnormal,
};

@interface MKBXDAlarmNotiTypeController : MKBaseViewController

@property (nonatomic, assign)MKBXDAlarmNotiTypeControllerType pageType;

@end

NS_ASSUME_NONNULL_END
