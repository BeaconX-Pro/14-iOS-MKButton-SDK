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

@end

@implementation MKBXDPeripheral

- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral {
    if (self = [super init]) {
        self.peripheral = peripheral;
    }
    return self;
}

- (void)discoverServices {
    NSArray *services = @[[CBUUID UUIDWithString:@"AA00"],  //custom配置服务
                          [CBUUID UUIDWithString:@"180A"]]; //设备信息服务
    [self.peripheral discoverServices:services];
}

- (void)discoverCharacteristics {
    for (CBService *service in self.peripheral.services) {
        if ([service.UUID isEqual:[CBUUID UUIDWithString:@"AA00"]]) {
            NSArray *list = @[[CBUUID UUIDWithString:@"AA01"],
                              [CBUUID UUIDWithString:@"AA02"],
                              [CBUUID UUIDWithString:@"AA06"],
                              [CBUUID UUIDWithString:@"AA07"],
                              [CBUUID UUIDWithString:@"AA08"]];
            [self.peripheral discoverCharacteristics:list forService:service];
        } else if ([service.UUID isEqual:[CBUUID UUIDWithString:@"180A"]]) {
            NSArray *characteristics = @[[CBUUID UUIDWithString:@"2A24"],
                                         [CBUUID UUIDWithString:@"2A25"],
                                         [CBUUID UUIDWithString:@"2A26"],
                                         [CBUUID UUIDWithString:@"2A27"],
                                         [CBUUID UUIDWithString:@"2A28"],
                                         [CBUUID UUIDWithString:@"2A29"]];
            [self.peripheral discoverCharacteristics:characteristics forService:service];
        }
    }
}

- (void)updateCharacterWithService:(CBService *)service {
    [self.peripheral bxd_updateCharacterWithService:service];
}

- (void)updateCurrentNotifySuccess:(CBCharacteristic *)characteristic {
    [self.peripheral bxd_updateCurrentNotifySuccess:characteristic];
}

- (BOOL)connectSuccess {
    return [self.peripheral bxd_connectSuccess];
}

- (void)setNil {
    [self.peripheral bxd_setNil];
}

@end
