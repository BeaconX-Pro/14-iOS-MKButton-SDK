//
//  MKBXDAlarmPageModel.h
//  MKBeaconXDButton_Example
//
//  Created by aa on 2022/2/19.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXDAlarmPageModel : NSObject

@property (nonatomic, assign)BOOL singleIsOn;

@property (nonatomic, assign)BOOL doubleIsOn;

@property (nonatomic, assign)BOOL longIsOn;

@property (nonatomic, assign)BOOL inactivityIsOn;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
