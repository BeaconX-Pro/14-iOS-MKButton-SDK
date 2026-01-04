//
//  MKBXDPeripheral.m
//  MKBeaconXDButton_Example
//
//  Created by aa on 2022/2/18.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXDPeripheral.h"

#import <CoreBluetooth/CoreBluetooth.h>

#import "CBPeripheral+MKBXDAdd.h"

@interface MKBXDPeripheral ()

@property (nonatomic, strong)CBPeripheral *peripheral;

@property (nonatomic, assign)BOOL dfu;

@end

@implementation MKBXDPeripheral

- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral dfuMode:(BOOL)dfu {
    if (self = [super init]) {
        self.peripheral = peripheral;
        self.dfu = dfu;
    }
    return self;
}

- (void)discoverServices {
    [self.peripheral discoverServices:nil];
}

- (void)discoverCharacteristics {
    for (CBService *service in self.peripheral.services) {
        [self.peripheral discoverCharacteristics:nil forService:service];
    }
}

- (void)updateCharacterWithService:(CBService *)service {
    [self.peripheral bxd_updateCharacterWithService:service];
}

- (void)updateCurrentNotifySuccess:(CBCharacteristic *)characteristic {
    [self.peripheral bxd_updateCurrentNotifySuccess:characteristic];
}

- (BOOL)connectSuccess {
    return [self.peripheral bxd_connectSuccess:self.dfu];
}

- (void)setNil {
    [self.peripheral bxd_setNil];
}

@end
