//
//  MKBXDDismissConfigModel.m
//  MKBeaconXDButton_Example
//
//  Created by aa on 2022/2/21.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXDDismissConfigModel.h"

#import "MKMacroDefines.h"

#import "MKBXDInterface.h"
#import "MKBXDInterface+MKBXDConfig.h"

@interface MKBXDDismissConfigModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKBXDDismissConfigModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readDismissType]) {
            [self operationFailedBlockWithMsg:@"Read Dismiss Type Error" block:failedBlock];
            return;
        }
        if (![self readLEDParams]) {
            [self operationFailedBlockWithMsg:@"Read LED Params Error" block:failedBlock];
            return;
        }
        if (![self readVibrationParams]) {
            [self operationFailedBlockWithMsg:@"Read Vibration Params Error" block:failedBlock];
            return;
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
        if (![self configDismissType]) {
            [self operationFailedBlockWithMsg:@"Config Dismiss Type Error" block:failedBlock];
            return;
        }
        
        if (self.dismissAlarmNotiType == 1 || self.dismissAlarmNotiType == 4 || self.dismissAlarmNotiType == 5) {
            //LED/LED+Vibration/LED+Buzzer
            if (![self configLEDParams]) {
                [self operationFailedBlockWithMsg:@"Config LED Params Error" block:failedBlock];
                return;
            }
        }
        if (self.dismissAlarmNotiType == 2 || self.dismissAlarmNotiType == 4) {
            //Vibration/LED+Vibration
            if (![self configVibrationParams]) {
                [self operationFailedBlockWithMsg:@"Config Vibration Params Error" block:failedBlock];
                return;
            }
        }
        if (self.dismissAlarmNotiType == 3 || self.dismissAlarmNotiType == 5) {
            //Buzzer/LED+Buzzer
            if (![self configBuzzerParams]) {
                [self operationFailedBlockWithMsg:@"Config Buzzer Params Error" block:failedBlock];
                return;
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
- (BOOL)readDismissType {
    __block BOOL success = NO;
    [MKBXDInterface bxd_readDismissAlarmNotificationTypeWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.dismissAlarmNotiType = [returnData[@"result"][@"type"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configDismissType {
    __block BOOL success = NO;
    [MKBXDInterface bxd_configDismissAlarmNotificationType:self.dismissAlarmNotiType sucBlock:^{
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
    [MKBXDInterface bxd_readDismissAlarmLEDNotiParamsWithSucBlock:^(id  _Nonnull returnData) {
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
    [MKBXDInterface bxd_configDismissAlarmLEDNotiParams:[self.blinkingTime integerValue] interval:[self.blinkingInterval integerValue] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readVibrationParams {
    __block BOOL success = NO;
    [MKBXDInterface bxd_readDismissAlarmVibrationNotiParamsWithSucBlock:^(id  _Nonnull returnData) {
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

- (BOOL)configVibrationParams {
    __block BOOL success = NO;
    [MKBXDInterface bxd_configDismissAlarmVibrationNotiParams:[self.vibratingTime integerValue] interval:[self.vibratingInterval integerValue] sucBlock:^{
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
    [MKBXDInterface bxd_readDismissAlarmBuzzerNotiParamsWithSucBlock:^(id  _Nonnull returnData) {
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
    [MKBXDInterface bxd_configDismissAlarmBuzzerNotiParams:[self.ringingTime integerValue] interval:[self.ringingInterval integerValue] sucBlock:^{
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
        NSError *error = [[NSError alloc] initWithDomain:@"DismissAlarmParams"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    })
}

- (BOOL)validParams {
    if (self.dismissAlarmNotiType == 0) {
        //Silent
        return YES;
    }
    if (self.dismissAlarmNotiType == 1) {
        //LED
        return [self validLEDParams];
    }
    if (self.dismissAlarmNotiType == 2) {
        //Vibration
        return [self validVibratingParams];
    }
    if (self.dismissAlarmNotiType == 3) {
        //Buzzer
        return [self validBuzzerParams];
    }
    if (self.dismissAlarmNotiType == 4) {
        //LED+Vibration
        if (![self validLEDParams] || ![self validVibratingParams]) {
            return NO;
        }
        return YES;
    }
    if (self.dismissAlarmNotiType == 5) {
        //LED+Buzzer
        if (![self validLEDParams] || ![self validBuzzerParams]) {
            return NO;
        }
        return YES;
    }
    return YES;
}

- (BOOL)validLEDParams {
    if (!ValidStr(self.blinkingTime) || [self.blinkingTime integerValue] < 1 || [self.blinkingTime integerValue] > 6000) {
        return NO;
    }
    if (!ValidStr(self.blinkingInterval) || [self.blinkingInterval integerValue] < 1 || [self.blinkingInterval integerValue] > 100) {
        return NO;
    }
    return YES;
}

- (BOOL)validVibratingParams {
    if (!ValidStr(self.vibratingTime) || [self.vibratingTime integerValue] < 1 || [self.vibratingTime integerValue] > 6000) {
        return NO;
    }
    if (!ValidStr(self.vibratingInterval) || [self.vibratingInterval integerValue] < 1 || [self.vibratingInterval integerValue] > 100) {
        return NO;
    }
    return YES;
}

- (BOOL)validBuzzerParams {
    if (!ValidStr(self.ringingTime) || [self.ringingTime integerValue] < 1 || [self.ringingTime integerValue] > 6000) {
        return NO;
    }
    if (!ValidStr(self.ringingInterval) || [self.ringingInterval integerValue] < 1 || [self.ringingInterval integerValue] > 100) {
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
        _readQueue = dispatch_queue_create("DismissAlarmQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
