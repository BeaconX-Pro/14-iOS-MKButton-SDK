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

//BXP-CR
@property (nonatomic, strong, readonly)CBCharacteristic *bxd_singleRecord;
//BXP-CR
@property (nonatomic, strong, readonly)CBCharacteristic *bxd_doubleRecord;
//BXP-CR
@property (nonatomic, strong, readonly)CBCharacteristic *bxd_longRecord;

//BXP-CR
@property (nonatomic, strong, readonly)CBCharacteristic *bxd_longConnectRecord;

@property (nonatomic, strong, readonly)CBCharacteristic *bxd_password;
@property (nonatomic, strong, readonly)CBCharacteristic *bxd_threeAxisData;
@property (nonatomic, strong, readonly)CBCharacteristic *bxd_longConModeData;
@property (nonatomic, strong, readonly)CBCharacteristic *bxd_subBtnData;

#pragma mark - OTA

@property (nonatomic, strong, readonly)CBCharacteristic *bxd_otaData;

@property (nonatomic, strong, readonly)CBCharacteristic *bxd_otaControl;

- (void)bxd_updateCharacterWithService:(CBService *)service;

- (void)bxd_updateCurrentNotifySuccess:(CBCharacteristic *)characteristic;

- (BOOL)bxd_connectSuccess:(BOOL)dfu;

- (void)bxd_setNil;

@end

NS_ASSUME_NONNULL_END
