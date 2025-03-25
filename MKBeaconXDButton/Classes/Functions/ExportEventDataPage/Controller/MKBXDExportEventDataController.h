//
//  MKBXDExportEventDataController.h
//  MKBeaconXDButton_Example
//
//  Created by aa on 2025/3/19.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseViewController.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MKBXDExportEventDataControllerType) {
    MKBXDExportEventDataControllerTypeSingle,
    MKBXDExportEventDataControllerTypeDouble,
    MKBXDExportEventDataControllerTypeLong,
    MKBXDExportEventDataControllerTypeConnectionMode,
};

@interface MKBXDExportEventDataController : MKBaseViewController

@property (nonatomic, assign)MKBXDExportEventDataControllerType vcType;

@end

NS_ASSUME_NONNULL_END
