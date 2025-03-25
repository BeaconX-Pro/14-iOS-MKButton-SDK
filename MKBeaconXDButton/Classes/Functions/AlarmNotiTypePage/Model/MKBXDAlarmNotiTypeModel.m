//
//  MKBXDAlarmNotiTypeModel.m
//  MKBeaconXDButton_Example
//
//  Created by aa on 2022/2/20.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXDAlarmNotiTypeModel.h"

#import "MKMacroDefines.h"

#import "MKBXDConnectManager.h"

#import "MKBXDInterface.h"
#import "MKBXDInterface+MKBXDConfig.h"

@interface MKBXDAlarmNotiTypeModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKBXDAlarmNotiTypeModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readAlarmType]) {
            [self operationFailedBlockWithMsg:@"Read Alarm Type Error" block:failedBlock];
            return;
        }
        if (![self readLEDParams]) {
            [self operationFailedBlockWithMsg:@"Read LED Params Error" block:failedBlock];
            return;
        }
        if ([MKBXDConnectManager shared].isCR) {
            if (![self readVibrateParams]) {
                [self operationFailedBlockWithMsg:@"Read Vibration Params Error" block:failedBlock];
                return;
            }
        }
        if (![self readBuzzerParams]) {
            [self operationFailedBlockWithMsg:@"Read Buzzer Params Error" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self validParams]) {
            [self operationFailedBlockWithMsg:@"Params Error" block:failedBlock];
            return;
        }
        if (![self configAlarmType]) {
            [self operationFailedBlockWithMsg:@"Config Alarm Type Error" block:failedBlock];
            return;
        }
        if ([MKBXDConnectManager shared].isCR) {
            if (self.alarmNotiType == 1 || self.alarmNotiType == 4 || self.alarmNotiType == 5) {
                //LED/LED+Vibration/LED+Buzzer
                if (![self configLEDParams]) {
                    [self operationFailedBlockWithMsg:@"Config LED Params Error" block:failedBlock];
                    return;
                }
            }
            if (self.alarmNotiType == 2 || self.alarmNotiType == 4) {
                //Vibaration/LED+Vibration
                if (![self configVibrateParams]) {
                    [self operationFailedBlockWithMsg:@"Config Vibration Params Error" block:failedBlock];
                    return;
                }
            }
            if (self.alarmNotiType == 3 || self.alarmNotiType == 5) {
                //Buzzer/LED+Buzzer
                if (![self configBuzzerParams]) {
                    [self operationFailedBlockWithMsg:@"Config Buzzer Params Error" block:failedBlock];
                    return;
                }
            }
        }else {
            if (self.alarmNotiType == 1 || self.alarmNotiType == 3) {
                //LED/LED+Buzzer
                if (![self configLEDParams]) {
                    [self operationFailedBlockWithMsg:@"Config LED Params Error" block:failedBlock];
                    return;
                }
            }
            if (self.alarmNotiType == 2 || self.alarmNotiType == 3) {
                //Buzzer/LED+Buzzer
                if (![self configBuzzerParams]) {
                    [self operationFailedBlockWithMsg:@"Config Buzzer Params Error" block:failedBlock];
                    return;
                }
            }
        }
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

#pragma mark - interface
- (BOOL)readAlarmType {
    __block BOOL success = NO;
    [MKBXDInterface bxd_readAlarmNotificationType:self.alarmType sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.alarmNotiType = [returnData[@"result"][@"alarmNotificationType"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configAlarmType {
    __block BOOL success = NO;
    [MKBXDInterface bxd_configAlarmNotificationType:self.alarmType reminderType:self.alarmNotiType sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readLEDParams {
    __block BOOL success = NO;
    [MKBXDInterface bxd_readAlarmLEDNotiParams:self.alarmType sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.blinkingTime = returnData[@"result"][@"time"];
        self.blinkingInterval = returnData[@"result"][@"interval"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configLEDParams {
    __block BOOL success = NO;
    [MKBXDInterface bxd_configAlarmLEDNotiParams:self.alarmType blinkingTime:[self.blinkingTime integerValue] blinkingInterval:[self.blinkingInterval integerValue] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readVibrateParams {
    __block BOOL success = NO;
    [MKBXDInterface bxd_readAlarmVibrateNotiParams:self.alarmType sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.vibratingTime = returnData[@"result"][@"time"];
        self.vibratingInterval = returnData[@"result"][@"interval"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configVibrateParams {
    __block BOOL success = NO;
    [MKBXDInterface bxd_configAlarmVibrateNotiParams:self.alarmType vibratingTime:[self.vibratingTime integerValue] vibratingInterval:[self.vibratingInterval integerValue] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readBuzzerParams {
    __block BOOL success = NO;
    [MKBXDInterface bxd_readAlarmBuzzerNotiParams:self.alarmType sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.ringingTime = returnData[@"result"][@"time"];
        self.ringingInterval = returnData[@"result"][@"interval"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configBuzzerParams {
    __block BOOL success = NO;
    [MKBXDInterface bxd_configAlarmBuzzerNotiParams:self.alarmType ringingTime:[self.ringingTime integerValue] ringingInterval:[self.ringingInterval integerValue] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

#pragma mark - private method
- (void)operationFailedBlockWithMsg:(NSString *)msg block:(void (^)(NSError *error))block {
    moko_dispatch_main_safe(^{
        NSError *error = [[NSError alloc] initWithDomain:@"AlarmNotiTypeParams"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    })
}

- (BOOL)validParams {
    if (self.alarmNotiType == 0) {
        //Silent
        return YES;
    }
    BOOL needValidLed = NO;
    BOOL needValidVibration = NO;
    BOOL needValidBuzzer = NO;
    if ([MKBXDConnectManager shared].isCR) {
        if (self.alarmNotiType == 1 || self.alarmNotiType == 4 || self.alarmNotiType == 5) {
            //LED/LED+Vibration/LED+Buzzer
            needValidLed = YES;
        }
        if (self.alarmNotiType == 2 || self.alarmNotiType == 4) {
            //Vibaration/LED+Vibration
            needValidVibration = YES;
        }
        if (self.alarmNotiType == 3 || self.alarmNotiType == 5) {
            //Buzzer/LED+Buzzer
            needValidBuzzer = YES;
        }
    }else {
        if (self.alarmNotiType == 1 || self.alarmNotiType == 3) {
            //LED/LED+Buzzer
            needValidLed = YES;
        }
        if (self.alarmNotiType == 2 || self.alarmNotiType == 3) {
            //Buzzer/LED+Buzzer
            needValidBuzzer = YES;
        }
    }
    if (needValidLed && ![self validLEDParams]) {
        //LED
        return NO;
    }
    if (needValidVibration && ![self validVibrationParams]) {
        //Vibration
        return NO;
    }
    if (needValidBuzzer && ![self validBuzzerParams]) {
        //Buzzer
        return NO;
    }
    return YES;
}

- (BOOL)validLEDParams {
    if (!ValidStr(self.blinkingTime) || [self.blinkingTime integerValue] < 1 || [self.blinkingTime integerValue] > 6000) {
        return NO;
    }
    if (!ValidStr(self.blinkingInterval) || [self.blinkingInterval integerValue] < 0 || [self.blinkingInterval integerValue] > 100) {
        return NO;
    }
    return YES;
}

- (BOOL)validVibrationParams {
    if (!ValidStr(self.vibratingTime) || [self.vibratingTime integerValue] < 1 || [self.vibratingTime integerValue] > 6000) {
        return NO;
    }
    if (!ValidStr(self.vibratingInterval) || [self.vibratingInterval integerValue] < 0 || [self.vibratingInterval integerValue] > 100) {
        return NO;
    }
    return YES;
}

- (BOOL)validBuzzerParams {
    if (!ValidStr(self.ringingTime) || [self.ringingTime integerValue] < 1 || [self.ringingTime integerValue] > 6000) {
        return NO;
    }
    if (!ValidStr(self.ringingInterval) || [self.ringingInterval integerValue] < 0 || [self.ringingInterval integerValue] > 100) {
        return NO;
    }
    return YES;
}

#pragma mark - getter
- (dispatch_semaphore_t)semaphore {
    if (!_semaphore) {
        _semaphore = dispatch_semaphore_create(0);
    }
    return _semaphore;
}

- (dispatch_queue_t)readQueue {
    if (!_readQueue) {
        _readQueue = dispatch_queue_create("AlarmNotiTypeQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
