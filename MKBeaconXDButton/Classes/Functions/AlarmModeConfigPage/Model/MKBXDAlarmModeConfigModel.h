//
//  MKBXDAlarmModeConfigModel.h
//  MKBeaconXDButton_Example
//
//  Created by aa on 2022/2/19.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXDAlarmModeConfigModel : NSObject

/// 0:single 1:double 2:long 3:abnormal
@property (nonatomic, assign)NSInteger alarmType;

@property (nonatomic, assign)BOOL advIsOn;

/// 1~8 字节长度
@property (nonatomic, copy)NSString *deviceID;

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

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
