//
//  MKBXDAlarmEventCRModel.m
//  MKBeaconXDButton_Example
//
//  Created by aa on 2025/3/19.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import "MKBXDAlarmEventCRModel.h"

#import "MKMacroDefines.h"

#import "MKBXDInterface.h"

@interface MKBXDAlarmEventCRModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@property (nonatomic, strong)NSDateFormatter *dateFormatter;

@end

@implementation MKBXDAlarmEventCRModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readTimestamp]) {
            [self operationFailedBlockWithMsg:@"Read Timestamp Error" block:failedBlock];
            return;
        }
        if (![self readSingleCount]) {
            [self operationFailedBlockWithMsg:@"Read Single Count Error" block:failedBlock];
            return;
        }
        if (![self readDoubleCount]) {
            [self operationFailedBlockWithMsg:@"Read Double Count Error" block:failedBlock];
            return;
        }
        if (![self readLongCount]) {
            [self operationFailedBlockWithMsg:@"Read Long Count Error" block:failedBlock];
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
- (BOOL)readTimestamp {
    __block BOOL success = NO;
    [MKBXDInterface bxd_readDeviceTimestampWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        long long timestamp = [returnData[@"result"][@"timestamp"] longLongValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:(timestamp / 1000.0)];
        self.timestamp = [self.dateFormatter stringFromDate:date];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readSingleCount {
    __block BOOL success = NO;
    [MKBXDInterface bxd_readSinglePressEventCountWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.singleCount = returnData[@"result"][@"count"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readDoubleCount {
    __block BOOL success = NO;
    [MKBXDInterface bxd_readDoublePressEventCountWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.doubleCount = returnData[@"result"][@"count"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readLongCount {
    __block BOOL success = NO;
    [MKBXDInterface bxd_readLongPressEventCountWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.longCount = returnData[@"result"][@"count"];
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

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z"];
    }
    return _dateFormatter;
}

@end
