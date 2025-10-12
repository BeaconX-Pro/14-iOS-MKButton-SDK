//
//  MKBXDAlarmEventDBDataModel.m
//  MKBeaconXDButton_Example
//
//  Created by aa on 2025/10/10.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import "MKBXDAlarmEventDBDataModel.h"

#import "MKMacroDefines.h"

#import "MKBXDInterface.h"

@interface MKBXDAlarmEventDBDataModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKBXDAlarmEventDBDataModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readSingleMainCount]) {
            [self operationFailedBlockWithMsg:@"Read Single Main Count Error" block:failedBlock];
            return;
        }
        if (![self readSingleSubCount]) {
            [self operationFailedBlockWithMsg:@"Read Single Sub Count Error" block:failedBlock];
            return;
        }
        if (![self readDoubleMainCount]) {
            [self operationFailedBlockWithMsg:@"Read Double Main Count Error" block:failedBlock];
            return;
        }
        if (![self readDoubleSubCount]) {
            [self operationFailedBlockWithMsg:@"Read Double Sub Count Error" block:failedBlock];
            return;
        }
        if (![self readLongMainCount]) {
            [self operationFailedBlockWithMsg:@"Read Long Main Count Error" block:failedBlock];
            return;
        }
        if (![self readLongSubCount]) {
            [self operationFailedBlockWithMsg:@"Read Long Sub Count Error" block:failedBlock];
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

- (BOOL)readSingleMainCount {
    __block BOOL success = NO;
    [MKBXDInterface bxd_readSinglePressEventCountWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.singleMainCount = returnData[@"result"][@"count"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readSingleSubCount {
    __block BOOL success = NO;
    [MKBXDInterface bxd_readSubButtonSinglePressEventCountWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.singleSubCount = returnData[@"result"][@"count"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readDoubleMainCount {
    __block BOOL success = NO;
    [MKBXDInterface bxd_readDoublePressEventCountWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.doubleMainCount = returnData[@"result"][@"count"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readDoubleSubCount {
    __block BOOL success = NO;
    [MKBXDInterface bxd_readSubButtonDoublePressEventCountWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.doubleSubCount = returnData[@"result"][@"count"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readLongMainCount {
    __block BOOL success = NO;
    [MKBXDInterface bxd_readLongPressEventCountWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.longMainCount = returnData[@"result"][@"count"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readLongSubCount {
    __block BOOL success = NO;
    [MKBXDInterface bxd_readSubButtonLongPressEventCountWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.longSubCount = returnData[@"result"][@"count"];
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
        NSError *error = [[NSError alloc] initWithDomain:@"AlarmEventParams"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    })
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
        _readQueue = dispatch_queue_create("AlarmEventQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
