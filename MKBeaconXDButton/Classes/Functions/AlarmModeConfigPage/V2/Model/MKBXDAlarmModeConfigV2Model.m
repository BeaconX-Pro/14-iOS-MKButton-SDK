//
//  MKBXDAlarmModeConfigV2Model.m
//  MKBeaconXDButton_Example
//
//  Created by aa on 2024/11/25.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "MKBXDAlarmModeConfigV2Model.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKBXDConnectManager.h"

#import "MKBXDInterface.h"
#import "MKBXDInterface+MKBXDConfig.h"

#import "MKBXDAlarmModeParamsModel.h"

@interface MKBXDAlarmModeConfigV2Model ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKBXDAlarmModeConfigV2Model

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
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
        if (![self readContentData]) {
            [self operationFailedBlockWithMsg:@"Read Content Data Error" block:failedBlock];
            return;
        }
        if (self.alarmType == 3) {
            if (![self readAbnormalTime]) {
                [self operationFailedBlockWithMsg:@"Read Abnormal Time Error" block:failedBlock];
                return;
            }
        }
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
        
        if (self.slotType == bxd_slotType_alarmInfo) {
            if (![self configAlarmInfo]) {
                [self operationFailedBlockWithMsg:@"Config Content Data Error" block:failedBlock];
                return;
            }
        }else if (self.slotType == bxd_slotType_uid) {
            if (![self configUID]) {
                [self operationFailedBlockWithMsg:@"Config Content Data Error" block:failedBlock];
                return;
            }
        }else if (self.slotType == bxd_slotType_beacon) {
            if (![self configBeacon]) {
                [self operationFailedBlockWithMsg:@"Config Content Data Error" block:failedBlock];
                return;
            }
        }
        
        if (self.alarmType == 3) {
            if (![self configAbnormalTime]) {
                [self operationFailedBlockWithMsg:@"Config Abnormal Time Error" block:failedBlock];
                return;
            }
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

- (BOOL)readContentData {
    __block BOOL success = NO;
    [MKBXDInterface bxd_readChannelAdvContent:self.alarmType sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        [self updateContentData:returnData[@"result"]];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configAlarmInfo {
    __block BOOL success = NO;
    [MKBXDInterface bxd_configChannelContentAlarmInfo:self.alarmType sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configUID {
    __block BOOL success = NO;
    [MKBXDInterface bxd_configChannelContentUID:self.alarmType namespaceID:self.namespaceID instanceID:self.instanceID sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configBeacon {
    __block BOOL success = NO;
    [MKBXDInterface bxd_configChannelContentBeacon:self.alarmType major:[self.major integerValue] minor:[self.minor integerValue] uuid:self.uuid sucBlock:^{
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

- (BOOL)readAlarmType {
    __block BOOL success = NO;
    [MKBXDInterface bxd_readAlarmNotificationType:self.alarmType sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        NSInteger type = [returnData[@"result"][@"alarmNotificationType"] integerValue];
        if ([MKBXDConnectManager shared].isCR) {
            self.alarmNotiType = type;
        }else {
            if (type == 0) {
                self.alarmNotiType = 0;
            }else if (type == 1) {
                self.alarmNotiType = 1;
            }else if (type == 3) {
                self.alarmNotiType = 2;
            }else if (type == 5) {
                self.alarmNotiType = 3;
            }
        }
        
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configAlarmType {
    __block BOOL success = NO;
    mk_bxd_reminderType reminderType = mk_bxd_reminderType_silent;
    if ([MKBXDConnectManager shared].isCR) {
        reminderType = self.alarmNotiType;
    }else {
        if (self.alarmNotiType == 1) {
            reminderType = mk_bxd_reminderType_led;
        }else if (self.alarmNotiType == 2) {
            reminderType = mk_bxd_reminderType_buzzer;
        }else if (self.alarmNotiType == 3) {
            reminderType = mk_bxd_reminderType_ledAndBuzzer;
        }
    }
    [MKBXDInterface bxd_configAlarmNotificationType:self.alarmType reminderType:reminderType sucBlock:^{
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

- (void)updateContentData:(NSDictionary *)dic {
    self.slotType = [dic[@"advType"] integerValue];
    if (self.slotType == bxd_slotType_alarmInfo) {
        return;
    }
    if (self.slotType == bxd_slotType_uid) {
        self.namespaceID = dic[@"advContent"][@"namespaceID"];
        self.instanceID = dic[@"advContent"][@"instanceID"];
        return;
    }
    if (self.slotType == bxd_slotType_beacon) {
        self.uuid = dic[@"advContent"][@"uuid"];
        self.major = dic[@"advContent"][@"major"];
        self.minor = dic[@"advContent"][@"minor"];
        return;
    }
}

- (BOOL)validParams {
//    if (!ValidStr(self.deviceID) || (self.deviceID.length % 2 != 0) || self.deviceID.length > 12) {
//        return NO;
//    }
    if (self.slotType == bxd_slotType_uid) {
        if (!ValidStr(self.namespaceID) || self.namespaceID.length != 20 || !ValidStr(self.instanceID) || self.instanceID.length != 12) {
            return NO;
        }
    }else if (self.slotType == bxd_slotType_beacon) {
        if (!ValidStr(self.major) || ![self.major integerValue] < 0 || [self.major integerValue] > 65535) {
            return NO;
        }
        if (!ValidStr(self.minor) || ![self.minor integerValue] < 0 || [self.minor integerValue] > 65535) {
            return NO;
        }
        if (!ValidStr(self.uuid) || self.uuid.length != 32) {
            return NO;
        }
    }
    
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
    if (self.alarmNotiType > 0) {
        if (![self validTriggerNotiParams]) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)validTriggerNotiParams {
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
        _readQueue = dispatch_queue_create("AlarmModeConfigQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
