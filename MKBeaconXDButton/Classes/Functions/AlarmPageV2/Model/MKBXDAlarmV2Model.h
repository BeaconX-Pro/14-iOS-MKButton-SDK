//
//  MKBXDAlarmV2Model.h
//  MKBeaconXDButton_Example
//
//  Created by aa on 2024/11/25.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXDAlarmV2Model : NSObject

@property (nonatomic, assign)BOOL singleIsOn;

@property (nonatomic, assign)BOOL doubleIsOn;

@property (nonatomic, assign)BOOL longIsOn;

@property (nonatomic, assign)BOOL inactivityIsOn;

@property (nonatomic, copy)NSString *alarmEventCount;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;


@end

NS_ASSUME_NONNULL_END
