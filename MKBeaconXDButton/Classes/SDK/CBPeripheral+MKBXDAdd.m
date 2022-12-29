//
//  CBPeripheral+MKBXDAdd.m
//  MKBeaconXDButton_Example
//
//  Created by aa on 2022/2/18.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "CBPeripheral+MKBXDAdd.h"

#import <objc/runtime.h>

static const char *bxd_customKey = "bxd_customKey";
static const char *bxd_disconnectTypeKey = "bxd_disconnectTypeKey";
static const char *bxd_singleAlarmDataKey = "bxd_singleAlarmDataKey";
static const char *bxd_doubleAlarmDataKey = "bxd_doubleAlarmDataKey";
static const char *bxd_longAlarmDataKey = "bxd_longAlarmDataKey";
static const char *bxd_threeAxisDataKey = "bxd_threeAxisDataKey";
static const char *bxd_passwordKey = "bxd_passwordKey";

static const char *bxd_manufacturerKey = "bxd_manufacturerKey";
static const char *bxd_deviceModelKey = "bxd_deviceModelKey";
static const char *bxd_productionDateKey = "bxd_productionDateKey";
static const char *bxd_hardwareKey = "bxd_hardwareKey";
static const char *bxd_softwareKey = "bxd_softwareKey";
static const char *bxd_firmwareKey = "bxd_firmwareKey";

static const char *bxd_customSuccessKey = "bxd_customSuccessKey";
static const char *bxd_disconnectTypeSuccessKey = "bxd_disconnectTypeSuccessKey";
static const char *bxd_passwordSuccessKey = "bxd_passwordSuccessKey";

@implementation CBPeripheral (MKBXDAdd)

- (void)bxd_updateCharacterWithService:(CBService *)service {
    NSArray *characteristicList = service.characteristics;
    if ([service.UUID isEqual:[CBUUID UUIDWithString:@"180A"]]) {
        //设备信息
        for (CBCharacteristic *characteristic in characteristicList) {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A24"]]) {
                objc_setAssociatedObject(self, &bxd_deviceModelKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A25"]]) {
                objc_setAssociatedObject(self, &bxd_productionDateKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A26"]]) {
                objc_setAssociatedObject(self, &bxd_firmwareKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A27"]]) {
                objc_setAssociatedObject(self, &bxd_hardwareKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A28"]]) {
                objc_setAssociatedObject(self, &bxd_softwareKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A29"]]) {
                objc_setAssociatedObject(self, &bxd_manufacturerKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
        return;
    }
    if ([service.UUID isEqual:[CBUUID UUIDWithString:@"AA00"]]) {
        //自定义
        for (CBCharacteristic *characteristic in characteristicList) {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA01"]]) {
                objc_setAssociatedObject(self, &bxd_customKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                [self setNotifyValue:YES forCharacteristic:characteristic];
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA02"]]) {
                objc_setAssociatedObject(self, &bxd_disconnectTypeKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                [self setNotifyValue:YES forCharacteristic:characteristic];
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA03"]]) {
                objc_setAssociatedObject(self, &bxd_singleAlarmDataKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA04"]]) {
                objc_setAssociatedObject(self, &bxd_doubleAlarmDataKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA05"]]) {
                objc_setAssociatedObject(self, &bxd_longAlarmDataKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA06"]]) {
                objc_setAssociatedObject(self, &bxd_threeAxisDataKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA07"]]) {
                objc_setAssociatedObject(self, &bxd_passwordKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                [self setNotifyValue:YES forCharacteristic:characteristic];
            }
        }
        return;
    }
}

- (void)bxd_updateCurrentNotifySuccess:(CBCharacteristic *)characteristic {
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA01"]]){
        objc_setAssociatedObject(self, &bxd_customSuccessKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA02"]]){
        objc_setAssociatedObject(self, &bxd_disconnectTypeSuccessKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA07"]]) {
        objc_setAssociatedObject(self, &bxd_passwordSuccessKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
}

- (BOOL)bxd_connectSuccess {
    if (![objc_getAssociatedObject(self, &bxd_disconnectTypeSuccessKey) boolValue] || ![objc_getAssociatedObject(self, &bxd_customSuccessKey) boolValue] || ![objc_getAssociatedObject(self, &bxd_passwordSuccessKey) boolValue]) {
        return NO;
    }
    if (![self bxd_customServiceSuccess] || ![self bxd_deviceInfoServiceSuccess]) {
        return NO;
    }
    return YES;
}

- (void)bxd_setNil {
    objc_setAssociatedObject(self, &bxd_manufacturerKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxd_productionDateKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxd_deviceModelKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxd_hardwareKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxd_softwareKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxd_firmwareKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    objc_setAssociatedObject(self, &bxd_customKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxd_disconnectTypeKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxd_singleAlarmDataKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxd_doubleAlarmDataKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxd_longAlarmDataKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxd_threeAxisDataKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxd_passwordKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    objc_setAssociatedObject(self, &bxd_customSuccessKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxd_disconnectTypeSuccessKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxd_passwordSuccessKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - getter

- (CBCharacteristic *)bxd_manufacturer {
    return objc_getAssociatedObject(self, &bxd_manufacturerKey);
}

- (CBCharacteristic *)bxd_productionDate {
    return objc_getAssociatedObject(self, &bxd_productionDateKey);
}

- (CBCharacteristic *)bxd_deviceModel {
    return objc_getAssociatedObject(self, &bxd_deviceModelKey);
}

- (CBCharacteristic *)bxd_hardware {
    return objc_getAssociatedObject(self, &bxd_hardwareKey);
}

- (CBCharacteristic *)bxd_software {
    return objc_getAssociatedObject(self, &bxd_softwareKey);
}

- (CBCharacteristic *)bxd_firmware {
    return objc_getAssociatedObject(self, &bxd_firmwareKey);
}

- (CBCharacteristic *)bxd_custom {
    return objc_getAssociatedObject(self, &bxd_customKey);
}

- (CBCharacteristic *)bxd_disconnectType {
    return objc_getAssociatedObject(self, &bxd_disconnectTypeKey);
}

- (CBCharacteristic *)bxd_singleAlarmData {
    return objc_getAssociatedObject(self, &bxd_singleAlarmDataKey);
}

- (CBCharacteristic *)bxd_doubleAlarmData {
    return objc_getAssociatedObject(self, &bxd_doubleAlarmDataKey);
}

- (CBCharacteristic *)bxd_longAlarmData {
    return objc_getAssociatedObject(self, &bxd_longAlarmDataKey);
}

- (CBCharacteristic *)bxd_threeAxisData {
    return objc_getAssociatedObject(self, &bxd_threeAxisDataKey);
}

- (CBCharacteristic *)bxd_password {
    return objc_getAssociatedObject(self, &bxd_passwordKey);
}

#pragma mark - private method
- (BOOL)bxd_customServiceSuccess {
    if (!self.bxd_custom || !self.bxd_disconnectType || !self.bxd_singleAlarmData || !self.bxd_doubleAlarmData || !self.bxd_longAlarmData || !self.bxd_threeAxisData || !self.bxd_password) {
        return NO;
    }
    return YES;
}

- (BOOL)bxd_deviceInfoServiceSuccess {
    if (!self.bxd_manufacturer || !self.bxd_productionDate
        || !self.bxd_deviceModel || !self.bxd_hardware
        || !self.bxd_software || !self.bxd_firmware) {
        return NO;
    }
    return YES;
}

@end
