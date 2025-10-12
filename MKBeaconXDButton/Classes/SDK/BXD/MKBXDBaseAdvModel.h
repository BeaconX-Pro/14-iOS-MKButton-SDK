//
//  MKBXDBaseAdvModel.h
//  MKBeaconXDButton_Example
//
//  Created by aa on 2022/2/23.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MKBXDDataFrameType) {
    MKBXDUnknownFrameType,          //Unknown.
    MKBXDAdvFrameType,              //device broadcast packet.
    MKBXDRespondFrameType,          //Device broadcast response packet.
    MKBXDUIDFrameType,              //UID
    MKBXDBeaconFrameType,           //iBeacon
};

typedef NS_ENUM(NSInteger, MKBXDAdvAlarmType) {
    MKBXDAdvAlarmType_single,                    //Click to trigger info frame.
    MKBXDAdvAlarmType_double,                    //Double click to trigger info frame.
    MKBXDAdvAlarmType_long,                      //Long press to trigger info frame.
    MKBXDAdvAlarmType_abnormalInactivity,        //Abnormal inactivity to trigger info frame.
};

@class CBPeripheral;

@interface MKBXDBaseAdvModel : NSObject

/**
 Frame type
 */
@property (nonatomic, assign)MKBXDDataFrameType frameType;
/**
 rssi
 */
@property (nonatomic, strong)NSNumber *rssi;

@property (nonatomic, assign) BOOL connectEnable;

/**
 Scanned device identifier
 */
@property (nonatomic, copy)NSString *identifier;
/**
 Scanned devices
 */
@property (nonatomic, strong)CBPeripheral *peripheral;
/**
 Advertisement data of device
 */
@property (nonatomic, strong)NSData *advertiseData;

@property (nonatomic, copy)NSString *deviceName;

+ (NSArray <MKBXDBaseAdvModel *>*)parseAdvData:(NSDictionary *)advData
                                    peripheral:(CBPeripheral *)peripheral
                                          RSSI:(NSNumber *)RSSI;

@end



@interface MKBXDAdvDataModel : MKBXDBaseAdvModel

@property (nonatomic, assign)MKBXDAdvAlarmType alarmType;

/*
 version = 0/1 0: Standby 1:Trigger
 version = 2 0: Standby 1:Main-Triggered 2:Sub-Triggered
 */
@property (nonatomic, assign)NSInteger triggerStatus;

/// Trigger Count.
@property (nonatomic, copy)NSString *triggerCount;

@property (nonatomic, copy)NSString *deviceID;

/// 0: V1 1: Long connection 2:V2(Double button)
@property (nonatomic, assign)NSInteger version;

/// Only for version is V2(Double button).
@property (nonatomic, assign)BOOL motionStatus;

- (MKBXDAdvDataModel *)initWithAdvertiseData:(NSData *)advData;

@end


@interface MKBXDAdvRespondDataModel : MKBXDBaseAdvModel

@property (nonatomic, strong)NSNumber *txPower;

/// 3-axis accelerometer range.0:±2g，1:±4g，2:±8g，3:±16g
@property (nonatomic, copy)NSString *fullScale;

/// Motion threshold.(unit:mg)
@property (nonatomic, copy)NSString *motionThreshold;

@property (nonatomic, copy)NSString *xData;

@property (nonatomic, copy)NSString *yData;

@property (nonatomic, copy)NSString *zData;

/// If the temperature value is ffff, it means that the function is not
@property (nonatomic, copy)NSString *beaconTemperature;

/// RSSI@0m
@property (nonatomic, copy)NSString *rangingData;

/// battery voltage.mV.
@property (nonatomic, copy)NSString *voltage;

@property (nonatomic, copy)NSString *macAddress;

- (MKBXDAdvRespondDataModel *)initRespondWithAdvertiseData:(NSData *)advData;

@end


@interface MKBXDUIDBeacon : MKBXDBaseAdvModel

//RSSI@0m
@property (nonatomic, strong) NSNumber *txPower;
@property (nonatomic, copy) NSString *namespaceId;
@property (nonatomic, copy) NSString *instanceId;

- (MKBXDUIDBeacon *)initWithAdvertiseData:(NSData *)advData;

@end



@interface MKBXDBeacon : MKBXDBaseAdvModel

//RSSI@1m
@property (nonatomic, copy)NSNumber *rssi1M;
@property (nonatomic, copy)NSNumber *txPower;
//Advetising Interval
@property (nonatomic, copy) NSString *interval;

@property (nonatomic, copy)NSString *major;

@property (nonatomic, copy)NSString *minor;

@property (nonatomic, copy)NSString *uuid;

- (MKBXDBeacon *)initWithAdvertiseData:(NSData *)advData;

@end

NS_ASSUME_NONNULL_END
