//
//  CBPeripheral+MKBXDAdd.h
//  MKBeaconXDButton_Example
//
//  Created by aa on 2022/2/18.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBPeripheral (MKBXDAdd)

#pragma mark - 系统信息下面的特征
/// R
@property (nonatomic, strong, readonly)CBCharacteristic *bxd_manufacturer;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *bxd_deviceModel;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *bxd_productionDate;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *bxd_hardware;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *bxd_software;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *bxd_firmware;

#pragma mark - Custom Characteristic
@property (nonatomic, strong, readonly)CBCharacteristic *bxd_custom;
@property (nonatomic, strong, readonly)CBCharacteristic *bxd_disconnectType;
@property (nonatomic, strong, readonly)CBCharacteristic *bxd_singleAlarmData;
@property (nonatomic, strong, readonly)CBCharacteristic *bxd_doubleAlarmData;
@property (nonatomic, strong, readonly)CBCharacteristic *bxd_longAlarmData;
@property (nonatomic, strong, readonly)CBCharacteristic *bxd_threeAxisData;
@property (nonatomic, strong, readonly)CBCharacteristic *bxd_password;

- (void)bxd_updateCharacterWithService:(CBService *)service;

- (void)bxd_updateCurrentNotifySuccess:(CBCharacteristic *)characteristic;

- (BOOL)bxd_connectSuccess;

- (void)bxd_setNil;

@end

NS_ASSUME_NONNULL_END
