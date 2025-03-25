//
//  MKBXDDismissConfigModel.m
//  MKBeaconXDButton_Example
//
//  Created by aa on 2022/2/21.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXDDismissConfigModel.h"

#import "MKMacroDefines.h"

#import "MKBXDConnectManager.h"

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
        if ([MKBXDConnectManager shared].isCR) {
            if (![self readVibrationParams]) {
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
        if (![self configDismissType]) {
            [self operationFailedBlockWithMsg:@"Config Dismiss Type Error" block:failedBlock];
            return;
        }
        if ([MKBXDConnectManager shared].isCR) {
            if (self.dismissAlarmNotiType == 1 || self.dismissAlarmNotiType == 4 || self.dismissAlarmNotiType == 5) {
                //LED/LED+Vibration/LED+Buzzer
                if (![self configLEDParams]) {
                    [self operationFailedBlockWithMsg:@"Config LED Params Error" block:failedBlock];
                    return;
                }
            }
            if (self.dismissAlarmNotiType == 2 || self.dismissAlarmNotiType == 4) {
                //Vibaration/LED+Vibration
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
        }else {
            if (self.dismissAlarmNotiType == 1 || self.dismissAlarmNotiType == 3) {
                //LED/LED+Buzzer
                if (![self configLEDParams]) {
                    [self operationFailedBlockWithMsg:@"Config LED Params Error" block:failedBlock];
                    return;
                }
            }
            if (self.dismissAlarmNotiType == 2 || self.dismissAlarmNotiType == 3) {
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
- (BOOL)readDismissType {
    __block BOOL success = NO;
    [MKBXDInterface bxd_readDismissAlarmNotificationTypeWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        NSInteger type = [returnData[@"result"][@"type"] integerValue];
        if ([MKBXDConnectManager shared].isCR) {
            self.dismissAlarmNotiType = type;
        }else {
            if (type == 0) {
                self.dismissAlarmNotiType = 0;
            }else if (type == 1) {
                self.dismissAlarmNotiType = 1;
            }else if (type == 3) {
                self.dismissAlarmNotiType = 2;
            }else if (type == 5) {
                self.dismissAlarmNotiType = 3;
            }
        }
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configDismissType {
    __block BOOL success = NO;
    mk_bxd_reminderType reminderType = mk_bxd_reminderType_silent;
    if ([MKBXDConnectManager shared].isCR) {
        reminderType = self.dismissAlarmNotiType;
    }else {
        if (self.dismissAlarmNotiType == 1) {
            reminderType = mk_bxd_reminderType_led;
        }else if (self.dismissAlarmNotiType == 2) {
            reminderType = mk_bxd_reminderType_buzzer;
        }else if (self.dismissAlarmNotiType == 3) {
            reminderType = mk_bxd_reminderType_ledAndBuzzer;
        }
    }
    [MKBXDInterface bxd_configDismissAlarmNotificationType:reminderType sucBlock:^{
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
    BOOL needValidLed = NO;
    BOOL needValidVibration = NO;
    BOOL needValidBuzzer = NO;
    if ([MKBXDConnectManager shared].isCR) {
        if (self.dismissAlarmNotiType == 1 || self.dismissAlarmNotiType == 4 || self.dismissAlarmNotiType == 5) {
            //LED/LED+Vibration/LED+Buzzer
            needValidLed = YES;
        }
        if (self.dismissAlarmNotiType == 2 || self.dismissAlarmNotiType == 4) {
            //Vibaration/LED+Vibration
            needValidVibration = YES;
        }
        if (self.dismissAlarmNotiType == 3 || self.dismissAlarmNotiType == 5) {
            //Buzzer/LED+Buzzer
            needValidBuzzer = YES;
        }
    }else {
        if (self.dismissAlarmNotiType == 1 || self.dismissAlarmNotiType == 3) {
            //LED/LED+Buzzer
            needValidLed = YES;
        }
        if (self.dismissAlarmNotiType == 2 || self.dismissAlarmNotiType == 3) {
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
        _readQueue = dispatch_queue_create("DismissAlarmQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
