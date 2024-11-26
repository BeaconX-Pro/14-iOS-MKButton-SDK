//
//  MKBXDConnectManager.m
//  MKBeaconXDButton_Example
//
//  Created by aa on 2022/2/18.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXDConnectManager.h"

#import <CoreBluetooth/CoreBluetooth.h>

#import "MKMacroDefines.h"

#import "MKBXDSDK.h"

@interface MKBXDConnectManager ()

@property (nonatomic, strong)dispatch_queue_t connectQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKBXDConnectManager

+ (MKBXDConnectManager *)shared {
    static MKBXDConnectManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [MKBXDConnectManager new];
        }
    });
    return manager;
}

- (void)connectDevice:(CBPeripheral *)peripheral
             password:(NSString *)password
             sucBlock:(void (^)(void))sucBlock
          failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.connectQueue, ^{
        NSDictionary *dic = @{};
        if (ValidStr(password) && password.length <= 16) {
            //有密码登录
            dic = [self connectDevice:peripheral password:password];
            self.needPassword = YES;
            self.password = password;
        }else {
            //免密登录
            dic = [self connectDevice:peripheral];
            self.needPassword = NO;
            self.password = @"";
        }
         
        if (![dic[@"success"] boolValue]) {
            [self operationFailedMsg:dic[@"msg"] completeBlock:failedBlock];
            return ;
        }
        if (![self readDeviceType]) {
            [self operationFailedMsg:@"Read Device Type Error" completeBlock:failedBlock];
            return;
        }
        NSString *software = [self readSoftwareVersion];
        if (!ValidStr(software)) {
            [self operationFailedMsg:@"Read Software Failed!" completeBlock:failedBlock];
            return;
        }
        if (![software isEqualToString:@"BXP-B-D"]) {
            [self operationFailedMsg:@"Opps:The current app only supports BXP-B-D type devices!" completeBlock:failedBlock];
            return;
            return;
        }
        
        if (![self readSensorStatus]) {
            [self operationFailedMsg:@"Read Sensor Error" completeBlock:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

#pragma mark - interface
- (NSDictionary *)connectDevice:(CBPeripheral *)peripheral password:(NSString *)password {
    __block NSDictionary *connectResult = @{};
    [[MKBXDCentralManager shared] connectPeripheral:peripheral password:password sucBlock:^(CBPeripheral * _Nonnull peripheral) {
        connectResult = @{
            @"success":@(YES),
        };
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        connectResult = @{
            @"success":@(NO),
            @"msg":SafeStr(error.userInfo[@"errorInfo"]),
        };
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return connectResult;
}

- (NSDictionary *)connectDevice:(CBPeripheral *)peripheral {
    __block NSDictionary *connectResult = @{};
    [[MKBXDCentralManager shared] connectPeripheral:peripheral sucBlock:^(CBPeripheral * _Nonnull peripheral) {
        connectResult = @{
            @"success":@(YES),
        };
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        connectResult = @{
            @"success":@(NO),
            @"msg":SafeStr(error.userInfo[@"errorInfo"]),
        };
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return connectResult;
}

- (BOOL)readDeviceType {
    __block BOOL success = NO;
    [MKBXDInterface bxd_readDeviceTypeWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.deviceType = returnData[@"result"][@"deviceType"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (NSString *)readSoftwareVersion {
    __block NSString *software = @"";
    [MKBXDInterface bxd_readSoftwareWithSucBlock:^(id  _Nonnull returnData) {
        software = returnData[@"result"][@"software"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return software;
}

- (BOOL)readSensorStatus {
    __block BOOL success = NO;
    [MKBXDInterface bxd_readSensorStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.threeSensor = [returnData[@"result"][@"threeAxis"] boolValue];
        self.htSensor = [returnData[@"result"][@"htSensor"] boolValue];
        self.lightSensor = [returnData[@"result"][@"lightSensor"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

#pragma mark - private method
- (void)operationFailedMsg:(NSString *)msg completeBlock:(void (^)(NSError *error))block {
    moko_dispatch_main_safe(^{
        [[MKBXDCentralManager shared] disconnect];
        if (block) {
            NSError *error = [[NSError alloc] initWithDomain:@"connectDevice"
                                                        code:-999
                                                    userInfo:@{@"errorInfo":SafeStr(msg)}];
            block(error);
        }
    });
}

#pragma mark - getter
- (dispatch_queue_t)connectQueue {
    if (!_connectQueue) {
        _connectQueue = dispatch_queue_create("com.moko.connectQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _connectQueue;
}

- (dispatch_semaphore_t)semaphore {
    if (!_semaphore) {
        _semaphore = dispatch_semaphore_create(0);
    }
    return _semaphore;
}

@end
