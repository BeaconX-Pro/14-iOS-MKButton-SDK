//
//  MKBXDAlarmModeConfigModel.m
//  MKBeaconXDButton_Example
//
//  Created by aa on 2022/2/19.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXDAlarmModeConfigModel.h"

#import "MKMacroDefines.h"

#import "MKBXDInterface.h"
#import "MKBXDInterface+MKBXDConfig.h"

#import "MKBXDAlarmModeParamsModel.h"

@interface MKBXDAlarmModeConfigModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKBXDAlarmModeConfigModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readAlarmStatus]) {
            [self operationFailedBlockWithMsg:@"Read Alarm Status Error" block:failedBlock];
            return;
        }
        if (![self readTriggerChannelAdvParams]) {
            [self operationFailedBlockWithMsg:@"Read Trigger Channel Adv Params Error" block:failedBlock];
            return;
        }
        if (![self readChannelTriggerParams]) {
            [self operationFailedBlockWithMsg:@"Read Channel Trigger Params Error" block:failedBlock];
            return;
        }
        if (![self readStayAdvertisingBeforeTriggered]) {
            [self operationFailedBlockWithMsg:@"Read Stay Advertising Before Triggered Error" block:failedBlock];
            return;
        }
//        if (![self readDeviceID]) {
//            [self operationFailedBlockWithMsg:@"Read Device ID Error" block:failedBlock];
//            return;
//        }
        if (self.alarmType == 3) {
            if (![self readAbnormalTime]) {
                [self operationFailedBlockWithMsg:@"Read Abnormal Time Error" block:failedBlock];
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

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self validParams]) {
            [self operationFailedBlockWithMsg:@"Params Error" block:failedBlock];
            return;
        }
        if (![self configTriggerChannelAdvParams]) {
            [self operationFailedBlockWithMsg:@"Config Trigger Channel Adv Params Error" block:failedBlock];
            return;
        }
        if (![self configChannelTriggerParams]) {
            [self operationFailedBlockWithMsg:@"Config Channel Trigger Params Error" block:failedBlock];
            return;
        }
        if (![self configStayAdvertisingBeforeTriggered]) {
            [self operationFailedBlockWithMsg:@"Config Stay Advertising Before Triggered Error" block:failedBlock];
            return;
        }
//        if (![self configDeviceID]) {
//            [self operationFailedBlockWithMsg:@"Config Device ID Error" block:failedBlock];
//            return;
//        }
        if (self.alarmType == 3) {
            if (![self configAbnormalTime]) {
                [self operationFailedBlockWithMsg:@"Config Abnormal Time Error" block:failedBlock];
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

- (BOOL)readAlarmStatus {
    __block BOOL success = NO;
    [MKBXDInterface bxd_readTriggerChannelStateWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.singleIsOn = [returnData[@"result"][@"singlePressMode"] boolValue];
        self.doubleIsOn = [returnData[@"result"][@"doublePressMode"] boolValue];
        self.longIsOn = [returnData[@"result"][@"longPressMode"] boolValue];
        self.inactivityIsOn = [returnData[@"result"][@"abnormalInactivityMode"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readTriggerChannelAdvParams {
    __block BOOL success = NO;
    [MKBXDInterface bxd_readTriggerChannelAdvParams:self.alarmType sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.advIsOn = [returnData[@"result"][@"isOn"] boolValue];
        self.rangingData = [returnData[@"result"][@"rssi"] integerValue];
        self.advInterval = returnData[@"result"][@"advInterval"];
        self.txPower = [self fetchTxPowerValueString:returnData[@"result"][@"txPower"]];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configTriggerChannelAdvParams {
    __block BOOL success = NO;
    MKBXDTriggerChannelAdvParamsModel *paramModel = [[MKBXDTriggerChannelAdvParamsModel alloc] init];
    paramModel.alarmType = self.alarmType;
    paramModel.isOn = self.advIsOn;
    paramModel.rssi = self.rangingData;
    paramModel.advInterval = self.advInterval;
    paramModel.txPower = self.txPower;
    [MKBXDInterface bxd_configTriggerChannelAdvParams:paramModel sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readChannelTriggerParams {
    __block BOOL success = NO;
    [MKBXDInterface bxd_readChannelTriggerParams:self.alarmType sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.alarmMode = [returnData[@"result"][@"alarm"] boolValue];
        self.alarmMode_advTime = returnData[@"result"][@"advTime"];
        self.alarmMode_advInterval = returnData[@"result"][@"advInterval"];
        self.alarmMode_txPower = [self fetchTxPowerValueString:returnData[@"result"][@"txPower"]];
//        self.alarmMode_rssi = [returnData[@"result"][@"rssi"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configChannelTriggerParams {
    __block BOOL success = NO;
    MKBXDChannelTriggerParamsModel *paramModel = [[MKBXDChannelTriggerParamsModel alloc] init];
    paramModel.alarmType = self.alarmType;
    paramModel.alarm = self.alarmMode;
    paramModel.rssi = self.rangingData;
    paramModel.advInterval = self.alarmMode_advInterval;
    paramModel.advertisingTime = self.alarmMode_advTime;
    paramModel.txPower = self.alarmMode_txPower;
    [MKBXDInterface bxd_configChannelTriggerParams:paramModel sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readStayAdvertisingBeforeTriggered {
    __block BOOL success = NO;
    [MKBXDInterface bxd_readStayAdvertisingBeforeTriggered:self.alarmType sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.stayAdv = [returnData[@"result"][@"isOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configStayAdvertisingBeforeTriggered {
    __block BOOL success = NO;
    [MKBXDInterface bxd_configStayAdvertisingBeforeTriggered:self.alarmType isOn:self.stayAdv sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readDeviceID {
    __block BOOL success = NO;
    [MKBXDInterface bxd_readDeviceIDWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.deviceID = returnData[@"result"][@"deviceID"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configDeviceID {
    __block BOOL success = NO;
    [MKBXDInterface bxd_configDeviceID:self.deviceID sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readAbnormalTime {
    __block BOOL success = NO;
    [MKBXDInterface bxd_readAbnormalInactivityTimeWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.abnormalTime = returnData[@"result"][@"time"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configAbnormalTime {
    __block BOOL success = NO;
    [MKBXDInterface bxd_configAbnormalInactivityTime:[self.abnormalTime integerValue] sucBlock:^{
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
        NSError *error = [[NSError alloc] initWithDomain:@"AlarmModeConfigParams"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    })
}

- (NSInteger)fetchTxPowerValueString:(NSString *)content {
    if ([content isEqualToString:@"-40dBm"]) {
        return 0;
    }
    if ([content isEqualToString:@"-20dBm"]) {
        return 1;
    }
    if ([content isEqualToString:@"-16dBm"]) {
        return 2;
    }
    if ([content isEqualToString:@"-12dBm"]) {
        return 3;
    }
    if ([content isEqualToString:@"-8dBm"]) {
        return 4;
    }
    if ([content isEqualToString:@"-4dBm"]) {
        return 5;
    }
    if ([content isEqualToString:@"0dBm"]) {
        return 6;
    }
    if ([content isEqualToString:@"3dBm"]) {
        return 7;
    }
    if ([content isEqualToString:@"4dBm"]) {
        return 8;
    }
    return 0;
}

- (BOOL)validParams {
//    if (!ValidStr(self.deviceID) || (self.deviceID.length % 2 != 0) || self.deviceID.length > 12) {
//        return NO;
//    }
    if (!ValidStr(self.advInterval) || [self.advInterval integerValue] < 1 || [self.advInterval integerValue] > 500) {
        return NO;
    }
    if (!ValidStr(self.alarmMode_advTime) || [self.alarmMode_advTime integerValue] < 1 || [self.alarmMode_advTime integerValue] > 65535) {
        return NO;
    }
    if (!ValidStr(self.alarmMode_advInterval) || [self.alarmMode_advInterval integerValue] < 1 || [self.alarmMode_advInterval integerValue] > 500) {
        return NO;
    }
    if (self.alarmType == 3) {
        if (!ValidStr(self.abnormalTime) || [self.abnormalTime integerValue] < 1 || [self.abnormalTime integerValue] > 65535) {
            return NO;
        }
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
        _readQueue = dispatch_queue_create("AlarmModeConfigQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
