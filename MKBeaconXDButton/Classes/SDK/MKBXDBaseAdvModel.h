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

/// Whether the current trigger channel is in the trigger state.
@property (nonatomic, assign)BOOL trigger;

/// Trigger Count.
@property (nonatomic, copy)NSString *triggerCount;

@property (nonatomic, copy)NSString *deviceType;

@property (nonatomic, copy)NSString *deviceID;

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

NS_ASSUME_NONNULL_END
