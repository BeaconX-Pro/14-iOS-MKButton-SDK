//
//  MKBXDPowerSaveModel.m
//  MKBeaconXDButton_Example
//
//  Created by aa on 2022/2/22.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXDPowerSaveModel.h"

#import "MKMacroDefines.h"

#import "MKBXDInterface.h"
#import "MKBXDInterface+MKBXDConfig.h"

@interface MKBXDPowerSaveModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKBXDPowerSaveModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readModeStatus]) {
            [self operationFailedBlockWithMsg:@"Read Power saving mode error" block:failedBlock];
            return;
        }
        if (![self readTriggerTime]) {
            [self operationFailedBlockWithMsg:@"Read Static trigger time error" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self validParams]) {
            [self operationFailedBlockWithMsg:@"Params Error" block:failedBlock];
            return;
        }
        if (![self configModeStatus]) {
            [self operationFailedBlockWithMsg:@"Config Power saving mode error" block:failedBlock];
            return;
        }
        if (self.isOn) {
            if (![self configTriggerTime]) {
                [self operationFailedBlockWithMsg:@"Config Static trigger time error" block:failedBlock];
                return;
            }
        }
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

#pragma mark - interface
- (BOOL)readModeStatus {
    __block BOOL success = NO;
    [MKBXDInterface bxd_readPowerSavingModeWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.isOn = [returnData[@"result"][@"isOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configModeStatus {
    __block BOOL success = NO;
    [MKBXDInterface bxd_configPowerSavingMode:self.isOn sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readTriggerTime {
    __block BOOL success = NO;
    [MKBXDInterface bxd_readStaticTriggerTimeWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.triggerTime = returnData[@"result"][@"time"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configTriggerTime {
    __block BOOL success = NO;
    [MKBXDInterface bxd_configStaticTriggerTime:[self.triggerTime integerValue] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

#pragma mark - private method
- (void)operationFailedBlockWithMsg:(NSString *)msg block:(void (^)(NSError *error))block {
    moko_dispatch_main_safe(^{
        NSError *error = [[NSError alloc] initWithDomain:@"PowerSaveParams"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    })
}

- (BOOL)validParams {
    if (self.isOn) {
        if (!ValidStr(self.triggerTime) || [self.triggerTime integerValue] < 1 || [self.triggerTime integerValue] > 65535) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - getter
- (dispatch_semaphore_t)semaphore {
    if (!_semaphore) {
        _semaphore = dispatch_semaphore_create(0);
    }
    return _semaphore;
}

- (dispatch_queue_t)readQueue {
    if (!_readQueue) {
        _readQueue = dispatch_queue_create("PowerSaveQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
