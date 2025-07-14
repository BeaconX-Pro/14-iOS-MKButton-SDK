//
//  MKBXDOperation.m
//  MKBeaconXDButton_Example
//
//  Created by aa on 2022/2/18.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXDOperation.h"

#import <CoreBluetooth/CoreBluetooth.h>

#import "MKBXDBaseDataProtocol.h"

#import "MKBXDTaskAdopter.h"

@interface MKBXDOperation ()

/**
 超过2s没有接收到新的数据，超时
 */
@property (nonatomic, strong)dispatch_source_t receiveTimer;

/**
 线程ID
 */
@property (nonatomic, assign)mk_bxd_taskOperationID operationID;

/**
 线程结束时候的回调
 */
@property (nonatomic, copy)void (^completeBlock) (NSError *error, id returnData);

@property (nonatomic, copy)void (^commandBlock)(void);

/**
 超时标志
 */
@property (nonatomic, assign)BOOL timeout;

/**
 接受数据超时个数
 */
@property (nonatomic, assign)NSInteger receiveTimerCount;

@end

@implementation MKBXDOperation

#pragma mark - life circle

- (void)dealloc{
    NSLog(@"BXD任务销毁");
}

- (instancetype)initOperationWithID:(mk_bxd_taskOperationID)operationID
                       commandBlock:(void (^)(void))commandBlock
                      completeBlock:(void (^)(NSError * _Nullable error, id _Nullable returnData))completeBlock {
    if (self = [super init]) {
        _completeBlock = completeBlock;
        _commandBlock = commandBlock;
        _operationID = operationID;
    }
    return self;
}

#pragma mark - Public Methods
- (void)didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic {
    [self dataParserReceivedData:[MKBXDTaskAdopter parseReadDataWithCharacteristic:characteristic]];
}

- (void)didWriteValueForCharacteristic:(CBCharacteristic *)characteristic {
    [self dataParserReceivedData:[MKBXDTaskAdopter parseWriteDataWithCharacteristic:characteristic]];
}

- (void)startCommunication{
    if (self.commandBlock) {
        self.commandBlock();
    }
    [self startReceiveTimer];
}

/**
 如果需要从外设拿总条数，则在拿到总条数之后，开启接受超时定时器，开启定时器的时候已经设置了当前线程的生命周期，所以不需要重新beforeDate了。如果是直接开启的接收超时定时器，这个时候需要控制当前线程的生命周期
 
 */
- (void)startReceiveTimer{
    __weak __typeof(&*self)weakSelf = self;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.receiveTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //当2s内没有接收到新的数据的时候，也认为是接受超时
    dispatch_source_set_timer(self.receiveTimer, dispatch_walltime(NULL, 0), 0.1 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(self.receiveTimer, ^{
        __strong typeof(self) sself = weakSelf;
        if (sself.timeout || sself.receiveTimerCount >= 15) {
            //接受数据超时
            sself.receiveTimerCount = 0;
            [sself communicationTimeout];
            return ;
        }
        sself.receiveTimerCount ++;
    });
    dispatch_resume(self.receiveTimer);
}

- (void)communicationTimeout{
    self.timeout = YES;
    if (self.receiveTimer) {
        dispatch_cancel(self.receiveTimer);
    }
    if (self.completeBlock) {
        NSError *error = [[NSError alloc] initWithDomain:@"com.moko.operationError"
                                                    code:-999
                                                userInfo:@{@"errorInfo":@"Communication timeout"}];
        self.completeBlock(error, nil);
    }
}

- (void)dataParserReceivedData:(NSDictionary *)dataDic{
    if (![dataDic isKindOfClass:NSDictionary.class] || self.timeout) {
        return;
    }
    mk_bxd_taskOperationID operationID = [dataDic[@"operationID"] integerValue];
    if (operationID == mk_bxd_defaultTaskOperationID || operationID != self.operationID) {
        return;
    }
    NSDictionary *returnData = dataDic[@"returnData"];
    if (![returnData isKindOfClass:NSDictionary.class]) {
        return;
    }
    if (self.receiveTimer) {
        dispatch_cancel(self.receiveTimer);
    }
    //接受数据成功
    if (self.completeBlock) {
        self.completeBlock(nil, returnData);
    }
}

@end
