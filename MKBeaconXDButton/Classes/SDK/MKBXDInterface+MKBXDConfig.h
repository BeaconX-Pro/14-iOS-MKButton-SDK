//
//  MKBXDInterface+MKBXDConfig.h
//  MKBeaconXDButton_Example
//
//  Created by aa on 2022/2/24.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXDInterface.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKBXDInterface (MKBXDConfig)

/**
 Setting the sampling rate, scale and sensitivity of the 3-axis accelerometer sensor

 @param dataRate sampling rate
 @param fullScale scale
 @param motionThreshold 1~2048.(fullScale==mk_bxd_threeAxisDataAG0--->x1mg)(fullScale==mk_bxd_threeAxisDataAG1--->x2mg)(fullScale==mk_bxd_threeAxisDataAG2--->x4mg)(fullScale==mk_bxd_threeAxisDataAG3--->x12mg)
 @param sucBlock Success callback
 @param failedBlock Failure callback
 */
+ (void)bxd_configThreeAxisDataParams:(mk_bxd_threeAxisDataRate)dataRate
                            fullScale:(mk_bxd_threeAxisDataAG)fullScale
                      motionThreshold:(NSInteger)motionThreshold
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the connectable state of the device.
/// @param connectable connectable
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_configConnectable:(BOOL)connectable
                     sucBlock:(void (^)(void))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the current connection password of the device.
/// @param password 1~16 ascii characters.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_configConnectPassword:(NSString *)password
                         sucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock;

/// Effective click interval.
/// @param interval 5~15.(unit:100ms)
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_configEffectiveClickInterval:(NSInteger)interval
                                sucBlock:(void (^)(void))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;

/// Power Off.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_powerOffWithSucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock;

/// Reset.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_factoryResetWithSucBlock:(void (^)(void))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;

/// Scan response packet.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_configScanResponsePacket:(BOOL)isOn
                            sucBlock:(void (^)(void))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;

/// Reset Device by button.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_configResetDeviceByButtonStatus:(BOOL)isOn
                                   sucBlock:(void (^)(void))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the channel broadcast content as alarm info.
/// @param channelType channelType
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_configChannelContentAlarmInfo:(MKBXDChannelAlarmType)channelType
                                 sucBlock:(void (^)(void))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the channel broadcast content as UID.
/// @param channelType channelType
/// @param namespaceID 10 Bytes.
/// @param instanceID 6 Bytes.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_configChannelContentUID:(MKBXDChannelAlarmType)channelType
                        namespaceID:(NSString *)namespaceID
                         instanceID:(NSString *)instanceID
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the channel broadcast content as iBeacon.
/// @param channelType channelType
/// @param major 0~65535
/// @param minor 0~65535
/// @param uuid 16 Bytes.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_configChannelContentBeacon:(MKBXDChannelAlarmType)channelType
                                 major:(NSInteger)major
                                 minor:(NSInteger)minor
                                  uuid:(NSString *)uuid
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the channel broadcast parameters that trigger the alarm function.
/// @param protocol protocol
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_configTriggerChannelAdvParams:(id <MKBXDTriggerChannelAdvParamsProtocol>)protocol
                                 sucBlock:(void (^)(void))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the trigger broadcast parameters of the channel.
/// @param protocol protocol
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_configChannelTriggerParams:(id <MKBXDChannelTriggerParamsProtocol>)protocol
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/// Stay advertising before triggered.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_configStayAdvertisingBeforeTriggered:(MKBXDChannelAlarmType)channelType
                                            isOn:(BOOL)isOn
                                        sucBlock:(void (^)(void))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock;

/// Alarm notification type.
/// @param channelType  channelType
/// @param reminderType reminderType
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_configAlarmNotificationType:(MKBXDChannelAlarmNotifyType)channelType
                           reminderType:(mk_bxd_reminderType)reminderType
                               sucBlock:(void (^)(void))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock;

/// Abnormal inactivity time.
/// @param time 1s~65535s.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_configAbnormalInactivityTime:(NSInteger)time
                                sucBlock:(void (^)(void))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;

/// Power saving mode.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_configPowerSavingMode:(BOOL)isOn
                         sucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock;

/// After device keep static for time, it will stop advertising and disable alarm mode to enter into power saving mode until device moves.
/// @param time 1s~65535s
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_configStaticTriggerTime:(NSInteger)time
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;

/// Trigger LED reminder parameters.
/// @param channelType channelType
/// @param blinkingTime Blinking time.1 ~ 6000(Unit:100ms)
/// @param blinkingInterval Blinking interval.0 ~ 100(Unit:100ms)
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_configAlarmLEDNotiParams:(MKBXDChannelAlarmType)channelType
                        blinkingTime:(NSInteger)blinkingTime
                    blinkingInterval:(NSInteger)blinkingInterval
                            sucBlock:(void (^)(void))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;

/// Trigger Vibrate reminder parameters.
/// @param channelType channelType
/// @param vibratingTime Blinking time.1 ~ 6000(Unit:100ms)
/// @param vibratingInterval Blinking interval.0 ~ 100(Unit:100ms)
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_configAlarmVibrateNotiParams:(MKBXDChannelAlarmType)channelType
                           vibratingTime:(NSInteger)vibratingTime
                       vibratingInterval:(NSInteger)vibratingInterval
                                sucBlock:(void (^)(void))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;

/// Trigger Buzzer reminder parameters.
/// @param channelType channelType
/// @param ringingTime Ringing time.1 ~ 6000(Unit:100ms)
/// @param ringingInterval Ringing interval.0 ~ 100(Unit:100ms)
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_configAlarmBuzzerNotiParams:(MKBXDChannelAlarmType)channelType
                            ringingTime:(NSInteger)ringingTime
                        ringingInterval:(NSInteger)ringingInterval
                               sucBlock:(void (^)(void))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock;

/// Remote LED reminder parameters.
/// @param blinkingTime Blinking time.1 ~ 6000(Unit:100ms)
/// @param blinkingInterval Blinking interval.0 ~ 100(Unit:100ms)
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_configRemoteReminderLEDNotiParams:(NSInteger)blinkingTime
                             blinkingInterval:(NSInteger)blinkingInterval
                                     sucBlock:(void (^)(void))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Remote Vibration reminder parameters.(BXP-CR only)
/// @param vibratingTime Vibrating time.1 ~ 6000(Unit:100ms)
/// @param vibraingInterval Vibrating interval.0 ~ 100(Unit:100ms)
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_configRemoteReminderVibrationNotiParams:(NSInteger)vibratingTime
                                   vibraingInterval:(NSInteger)vibraingInterval
                                           sucBlock:(void (^)(void))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock;

/// Remote Buzzer reminder parameters.
/// @param ringingTime Ringing time.1 ~ 6000(Unit:100ms)
/// @param ringingInterval Ringing interval.0 ~ 100(Unit:100ms)®
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_configRemoteReminderBuzzerNotiParams:(NSInteger)ringingTime
                                 ringingInterval:(NSInteger)ringingInterval
                                        sucBlock:(void (^)(void))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock;

/// Dismiss alarm.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_configDismissAlarmWithSucBlock:(void (^)(void))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock;

/// Dismiss alarm by button.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_configDismissAlarmByButton:(BOOL)isOn
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure LED dismissal alarm parameter.
/// @param time 1~6000 (unit:100ms)
/// @param interval 0~100(unit:100ms)
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_configDismissAlarmLEDNotiParams:(NSInteger)time
                                   interval:(NSInteger)interval
                                   sucBlock:(void (^)(void))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure Vibration dismissal alarm parameter.(BXP-CR only)
/// @param time 1~6000 (unit:100ms)
/// @param interval 0~100(unit:100ms)
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_configDismissAlarmVibrationNotiParams:(NSInteger)time
                                         interval:(NSInteger)interval
                                         sucBlock:(void (^)(void))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure Buzzer dismissal alarm parameter.
/// @param time 1~6000 (unit:100ms)
/// @param interval 0~100(unit:100ms)
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_configDismissAlarmBuzzerNotiParams:(NSInteger)time
                                      interval:(NSInteger)interval
                                      sucBlock:(void (^)(void))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock;

/// Dismiss alarm notification type.
/// @param type mk_bxd_reminderType
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_configDismissAlarmNotificationType:(mk_bxd_reminderType)type
                                      sucBlock:(void (^)(void))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock;

/// Delete the trigger record of the single press event.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_clearSinglePressEventDataWithSucBlock:(void (^)(void))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock;

/// Delete the trigger record of the double press event.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_clearDoublePressEventDataWithSucBlock:(void (^)(void))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock;

/// Delete the trigger record of the long press event.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_clearLongPressEventDataWithSucBlock:(void (^)(void))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the device's timestamp.(BXP-CR only)
/// @param timestamp ms.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_configDeviceTimestamp:(long long)timestamp
                         sucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock;

/// Delete the long connection mode event data.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_clearLongConnectionModeEventDataWithSucBlock:(void (^)(void))sucBlock
                                             failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the device' ID.
/// @param deviceID 1 ~ 6 Bytes.(HEX)
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_configDeviceID:(NSString *)deviceID
                  sucBlock:(void (^)(void))sucBlock
               failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the broadcast name of the device.
/// @param deviceName 1~10 ascii characters
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_configDeviceName:(NSString *)deviceName
                    sucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock;

/// Reset the battery.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_batteryResetWithSucBlock:(void (^)(void))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark - password
/// Whether the device has enabled password verification when connecting. When the device has disabled password verification, no password is required to connect to the device, otherwise a connection password is required.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxd_configPasswordVerification:(BOOL)isOn
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
