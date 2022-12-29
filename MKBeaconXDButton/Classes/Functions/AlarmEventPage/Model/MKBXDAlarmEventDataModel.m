//
//  MKBXDAlarmEventDataModel.m
//  MKBeaconXDButton_Example
//
//  Created by aa on 2022/2/22.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXDAlarmEventDataModel.h"

#import "MKMacroDefines.h"

#import "MKBXDInterface.h"

@interface MKBXDAlarmEventDataModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKBXDAlarmEventDataModel

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
    [MKBXDInterface bxd_readDeviceTimeWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:([returnData[@"result"][@"timestamp"] longLongValue] / 1000.0)];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss.SSS"];
        NSString *tempValue = [formatter stringFromDate:date];
        NSArray *tempList = [tempValue componentsSeparatedByString:@" "];
        self.timestamp = [NSString stringWithFormat:@"%@T%@Z",tempList[0],tempList[1]];
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

@end
