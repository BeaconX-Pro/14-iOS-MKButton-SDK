//
//  MKBXDInterface+MKBXDConfig.m
//  MKBeaconXDButton_Example
//
//  Created by aa on 2022/2/24.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXDInterface+MKBXDConfig.h"

#import "MKBLEBaseSDKDefines.h"
#import "MKBLEBaseSDKAdopter.h"

#import "MKBXDCentralManager.h"
#import "MKBXDOperationID.h"
#import "MKBXDOperation.h"
#import "CBPeripheral+MKBXDAdd.h"
#import "MKBXDAdopter.h"

#define centralManager [MKBXDCentralManager shared]

@implementation MKBXDInterface (MKBXDConfig)
+ (void)bxd_configThreeAxisDataParams:(mk_bxd_threeAxisDataRate)dataRate
                            fullScale:(mk_bxd_threeAxisDataAG)fullScale
                      motionThreshold:(NSInteger)motionThreshold
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    if (motionThreshold < 1 || motionThreshold > 2048) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *rate = [MKBXDAdopter fetchThreeAxisDataRate:dataRate];
    NSString *ag = [MKBXDAdopter fetchThreeAxisDataAG:fullScale];
    NSString *sen = [MKBLEBaseSDKAdopter fetchHexValue:motionThreshold byteLen:2];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@",@"ea012104",rate,ag,sen];
    [self configDataWithTaskID:mk_bxd_taskConfigThreeAxisDataParamsOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxd_configConnectable:(BOOL)connectable
                     sucBlock:(void (^)(void))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (connectable ? @"ea01220101" : @"ea01220100");
    [self configDataWithTaskID:mk_bxd_taskConfigConnectableOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxd_configConnectPassword:(NSString *)password
                         sucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidStr(password) || password.length > 16) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandData = @"";
    for (NSInteger i = 0; i < password.length; i ++) {
        int asciiCode = [password characterAtIndex:i];
        commandData = [commandData stringByAppendingString:[NSString stringWithFormat:@"%1lx",(unsigned long)asciiCode]];
    }
    NSString *lenString = [NSString stringWithFormat:@"%1lx",(long)password.length];
    if (lenString.length == 1) {
        lenString = [@"0" stringByAppendingString:lenString];
    }
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ea0124",lenString,commandData];
    [self configDataWithTaskID:mk_bxd_taskConfigConnectPasswordOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxd_configEffectiveClickInterval:(NSInteger)interval
                                sucBlock:(void (^)(void))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 5 || interval > 15) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *intervalValue = [MKBLEBaseSDKAdopter fetchHexValue:(interval * 100) byteLen:2];
    NSString *commandString = [@"ea012502" stringByAppendingString:intervalValue];
    [self configDataWithTaskID:mk_bxd_taskConfigEffectiveClickIntervalOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxd_powerOffWithSucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ea012600";
    [self configDataWithTaskID:mk_bxd_taskConfigPowerOffOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxd_factoryResetWithSucBlock:(void (^)(void))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ea012800";
    [self configDataWithTaskID:mk_bxd_taskConfigFactoryResetOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxd_configScanResponsePacket:(BOOL)isOn
                            sucBlock:(void (^)(void))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ea012f0101" : @"ea012f0100");
    [self configDataWithTaskID:mk_bxd_taskConfigScanResponsePacketOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxd_configResetDeviceByButtonStatus:(BOOL)isOn
                                   sucBlock:(void (^)(void))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ea01310101" : @"ea01310100");
    [self configDataWithTaskID:mk_bxd_taskConfigResetDeviceByButtonStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxd_configChannelContentAlarmInfo:(MKBXDChannelAlarmType)channelType
                                 sucBlock:(void (^)(void))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ea013302",[MKBLEBaseSDKAdopter fetchHexValue:channelType byteLen:1],@"00"];
    [self configDataWithTaskID:mk_bxd_taskConfigChannelContentOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxd_configChannelContentUID:(MKBXDChannelAlarmType)channelType
                        namespaceID:(NSString *)namespaceID
                         instanceID:(NSString *)instanceID
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    if (namespaceID.length != 20 || ![MKBLEBaseSDKAdopter checkHexCharacter:namespaceID]
        || instanceID.length != 12 || ![MKBLEBaseSDKAdopter checkHexCharacter:instanceID]) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@%@",@"ea013312",[MKBLEBaseSDKAdopter fetchHexValue:channelType byteLen:1],@"01",namespaceID,instanceID];
    [self configDataWithTaskID:mk_bxd_taskConfigChannelContentOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxd_configChannelContentBeacon:(MKBXDChannelAlarmType)channelType
                                 major:(NSInteger)major
                                 minor:(NSInteger)minor
                                  uuid:(NSString *)uuid
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    if (major < 0 || major > 65535
        || minor < 0 || minor > 65535 || !MKValidStr(uuid) || uuid.length != 32
        || ![MKBLEBaseSDKAdopter checkHexCharacter:uuid]) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@%@%@",@"ea013316",[MKBLEBaseSDKAdopter fetchHexValue:channelType byteLen:1],@"02",uuid,[MKBLEBaseSDKAdopter fetchHexValue:major byteLen:2],[MKBLEBaseSDKAdopter fetchHexValue:minor byteLen:2]];
    [self configDataWithTaskID:mk_bxd_taskConfigChannelContentOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxd_configTriggerChannelAdvParams:(id <MKBXDTriggerChannelAdvParamsProtocol>)protocol
                                 sucBlock:(void (^)(void))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    if (![MKBXDAdopter validTriggerChannelAdvParamsProtocol:protocol]) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandString = [MKBXDAdopter parseTriggerChannelAdvParamsProtocol:protocol];
    [self configDataWithTaskID:mk_bxd_taskConfigTriggerChannelAdvParamsOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxd_configChannelTriggerParams:(id <MKBXDChannelTriggerParamsProtocol>)protocol
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    if (![MKBXDAdopter validChannelTriggerParamsProtocol:protocol]) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandString = [MKBXDAdopter parseChannelTriggerParamsProtocol:protocol];
    [self configDataWithTaskID:mk_bxd_taskConfigChannelTriggerParamsOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxd_configStayAdvertisingBeforeTriggered:(MKBXDChannelAlarmType)channelType
                                            isOn:(BOOL)isOn
                                        sucBlock:(void (^)(void))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *type = [MKBLEBaseSDKAdopter fetchHexValue:channelType byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ea013602",type,(isOn ? @"01" : @"00")];
    [self configDataWithTaskID:mk_bxd_taskConfigStayAdvertisingBeforeTriggeredOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxd_configAlarmNotificationType:(MKBXDChannelAlarmNotifyType)channelType
                           reminderType:(mk_bxd_reminderType)reminderType
                               sucBlock:(void (^)(void))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *channleType = [MKBLEBaseSDKAdopter fetchHexValue:channelType byteLen:1];
    NSString *typeString = [MKBXDAdopter fetchReminderTypeString:reminderType];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ea013702",channleType,typeString];
    [self configDataWithTaskID:mk_bxd_taskConfigAlarmNotificationTypeOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxd_configAbnormalInactivityTime:(NSInteger)time
                                sucBlock:(void (^)(void))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    if (time < 1 || time > 65535) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *timeString = [MKBLEBaseSDKAdopter fetchHexValue:time byteLen:2];
    NSString *commandString = [@"ea013802" stringByAppendingString:timeString];
    [self configDataWithTaskID:mk_bxd_taskConfigAbnormalInactivityTimeOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxd_configPowerSavingMode:(BOOL)isOn
                         sucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ea01390101" : @"ea01390100");
    [self configDataWithTaskID:mk_bxd_taskConfigPowerSavingModeOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxd_configStaticTriggerTime:(NSInteger)time
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    if (time < 1 || time > 65535) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *timeString = [MKBLEBaseSDKAdopter fetchHexValue:time byteLen:2];
    NSString *commandString = [@"ea013a02" stringByAppendingString:timeString];
    [self configDataWithTaskID:mk_bxd_taskConfigStaticTriggerTimeOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxd_configAlarmLEDNotiParams:(MKBXDChannelAlarmType)channelType
                        blinkingTime:(NSInteger)blinkingTime
                    blinkingInterval:(NSInteger)blinkingInterval
                            sucBlock:(void (^)(void))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    if (blinkingTime < 1 || blinkingTime > 6000 || blinkingInterval < 0 || blinkingInterval > 100) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *channleType = [MKBLEBaseSDKAdopter fetchHexValue:channelType byteLen:1];
    NSString *time = [MKBLEBaseSDKAdopter fetchHexValue:blinkingTime byteLen:2];
    NSString *interval = [MKBLEBaseSDKAdopter fetchHexValue:blinkingInterval byteLen:2];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@",@"ea013b05",channleType,time,interval];
    [self configDataWithTaskID:mk_bxd_taskConfigAlarmLEDNotiParamsOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxd_configAlarmBuzzerNotiParams:(MKBXDChannelAlarmType)channelType
                            ringingTime:(NSInteger)ringingTime
                        ringingInterval:(NSInteger)ringingInterval
                               sucBlock:(void (^)(void))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    if (ringingTime < 1 || ringingTime > 6000 || ringingInterval < 0 || ringingInterval > 100) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *channleType = [MKBLEBaseSDKAdopter fetchHexValue:channelType byteLen:1];
    NSString *time = [MKBLEBaseSDKAdopter fetchHexValue:ringingTime byteLen:2];
    NSString *interval = [MKBLEBaseSDKAdopter fetchHexValue:ringingInterval byteLen:2];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@",@"ea013d05",channleType,time,interval];
    [self configDataWithTaskID:mk_bxd_taskConfigAlarmBuzzerNotiParamsOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxd_configRemoteReminderLEDNotiParams:(NSInteger)blinkingTime
                             blinkingInterval:(NSInteger)blinkingInterval
                                     sucBlock:(void (^)(void))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    if (blinkingTime < 1 || blinkingTime > 6000 || blinkingInterval < 0 || blinkingInterval > 100) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *time = [MKBLEBaseSDKAdopter fetchHexValue:blinkingTime byteLen:2];
    NSString *interval = [MKBLEBaseSDKAdopter fetchHexValue:blinkingInterval byteLen:2];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ea013e04",time,interval];
    [self configDataWithTaskID:mk_bxd_taskConfigRemoteReminderLEDNotiParamsOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxd_configRemoteReminderBuzzerNotiParams:(NSInteger)ringingTime
                                 ringingInterval:(NSInteger)ringingInterval
                                        sucBlock:(void (^)(void))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    if (ringingTime < 1 || ringingTime > 6000 || ringingInterval < 0 || ringingInterval > 100) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *time = [MKBLEBaseSDKAdopter fetchHexValue:ringingTime byteLen:2];
    NSString *interval = [MKBLEBaseSDKAdopter fetchHexValue:ringingInterval byteLen:2];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ea014004",time,interval];
    [self configDataWithTaskID:mk_bxd_taskConfigRemoteReminderBuzzerNotiParamsOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxd_configDismissAlarmWithSucBlock:(void (^)(void))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ea014100";
    [self configDataWithTaskID:mk_bxd_taskConfigDismissAlarmOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxd_configDismissAlarmByButton:(BOOL)isOn
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ea01420101" : @"ea01420100");
    [self configDataWithTaskID:mk_bxd_taskConfigDismissAlarmByButtonOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxd_configDismissAlarmLEDNotiParams:(NSInteger)time
                                   interval:(NSInteger)interval
                                   sucBlock:(void (^)(void))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    if (time < 1 || time > 6000 || interval < 0 || interval > 100) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *timeValue = [MKBLEBaseSDKAdopter fetchHexValue:time byteLen:2];
    NSString *intervalValue = [MKBLEBaseSDKAdopter fetchHexValue:interval byteLen:2];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ea014304",timeValue,intervalValue];
    [self configDataWithTaskID:mk_bxd_taskConfigDismissAlarmLEDNotiParamsOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxd_configDismissAlarmBuzzerNotiParams:(NSInteger)time
                                      interval:(NSInteger)interval
                                      sucBlock:(void (^)(void))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock {
    if (time < 1 || time > 6000 || interval < 0 || interval > 100) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *timeValue = [MKBLEBaseSDKAdopter fetchHexValue:time byteLen:2];
    NSString *intervalValue = [MKBLEBaseSDKAdopter fetchHexValue:interval byteLen:2];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ea014504",timeValue,intervalValue];
    [self configDataWithTaskID:mk_bxd_taskConfigDismissAlarmBuzzerNotiParamsOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxd_configDismissAlarmNotificationType:(mk_bxd_reminderType)type
                                      sucBlock:(void (^)(void))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *typeString = [MKBXDAdopter fetchReminderTypeString:type];
    NSString *commandString = [@"ea014601" stringByAppendingString:typeString];
    [self configDataWithTaskID:mk_bxd_taskConfigDismissAlarmNotificationTypeOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxd_clearSinglePressEventDataWithSucBlock:(void (^)(void))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ea014700";
    [self configDataWithTaskID:mk_bxd_taskClearSinglePressEventDataOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxd_clearDoublePressEventDataWithSucBlock:(void (^)(void))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ea014800";
    [self configDataWithTaskID:mk_bxd_taskClearDoublePressEventDataOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxd_clearLongPressEventDataWithSucBlock:(void (^)(void))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ea014900";
    [self configDataWithTaskID:mk_bxd_taskClearLongPressEventDataOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxd_configDeviceID:(NSString *)deviceID
                  sucBlock:(void (^)(void))sucBlock
               failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidStr(deviceID) || deviceID.length > 12 || ![MKBLEBaseSDKAdopter checkHexCharacter:deviceID]) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *len = [MKBLEBaseSDKAdopter fetchHexValue:(deviceID.length / 2) byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ea0150",len,deviceID];
    [self configDataWithTaskID:mk_bxd_taskConfigDeviceIDOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxd_configDeviceName:(NSString *)deviceName
                    sucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidStr(deviceName) || deviceName.length > 10) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *tempString = @"";
    for (NSInteger i = 0; i < deviceName.length; i ++) {
        int asciiCode = [deviceName characterAtIndex:i];
        tempString = [tempString stringByAppendingString:[NSString stringWithFormat:@"%1lx",(unsigned long)asciiCode]];
    }
    NSString *lenString = [NSString stringWithFormat:@"%1lx",(long)deviceName.length];
    if (lenString.length == 1) {
        lenString = [@"0" stringByAppendingString:lenString];
    }
    NSString *commandString = [NSString stringWithFormat:@"ea0151%@%@",lenString,tempString];
    [self configDataWithTaskID:mk_bxd_taskConfigDeviceNameOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxd_batteryResetWithSucBlock:(void (^)(void))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ea015d00";
    [self configDataWithTaskID:mk_bxd_taskBatteryResetOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

#pragma mark - password
+ (void)bxd_configPasswordVerification:(BOOL)isOn
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ea01230101" : @"ea01230100");
    
    [centralManager addTaskWithTaskID:mk_bxd_taskConfigPasswordVerificationOperation characteristic:centralManager.peripheral.bxd_password commandData:commandString successBlock:^(id  _Nonnull returnData) {
        BOOL success = [returnData[@"result"][@"success"] boolValue];
        if (!success) {
            [MKBLEBaseSDKAdopter operationSetParamsErrorBlock:failedBlock];
            return ;
        }
        if (sucBlock) {
            sucBlock();
        }
    } failureBlock:failedBlock];
}

#pragma mark - private method
+ (void)configDataWithTaskID:(mk_bxd_taskOperationID)taskID
                        data:(NSString *)data
                    sucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:taskID characteristic:centralManager.peripheral.bxd_custom commandData:data successBlock:^(id  _Nonnull returnData) {
        BOOL success = [returnData[@"result"][@"success"] boolValue];
        if (!success) {
            [MKBLEBaseSDKAdopter operationSetParamsErrorBlock:failedBlock];
            return ;
        }
        if (sucBlock) {
            sucBlock();
        }
    } failureBlock:failedBlock];
}

@end
