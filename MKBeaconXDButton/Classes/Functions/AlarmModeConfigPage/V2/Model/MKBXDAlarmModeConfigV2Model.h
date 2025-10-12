//
//  MKBXDAlarmModeConfigV2Model.h
//  MKBeaconXDButton_Example
//
//  Created by aa on 2024/11/25.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MKBXDSlotConfigDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKBXDAlarmModeConfigV2Model : NSObject

@property (nonatomic, assign)BOOL singleIsOn;

@property (nonatomic, assign)BOOL doubleIsOn;

@property (nonatomic, assign)BOOL longIsOn;

@property (nonatomic, assign)BOOL inactivityIsOn;

/// 0:single 1:double 2:long 3:abnormal
@property (nonatomic, assign)NSInteger alarmType;

@property (nonatomic, assign)bxd_slotType slotType;

@property (nonatomic, assign)BOOL advIsOn;

/// 1x20ms~500x20ms
@property (nonatomic, copy)NSString *advInterval;

/// -100 dBm ~ 0 dBm
@property (nonatomic, assign)NSInteger rangingData;

/*
 0:-40dBm
 1:-20dBm
 2:-16dBm
 3:-12dBm
 4:-8dBm
 5:-4dBm
 6:0dBm
 7:+3dBm
 8:+4dBm
 */
@property (nonatomic, assign)NSInteger txPower;

@property (nonatomic, assign)BOOL alarmMode;

@property (nonatomic, assign)BOOL stayAdv;

/// Abnormal inactivity mode才有
@property (nonatomic, copy)NSString *abnormalTime;

/// 1s~65535s
@property (nonatomic, copy)NSString *alarmMode_advTime;

/// 1x20ms~500x20ms
@property (nonatomic, copy)NSString *alarmMode_advInterval;

/// -100 dBm ~ 0 dBm
@property (nonatomic, assign)NSInteger alarmMode_rssi;

/*
 0:-40dBm
 1:-20dBm
 2:-16dBm
 3:-12dBm
 4:-8dBm
 5:-4dBm
 6:0dBm
 7:+3dBm
 8:+4dBm
 */
@property (nonatomic, assign)NSInteger alarmMode_txPower;


#pragma mark - UID
@property (nonatomic, copy)NSString *namespaceID;

@property (nonatomic, copy)NSString *instanceID;

#pragma mark - iBeacon
@property (nonatomic, copy)NSString *major;

@property (nonatomic, copy)NSString *minor;

@property (nonatomic, copy)NSString *uuid;



#pragma mark - 底部Trigger notification type
@property (nonatomic, assign)BOOL showTriggerType;

/*
 BXP-B-D:
 0:Silent
 1:LED
 2:Buzzer
 3:LED+Buzzer
 
 BXP-CR:
 0:Silent
 1:LED
 2:Vibaration
 3:Buzzer
 4:LED+Vibaration
 5:LED+Buzzer
 */
@property (nonatomic, assign)NSInteger alarmNotiType;

#pragma mark - LED notification
@property (nonatomic, copy)NSString *blinkingTime;

@property (nonatomic, copy)NSString *blinkingInterval;

#pragma mark - Vibration notification
@property (nonatomic, copy)NSString *vibratingTime;

@property (nonatomic, copy)NSString *vibratingInterval;

#pragma mark - Buzzer notification
@property (nonatomic, copy)NSString *ringingTime;

@property (nonatomic, copy)NSString *ringingInterval;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;


@end

NS_ASSUME_NONNULL_END
