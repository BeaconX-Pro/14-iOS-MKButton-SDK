//
//  MKBXDQuickSwitchModel.m
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/8/18.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXDQuickSwitchModel.h"

#import "MKMacroDefines.h"

#import "MKBXDConnectManager.h"

#import "MKBXDInterface.h"

@interface MKBXDQuickSwitchModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKBXDQuickSwitchModel

- (void)readWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readConnectable]) {
            [self operationFailedBlockWithMsg:@"Read Connectable Error" block:failedBlock];
            return;
        }
        if (![self readTurnOffByButton]) {
            [self operationFailedBlockWithMsg:@"Read Turn off Beacon by button Error" block:failedBlock];
            return;
        }
        if (![self readPasswordVerification]) {
            [self operationFailedBlockWithMsg:@"Read Password verification Error" block:failedBlock];
            return;
        }
        if (![self readResetByButton]) {
            [self operationFailedBlockWithMsg:@"Read Reset Beacon by button Error" block:failedBlock];
            return;
        }
        if (![self readScanPacket]) {
            [self operationFailedBlockWithMsg:@"Read Scan response packet Error" block:failedBlock];
            return;
        }
        if (![self readDismissAlarmByButton]) {
            [self operationFailedBlockWithMsg:@"Read Dismiss alarm by button Error" block:failedBlock];
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
- (BOOL)readConnectable {
    __block BOOL success = NO;
    [MKBXDInterface bxd_readConnectableWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.connectable = [returnData[@"result"][@"connectable"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readTurnOffByButton {
    __block BOOL success = NO;
    [MKBXDInterface bxd_readTurnOffDeviceByButtonStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.turnOffByButton = [returnData[@"result"][@"isOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readPasswordVerification {
    __block BOOL success = NO;
    [MKBXDInterface bxd_readPasswordVerificationWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.passwordVerification = [returnData[@"result"][@"isOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readResetByButton {
    __block BOOL success = NO;
    [MKBXDInterface bxd_readResetDeviceByButtonStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.resetByButton = [returnData[@"result"][@"isOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readScanPacket {
    __block BOOL success = NO;
    [MKBXDInterface bxd_readScanResponsePacketWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.scanPacket = [returnData[@"result"][@"isOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readDismissAlarmByButton {
    __block BOOL success = NO;
    [MKBXDInterface bxd_readDismissAlarmByButtonWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.dismiss = [returnData[@"result"][@"isOn"] boolValue];
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
        NSError *error = [[NSError alloc] initWithDomain:@"quickSwitchParams"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    });
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
        _readQueue = dispatch_queue_create("quickSwitchQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
