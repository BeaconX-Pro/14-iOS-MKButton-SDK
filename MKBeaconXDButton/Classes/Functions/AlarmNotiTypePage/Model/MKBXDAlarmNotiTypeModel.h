//
//  MKBXDAlarmNotiTypeModel.h
//  MKBeaconXDButton_Example
//
//  Created by aa on 2022/2/20.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXDAlarmNotiTypeModel : NSObject

/// 0:single 1:double 2:long 3:abnormal
@property (nonatomic, assign)NSInteger alarmType;

/*
 0:Silent
 1:LED
 2:Buzzer
 3:LED+Buzzer
 */
@property (nonatomic, assign)NSInteger alarmNotiType;

#pragma mark - LED notification
@property (nonatomic, copy)NSString *blinkingTime;

@property (nonatomic, copy)NSString *blinkingInterval;

#pragma mark - Buzzer notification
@property (nonatomic, copy)NSString *ringingTime;

@property (nonatomic, copy)NSString *ringingInterval;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
