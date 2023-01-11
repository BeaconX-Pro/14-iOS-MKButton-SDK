//
//  MKBXDRemoteReminderModel.h
//  MKBeaconXDButton_Example
//
//  Created by aa on 2022/2/21.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXDRemoteReminderModel : NSObject

#pragma mark - LED notification
@property (nonatomic, copy)NSString *blinkingTime;

@property (nonatomic, copy)NSString *blinkingInterval;

#pragma mark - Buzzer notification
@property (nonatomic, copy)NSString *ringingTime;

@property (nonatomic, copy)NSString *ringingInterval;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
