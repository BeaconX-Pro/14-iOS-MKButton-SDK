//
//  MKBXDInterface.m
//  MKBeaconXDButton_Example
//
//  Created by aa on 2022/2/18.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXDInterface.h"

#import "MKBXDBaseSDKAdopter.h"

#import "MKBXDCentralManager.h"
#import "MKBXDOperationID.h"
#import "MKBXDOperation.h"
#import "CBPeripheral+MKBXDAdd.h"

#define centralManager [MKBXDCentralManager shared]
#define peripheral ([MKBXDCentralManager shared].peripheral)

@implementation MKBXDInterface

#pragma mark ****************************************Device Service Information************************************************

+ (void)bxd_readDeviceModelWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    if (!peripheral.bxd_deviceModel) {
        //新版本自定义
        [self readDataWithTaskID:mk_bxd_taskReadDeviceModelOperation
                         cmdFlag:@"2e"
                        sucBlock:sucBlock
                     failedBlock:failedBlock];
        return;
    }
    [centralManager addReadTaskWithTaskID:mk_bxd_taskReadDeviceModelOperation
                           characteristic:peripheral.bxd_deviceModel
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)bxd_readProductionDateWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    if (!peripheral.bxd_productionDate) {
        //新版本自定义
        [self readDataWithTaskID:mk_bxd_taskReadProductionDateOperation
                         cmdFlag:@"5a"
                        sucBlock:sucBlock
                     failedBlock:failedBlock];
        return;
    }
    [centralManager addReadTaskWithTaskID:mk_bxd_taskReadProductionDateOperation
                           characteristic:peripheral.bxd_productionDate
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)bxd_readFirmwareWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    if (!peripheral.bxd_firmware) {
        //新版本自定义
        [self readDataWithTaskID:mk_bxd_taskReadFirmwareOperation
                         cmdFlag:@"2b"
                        sucBlock:sucBlock
                     failedBlock:failedBlock];
        return;
    }
    [centralManager addReadTaskWithTaskID:mk_bxd_taskReadFirmwareOperation
                           characteristic:peripheral.bxd_firmware
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)bxd_readHardwareWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    if (!peripheral.bxd_hardware) {
        //新版本自定义
        [self readDataWithTaskID:mk_bxd_taskReadHardwareOperation
                         cmdFlag:@"2d"
                        sucBlock:sucBlock
                     failedBlock:failedBlock];
        return;
    }
    [centralManager addReadTaskWithTaskID:mk_bxd_taskReadHardwareOperation
                           characteristic:peripheral.bxd_hardware
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)bxd_readSoftwareWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    if (!peripheral.bxd_software) {
        //新版本自定义
        [self readDataWithTaskID:mk_bxd_taskReadSoftwareOperation
                         cmdFlag:@"2c"
                        sucBlock:sucBlock
                     failedBlock:failedBlock];
        return;
    }
    [centralManager addReadTaskWithTaskID:mk_bxd_taskReadSoftwareOperation
                           characteristic:peripheral.bxd_software
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)bxd_readManufacturerWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    if (!peripheral.bxd_manufacturer) {
        //新版本自定义
        [self readDataWithTaskID:mk_bxd_taskReadManufacturerOperation
                         cmdFlag:@"2a"
                        sucBlock:sucBlock
                     failedBlock:failedBlock];
        return;
    }
    [centralManager addReadTaskWithTaskID:mk_bxd_taskReadManufacturerOperation
                           characteristic:peripheral.bxd_manufacturer
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

#pragma mark - custom
+ (void)bxd_readMacAddressWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxd_taskReadMacAddressOperation
                     cmdFlag:@"20"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxd_readThreeAxisDataParamsWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxd_taskReadThreeAxisDataParamsOperation
                     cmdFlag:@"21"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxd_readConnectableWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxd_taskReadConnectableOperation
                     cmdFlag:@"22"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxd_readConnectPasswordWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxd_taskReadConnectPasswordOperation
                     cmdFlag:@"24"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxd_readEffectiveClickIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxd_taskReadEffectiveClickIntervalOperation
                     cmdFlag:@"25"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxd_readScanResponsePacketWithSucBlock:(void (^)(id returnData))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxd_taskReadScanResponsePacketOperation
                     cmdFlag:@"2f"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxd_readResetDeviceByButtonStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                          failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxd_taskReadResetDeviceByButtonStatusOperation
                     cmdFlag:@"31"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxd_readTriggerChannelStateWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxd_taskReadTriggerChannelStateOperation
                     cmdFlag:@"32"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxd_readChannelAdvContent:(MKBXDChannelAlarmType)channelType
                         sucBlock:(void (^)(id returnData))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *type = [MKBXDBaseSDKAdopter fetchHexValue:channelType byteLen:1];
    NSString *commandString = [@"ea003301" stringByAppendingString:type];
    [centralManager addTaskWithTaskID:mk_bxd_taskReadChannelAdvContentOperation
                       characteristic:peripheral.bxd_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)bxd_readTriggerChannelAdvParams:(MKBXDChannelAlarmType)channelType
                               sucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *type = [MKBXDBaseSDKAdopter fetchHexValue:channelType byteLen:1];
    NSString *commandString = [@"ea003401" stringByAppendingString:type];
    [centralManager addTaskWithTaskID:mk_bxd_taskReadTriggerChannelAdvParamsOperation
                       characteristic:peripheral.bxd_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)bxd_readChannelTriggerParams:(MKBXDChannelAlarmType)channelType
                            sucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *type = [MKBXDBaseSDKAdopter fetchHexValue:channelType byteLen:1];
    NSString *commandString = [@"ea003501" stringByAppendingString:type];
    [centralManager addTaskWithTaskID:mk_bxd_taskReadChannelTriggerParamsOperation
                       characteristic:peripheral.bxd_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)bxd_readStayAdvertisingBeforeTriggered:(MKBXDChannelAlarmType)channelType
                                      sucBlock:(void (^)(id returnData))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *type = [MKBXDBaseSDKAdopter fetchHexValue:channelType byteLen:1];
    NSString *commandString = [@"ea003601" stringByAppendingString:type];
    [centralManager addTaskWithTaskID:mk_bxd_taskReadStayAdvertisingBeforeTriggeredOperation
                       characteristic:peripheral.bxd_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)bxd_readAlarmNotificationType:(MKBXDChannelAlarmNotifyType)channelType
                             sucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *type = [MKBXDBaseSDKAdopter fetchHexValue:channelType byteLen:1];
    NSString *commandString = [@"ea003701" stringByAppendingString:type];
    [centralManager addTaskWithTaskID:mk_bxd_taskReadAlarmNotificationTypeOperation
                       characteristic:peripheral.bxd_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)bxd_readAbnormalInactivityTimeWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxd_taskReadAbnormalInactivityTimeOperation
                     cmdFlag:@"38"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxd_readPowerSavingModeWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxd_taskReadPowerSavingModeOperation
                     cmdFlag:@"39"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxd_readStaticTriggerTimeWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxd_taskReadStaticTriggerTimeOperation
                     cmdFlag:@"3a"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxd_readAlarmLEDNotiParams:(MKBXDChannelAlarmType)channelType
                          sucBlock:(void (^)(id returnData))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *type = [MKBXDBaseSDKAdopter fetchHexValue:channelType byteLen:1];
    NSString *commandString = [@"ea003b01" stringByAppendingString:type];
    [centralManager addTaskWithTaskID:mk_bxd_taskReadAlarmLEDNotiParamsOperation
                       characteristic:peripheral.bxd_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)bxd_readAlarmVibrateNotiParams:(MKBXDChannelAlarmType)channelType
                              sucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *type = [MKBXDBaseSDKAdopter fetchHexValue:channelType byteLen:1];
    NSString *commandString = [@"ea003c01" stringByAppendingString:type];
    [centralManager addTaskWithTaskID:mk_bxd_taskReadAlarmVibrateNotiParamsOperation
                       characteristic:peripheral.bxd_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)bxd_readAlarmBuzzerNotiParams:(MKBXDChannelAlarmType)channelType
                             sucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *type = [MKBXDBaseSDKAdopter fetchHexValue:channelType byteLen:1];
    NSString *commandString = [@"ea003d01" stringByAppendingString:type];
    [centralManager addTaskWithTaskID:mk_bxd_taskReadAlarmBuzzerNotiParamsOperation
                       characteristic:peripheral.bxd_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)bxd_readRemoteReminderLEDNotiParamsWithSucBlock:(void (^)(id returnData))sucBlock
                                            failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxd_taskReadRemoteReminderLEDNotiParamsOperation
                     cmdFlag:@"3e"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxd_readRemoteReminderVibrationNotiParamsWithSucBlock:(void (^)(id returnData))sucBlock
                                                  failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxd_taskReadRemoteReminderVibrationNotiParamsOperation
                     cmdFlag:@"3f"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxd_readRemoteReminderBuzzerNotiParamsWithSucBlock:(void (^)(id returnData))sucBlock
                                               failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxd_taskReadRemoteReminderBuzzerNotiParamsOperation
                     cmdFlag:@"40"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxd_readDismissAlarmByButtonWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxd_taskReadDismissAlarmByButtonOperation
                     cmdFlag:@"42"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxd_readDismissAlarmLEDNotiParamsWithSucBlock:(void (^)(id returnData))sucBlock
                                          failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxd_taskReadDismissAlarmLEDNotiParamsOperation
                     cmdFlag:@"43"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxd_readDismissAlarmVibrationNotiParamsWithSucBlock:(void (^)(id returnData))sucBlock
                                                failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxd_taskReadDismissAlarmVibrationNotiParamsOperation
                     cmdFlag:@"44"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxd_readDismissAlarmBuzzerNotiParamsWithSucBlock:(void (^)(id returnData))sucBlock
                                             failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxd_taskReadDismissAlarmBuzzerNotiParamsOperation
                     cmdFlag:@"45"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxd_readDismissAlarmNotificationTypeWithSucBlock:(void (^)(id returnData))sucBlock
                                             failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxd_taskReadDismissAlarmNotificationTypeOperation
                     cmdFlag:@"46"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxd_readBatteryVoltageWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxd_taskReadBatteryVoltageOperation
                     cmdFlag:@"4a"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxd_readDeviceTimestampWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxd_taskReadDeviceTimestampOperation
                     cmdFlag:@"4b"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxd_readSensorStatusWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxd_taskReadSensorStatusOperation
                     cmdFlag:@"4f"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxd_readDeviceIDWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxd_taskReadDeviceIDOperation
                     cmdFlag:@"50"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxd_readDeviceNameWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxd_taskReadDeviceNameOperation
                     cmdFlag:@"51"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxd_readSinglePressEventCountWithSucBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxd_taskReadSinglePressEventCountOperation
                     cmdFlag:@"52"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxd_readDoublePressEventCountWithSucBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxd_taskReadDoublePressEventCountOperation
                     cmdFlag:@"53"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxd_readLongPressEventCountWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxd_taskReadLongPressEventCountOperation
                     cmdFlag:@"54"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxd_readDeviceTypeWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxd_taskReadDeviceTypeOperation
                     cmdFlag:@"57"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxd_readDeviceBatteryPercentWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxd_taskReadDeviceBatteryPercentOperation
                     cmdFlag:@"62"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

#pragma mark - password
+ (void)bxd_readPasswordVerificationWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ea002300";
    [centralManager addTaskWithTaskID:mk_bxd_taskReadNeedPasswordOperation
                       characteristic:peripheral.bxd_password
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

#pragma mark - private method
+ (void)readDataWithTaskID:(mk_bxd_taskOperationID)taskID
                   cmdFlag:(NSString *)flag
                  sucBlock:(void (^)(id returnData))sucBlock
               failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ea00",flag,@"00"];
    [centralManager addTaskWithTaskID:taskID
                       characteristic:peripheral.bxd_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

@end
