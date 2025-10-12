//
//  MKBXDInterface.h
//  MKBeaconXDButton_Example
//
//  Created by aa on 2022/2/18.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MKBXDSDKNormalDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKBXDInterface : NSObject

#pragma mark ****************************************Device Service Information************************************************

/// Read product model
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_readDeviceModelWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock;

/**
 Reading the production date of device
 
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxd_readProductionDateWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock;

/// Read device firmware information
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_readFirmwareWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;

/// Read device hardware information
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_readHardwareWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;

/// Read device software information
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_readSoftwareWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;

/// Read device manufacturer information
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_readManufacturerWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark - custom

/// Read the mac address of the device.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_readMacAddressWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Read the sampling rate, scale and sensitivity of the 3-axis accelerometer sensor
 
 @{
 @"samplingRate":The 3-axis accelerometer sampling rate is 5 levels in total, 00--1hz，01--10hz，02--25hz，03--50hz，04--100hz
 @"fullScale": The 3-axis accelerometer scale is 4 levels, which are 00--±2g；01--±4g；02--±8g；03--±16g
 @"threshold": Motion threshold.If the Full-scale is ±2g,unit is 1mg.If the Full-scale is ±4g,unit is 2mg.If the Full-scale is ±8g,unit is 4mg.If the Full-scale is ±16g,unit is 12mg.
 }

 @param sucBlock Success callback
 @param failedBlock Failure callback
 */
+ (void)bxd_readThreeAxisDataParamsWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the connectable status of the device.
/*
 @{
 @"connectable":@(YES)
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_readConnectableWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the current connection password of the device.
/*
 @{
 @"password":@"xxxxx"
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_readConnectPasswordWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock;

/// Effective click interval.
/*
 @{
 @"interval":@"6",          //unit:100ms
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_readEffectiveClickIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock;

/// Whether support turn off device by button.(Only for BXP-CR)
/*
 @{
 @"isOn":@(YES)
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_readTurnOffByButtonStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock;

/// Scan response packet.
/*
 @{
 @"isOn":@(YES)
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_readScanResponsePacketWithSucBlock:(void (^)(id returnData))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock;

/// Reset Device by button.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_readResetDeviceByButtonStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                          failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the broadcast enable condition of each channel.
/*
 @{
     @"singlePressMode":@(YES),                      //The state of single press mode.
     @"doublePressMode":@(YES),                      //The state of double press mode.
     @"longPressMode":@(YES),                        //The state of long press mode.
     @"abnormalInactivityMode":@(NO),               //The state of abnormal inactivity mode.
 };
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_readTriggerChannelStateWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the channel broadcast content.
/*
    @{
    @"channelType":@"00",       //@"00":Single  @"01":Double   @"02":Long  @"03":Abnormal Inactivity.
    @"advType":@"0",            //@"0": Alarm Info  @"1":UID  @"2":iBeacon
    @"advContent":@{
 
 }
 }
 advContent: As follows. There is no advContent if the advType is Alarm Info.
 UID
 @"advContent":@{
 @"namespaceID":XXXXXXXX,
 @"instanceID":XXXXXX
}
 
 iBeacon
 @"advContent":@{
 @"uuid":XXXXXXXX,
 @"major":@"1",
 @"minor":@"1",
}
 
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_readChannelAdvContent:(MKBXDChannelAlarmType)channelType
                         sucBlock:(void (^)(id returnData))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the channel broadcast parameters that trigger the alarm function.
/*
 @{
    @"channelType":@"00",           //@"00":Single  @"01":Double   @"02":Long  @"03":Abnormal Inactivity.
     @"isOn":@(YES),                //SLOT advertisement is on.
     @"rssi":@"-90",                //Ranging data
     @"advInterval":@"30",          //Adv Interval
     @"txPower":@"-8dBm",           //Tx Power
 };
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_readTriggerChannelAdvParams:(MKBXDChannelAlarmType)channelType
                               sucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the trigger broadcast parameters of the channel.
/*
 @{
 @"channelType":@"00",           //@"00":Single  @"01":Double   @"02":Long  @"03":Abnormal Inactivity.
     @"alarm":@(YES),           //Whether to enable trigger function.
    @"rssi":@"-90",                //Ranging data
    @"advInterval":@"30",          //Adv Interval
    @"txPower":@"-8dBm",           //Tx Power
     @"advTime":@"55",              //broadcast time after trigger.
 };
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_readChannelTriggerParams:(MKBXDChannelAlarmType)channelType
                            sucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;

/// Stay advertising before triggered.
/*
 @{
 @"channelType":@"00",           //@"00":Single  @"01":Double   @"02":Long  @"03":Abnormal Inactivity.
 @"isOn":@(YES),
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_readStayAdvertisingBeforeTriggered:(MKBXDChannelAlarmType)channelType
                                      sucBlock:(void (^)(id returnData))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock;

/// Alarm notification type.
/*
 @{
 @"channelType":@"00",           //@"00":Single  @"01":Double   @"02":Long  @"03":Abnormal Inactivity.  @"04":Long Connection Mode
    @"alarmNotificationType":@"0"           //0:Silent  1:LED 2:Vibration 3:Buzzer 4:LED+Vibration 5:LED+Buzzer
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_readAlarmNotificationType:(MKBXDChannelAlarmNotifyType)channelType
                             sucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/// Abnormal inactivity time.
/*
 @{
 @"time":time
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_readAbnormalInactivityTimeWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock;

/// Power saving mode.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_readPowerSavingModeWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock;

/// After device keep static for time, it will stop advertising and disable alarm mode to enter into power saving mode until device moves.
/*
 @{
 @"time":time
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_readStaticTriggerTimeWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Trigger LED reminder parameters.
/*
 @{
 @"channelType":@"00",           //@"00":Single  @"01":Double   @"02":Long  @"03":Abnormal Inactivity.
 @"time":@"10",         //x100ms
 @"interval":@"5",      //x100ms
 }
 */
/// @param channelType channelType
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_readAlarmLEDNotiParams:(MKBXDChannelAlarmType)channelType
                          sucBlock:(void (^)(id returnData))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock;

/// Trigger Vibration reminder parameters.(BXP-CR only.)
/*
 @{
 @"channelType":@"00",           //@"00":Single  @"01":Double   @"02":Long  @"03":Abnormal Inactivity.
 @"time":@"10",         //x100ms
 @"interval":@"5",      //x100ms
 }
 */
/// @param channelType channelType
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_readAlarmVibrateNotiParams:(MKBXDChannelAlarmType)channelType
                              sucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/// Buzzer Vibration reminder parameters.
/*
 @{
 @"channelType":@"00",           //@"00":Single  @"01":Double   @"02":Long  @"03":Abnormal Inactivity.
 @"time":@"10",         //x100ms
 @"interval":@"5",      //x100ms
 }
 */
/// @param channelType channelType
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_readAlarmBuzzerNotiParams:(MKBXDChannelAlarmType)channelType
                             sucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/// Remote LED reminder parameters.
/*
 @{
 @"time":@"10",         //x100ms
 @"interval":@"5",      //x100ms
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_readRemoteReminderLEDNotiParamsWithSucBlock:(void (^)(id returnData))sucBlock
                                            failedBlock:(void (^)(NSError *error))failedBlock;

/// Remote Vibration reminder parameters.(BXP-CR only)
/*
 @{
 @"time":@"10",         //x100ms
 @"interval":@"5",      //x100ms
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_readRemoteReminderVibrationNotiParamsWithSucBlock:(void (^)(id returnData))sucBlock
                                                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Remote Buzzer reminder parameters.
/*
 @{
 @"time":@"10",         //x100ms
 @"interval":@"5",      //x100ms
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_readRemoteReminderBuzzerNotiParamsWithSucBlock:(void (^)(id returnData))sucBlock
                                               failedBlock:(void (^)(NSError *error))failedBlock;

/// Dismiss alarm by button.
/*
 @{
 @"isOn":@(YES)
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_readDismissAlarmByButtonWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock;

/// Read LED dismissal alarm parameter.
/*
 @{
 @"time":@"10",         //x100ms
 @"interval":@"5",      //x100ms
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_readDismissAlarmLEDNotiParamsWithSucBlock:(void (^)(id returnData))sucBlock
                                          failedBlock:(void (^)(NSError *error))failedBlock;

/// Read Vibration dismissal alarm parameter.(BXP-CR only)
/*
 @{
 @"time":@"10",         //x100ms
 @"interval":@"5",      //x100ms
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_readDismissAlarmVibrationNotiParamsWithSucBlock:(void (^)(id returnData))sucBlock
                                                failedBlock:(void (^)(NSError *error))failedBlock;

/// Read Buzzer dismissal alarm parameter.
/*
 @{
 @"time":@"10",         //x100ms
 @"interval":@"5",      //x100ms
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_readDismissAlarmBuzzerNotiParamsWithSucBlock:(void (^)(id returnData))sucBlock
                                             failedBlock:(void (^)(NSError *error))failedBlock;

/// Dismiss alarm notification type.
/*
 @{
    @"type":@"0"           //BXP-B-D:  0:Silent  1:LED 2:Buzzer 3:LED+Buzzer
                            //BXP-CR:   0:Silent  1:LED 2:Vibration 3:Buzzer 4:LED+Vibration 5:LED+Buzzer
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_readDismissAlarmNotificationTypeWithSucBlock:(void (^)(id returnData))sucBlock
                                             failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the Voltage of the device.
/*
 @{
 @"voltage":@"3330",        //mV
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_readBatteryVoltageWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the timestamp of the device.(BXP-CR only)
/*
 @{
 @"timestamp":@"1202214545214",        //
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_readDeviceTimestampWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock;

/// Read sensor status.
/*
 @{
     @"threeAxis":@(YES),           //Whether the device has a 3-axis accelerometer.
     @"htSensor":@(YES),            //Whether the device has a temperature and humidity sensor.
     @"lightSensor":@(YES)          //Whether the device has a light sensor.
 };
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_readSensorStatusWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the device' ID.
/*
 @{
 @"deviceID":@"112233"
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_readDeviceIDWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the broadcast name of the device.
/*
 @"deviceName":@"MK Button"
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_readDeviceNameWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the count of the single press event.
/*
 @{
 @"count":@"0"
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_readSinglePressEventCountWithSucBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the count of the double press event.
/*
 @{
 @"count":@"0"
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_readDoublePressEventCountWithSucBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the count of the long press event.
/*
 @{
 @"count":@"0"
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_readLongPressEventCountWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock;

/// Read Device Type.
/*
 @{
 @"deviceType":@"00"
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_readDeviceTypeWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/// Read device's battery percent.
/*
 @{
 @"percent":@"100", //Unit:%
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_readDeviceBatteryPercentWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock;

/// Read device's pcb type.
/*
 @{
 @"type":@"1"
 }
 1:Single button, only for B2
 2:Single button, only for B2
 3:Double button
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_readDevicePCBTypeWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the count of the sub button single press event.
/*
 @{
 @"count":@"0"
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_readSubButtonSinglePressEventCountWithSucBlock:(void (^)(id returnData))sucBlock
                                               failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the count of the sub button double press event.
/*
 @{
 @"count":@"0"
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_readSubButtonDoublePressEventCountWithSucBlock:(void (^)(id returnData))sucBlock
                                               failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the count of the sub button long press event.
/*
 @{
 @"count":@"0"
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_readSubButtonLongPressEventCountWithSucBlock:(void (^)(id returnData))sucBlock
                                             failedBlock:(void (^)(NSError *error))failedBlock;


#pragma mark - password
/// Whether the device has enabled password verification when connecting. When the device has disabled password verification, no password is required to connect to the device, otherwise a connection password is required.
/*
 @{
 @"state":@"00",        //@"00":Without connection password.    @"01":Need connection password.
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_readPasswordVerificationWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
