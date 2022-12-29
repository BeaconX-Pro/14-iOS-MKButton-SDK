//
//  MKBXDAlarmDataExportController.h
//  MKBeaconXDButton_Example
//
//  Created by aa on 2022/3/9.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseViewController.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MKBXDAlarmDataExportControllerType) {
    MKBXDAlarmDataExportControllerType_single,
    MKBXDAlarmDataExportControllerType_double,
    MKBXDAlarmDataExportControllerType_long,
};

@interface MKBXDAlarmDataExportController : MKBaseViewController

@property (nonatomic, assign)MKBXDAlarmDataExportControllerType pageType;

@end

NS_ASSUME_NONNULL_END
