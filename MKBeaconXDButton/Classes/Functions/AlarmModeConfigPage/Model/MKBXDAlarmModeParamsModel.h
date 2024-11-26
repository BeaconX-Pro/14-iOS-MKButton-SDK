//
//  MKBXDAlarmModeParamsModel.h
//  MKBeaconXDButton_Example
//
//  Created by aa on 2024/11/25.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MKBXDSDKNormalDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKBXDTriggerChannelAdvParamsModel : NSObject<MKBXDTriggerChannelAdvParamsProtocol>

@property (nonatomic, assign)MKBXDChannelAlarmType alarmType;

/// Whether to enable advertising.
@property (nonatomic, assign)BOOL isOn;

/// Ranging data.(-100dBm~0dBm)
@property (nonatomic, assign)NSInteger rssi;

/// advertising interval.(1~500,unit:20ms)
@property (nonatomic, copy)NSString *advInterval;

@property (nonatomic, assign)mk_bxd_txPower txPower;

@end


@interface MKBXDChannelTriggerParamsModel : NSObject<MKBXDChannelTriggerParamsProtocol>

@property (nonatomic, assign)MKBXDChannelAlarmType alarmType;

/// Whether to enable trigger function.
@property (nonatomic, assign)BOOL alarm;

/// Ranging data.(-100dBm~0dBm)
@property (nonatomic, assign)NSInteger rssi;

/// advertising interval.(1~500,unit:20ms)
@property (nonatomic, copy)NSString *advInterval;

/// broadcast time after trigger.1s~65535s.
@property (nonatomic, copy)NSString *advertisingTime;

@property (nonatomic, assign)mk_bxd_txPower txPower;

@end


@interface MKBXDAlarmModeParamsModel : NSObject

@end

NS_ASSUME_NONNULL_END
