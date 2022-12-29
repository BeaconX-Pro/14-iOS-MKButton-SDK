//
//  MKBXDCentralManager.m
//  MKBeaconXDButton_Example
//
//  Created by aa on 2022/2/18.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXDCentralManager.h"

#import "MKBLEBaseCentralManager.h"
#import "MKBLEBaseSDKDefines.h"
#import "MKBLEBaseSDKAdopter.h"
#import "MKBLEBaseLogManager.h"

#import "MKBXDPeripheral.h"
#import "MKBXDOperation.h"
#import "MKBXDTaskAdopter.h"
#import "MKBXDAdopter.h"
#import "CBPeripheral+MKBXDAdd.h"
#import "MKBXDBaseAdvModel.h"

NSString *const mk_bxd_peripheralConnectStateChangedNotification = @"mk_bxd_peripheralConnectStateChangedNotification";
NSString *const mk_bxd_centralManagerStateChangedNotification = @"mk_bxd_centralManagerStateChangedNotification";

NSString *const mk_bxd_deviceDisconnectTypeNotification = @"mk_bxd_deviceDisconnectTypeNotification";

NSString *const mk_bxd_receiveAlarmEventDataNotification = @"mk_bxd_receiveAlarmEventDataNotification";

NSString *const mk_bxd_receiveThreeAxisDataNotification = @"mk_bxd_receiveThreeAxisDataNotification";


static MKBXDCentralManager *manager = nil;
static dispatch_once_t onceToken;

//@interface NSObject (MKBXDCentralManager)
//
//@end
//
//@implementation NSObject (MKBXDCentralManager)
//
//+ (void)load{
//    [MKBXDCentralManager shared];
//}
//
//@end

@interface MKBXDCentralManager ()

@property (nonatomic, assign)mk_bxd_centralConnectStatus connectStatus;

@property (nonatomic, copy)void (^sucBlock)(CBPeripheral *peripheral);

@property (nonatomic, copy)void (^failedBlock)(NSError *error);

@property (nonatomic, copy)void (^needPasswordBlock)(NSDictionary *result);

@property (nonatomic, copy)NSString *password;

@property (nonatomic, assign)BOOL readingNeedPassword;

@end

@implementation MKBXDCentralManager

- (instancetype)init {
    if (self = [super init]) {
        [[MKBLEBaseCentralManager shared] loadDataManager:self];
    }
    return self;
}

+ (MKBXDCentralManager *)shared {
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [MKBXDCentralManager new];
        }
    });
    return manager;
}

+ (void)sharedDealloc {
    [MKBLEBaseCentralManager singleDealloc];
    manager = nil;
    onceToken = 0;
}

+ (void)removeFromCentralList {
    [[MKBLEBaseCentralManager shared] removeDataManager:manager];
    manager = nil;
    onceToken = 0;
}

#pragma mark - MKBLEBaseScanProtocol
- (void)MKBLEBaseCentralManagerDiscoverPeripheral:(CBPeripheral *)peripheral
                                advertisementData:(NSDictionary<NSString *,id> *)advertisementData
                                             RSSI:(NSNumber *)RSSI {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"%@",advertisementData);
        NSArray *deviceList = [MKBXDBaseAdvModel parseAdvData:advertisementData
                                                   peripheral:peripheral
                                                         RSSI:RSSI];
        if (!MKValidArray(deviceList)) {
            return;
        }
        if ([self.delegate respondsToSelector:@selector(mk_bxd_receiveAdvData:)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate mk_bxd_receiveAdvData:deviceList];
            });
        }
    });
}

- (void)MKBLEBaseCentralManagerStartScan {
    if ([self.delegate respondsToSelector:@selector(mk_bxd_startScan)]) {
        [self.delegate mk_bxd_startScan];
    }
}

- (void)MKBLEBaseCentralManagerStopScan {
    if ([self.delegate respondsToSelector:@selector(mk_bxd_stopScan)]) {
        [self.delegate mk_bxd_stopScan];
    }
}

#pragma mark - MKBLEBaseCentralManagerStateProtocol
- (void)MKBLEBaseCentralManagerStateChanged:(MKCentralManagerState)centralManagerState {
    [[NSNotificationCenter defaultCenter] postNotificationName:mk_bxd_centralManagerStateChangedNotification object:nil];
}

- (void)MKBLEBasePeripheralConnectStateChanged:(MKPeripheralConnectState)connectState {
    if (self.readingNeedPassword) {
        //正在读取lockState的时候不对连接状态做出回调
        return;
    }
    //连接成功的判断必须是发送密码成功之后
    if (connectState == MKPeripheralConnectStateUnknow) {
        self.connectStatus = mk_bxd_centralConnectStatusUnknow;
    }else if (connectState == MKPeripheralConnectStateConnecting) {
        self.connectStatus = mk_bxd_centralConnectStatusConnecting;
    }else if (connectState == MKPeripheralConnectStateDisconnect) {
        self.connectStatus = mk_bxd_centralConnectStatusDisconnect;
    }else if (connectState == MKPeripheralConnectStateConnectedFailed) {
        self.connectStatus = mk_bxd_centralConnectStatusConnectedFailed;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:mk_bxd_peripheralConnectStateChangedNotification object:nil];
}

#pragma mark - MKBLEBaseCentralManagerProtocol
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        NSLog(@"+++++++++++++++++接收数据出错");
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA02"]]) {
        //引起设备断开连接的类型
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:characteristic.value];
        [[NSNotificationCenter defaultCenter] postNotificationName:mk_bxd_deviceDisconnectTypeNotification
                                                            object:nil
                                                          userInfo:@{@"type":[content substringWithRange:NSMakeRange(8, 2)]}];
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA03"]]
        || [characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA04"]]
        || [characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA05"]]) {
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:characteristic.value];
        if (content.length != 26) {
            return;
        }
        NSString *timestamp = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(8, 16)];
        NSString *alarmType = [content substringWithRange:NSMakeRange(24, 2)];
        [[NSNotificationCenter defaultCenter] postNotificationName:mk_bxd_receiveAlarmEventDataNotification
                                                            object:nil
                                                          userInfo:@{@"timestamp":timestamp,
                                                                     @"alarmType":alarmType,
                                                                   }];
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA06"]]) {
        //三轴数据
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:characteristic.value];
        NSNumber *xData = [MKBLEBaseSDKAdopter signedHexTurnString:[content substringWithRange:NSMakeRange(8, 4)]];
        NSString *xDataString = [NSString stringWithFormat:@"%ld",(long)[xData integerValue]];
        NSNumber *yData = [MKBLEBaseSDKAdopter signedHexTurnString:[content substringWithRange:NSMakeRange(12, 4)]];
        NSString *yDataString = [NSString stringWithFormat:@"%ld",(long)[yData integerValue]];
        NSNumber *zData = [MKBLEBaseSDKAdopter signedHexTurnString:[content substringWithRange:NSMakeRange(16, 4)]];
        NSString *zDataString = [NSString stringWithFormat:@"%ld",(long)[zData integerValue]];
        [[NSNotificationCenter defaultCenter] postNotificationName:mk_bxd_receiveThreeAxisDataNotification
                                                            object:nil
                                                          userInfo:@{@"x-Data":xDataString,
                                                                     @"y-Data":yDataString,
                                                                     @"z-Data":zDataString,
                                                                   }];
        return;
    }
}
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    if (error) {
        NSLog(@"+++++++++++++++++发送数据出错");
        return;
    }
    
}

#pragma mark - public method
- (CBCentralManager *)centralManager {
    return [MKBLEBaseCentralManager shared].centralManager;
}

- (CBPeripheral *)peripheral {
    return [MKBLEBaseCentralManager shared].peripheral;
}

- (mk_bxd_centralManagerStatus )centralStatus {
    return ([MKBLEBaseCentralManager shared].centralStatus == MKCentralManagerStateEnable)
    ? mk_bxd_centralManagerStatusEnable
    : mk_bxd_centralManagerStatusUnable;
}

- (void)startScan {
    [[MKBLEBaseCentralManager shared] scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:@"FEE0"],
                                                                       [CBUUID UUIDWithString:@"EA00"]]
                                                             options:nil];
}

- (void)stopScan {
    [[MKBLEBaseCentralManager shared] stopScan];
}

- (void)readNeedPasswordWithPeripheral:(nonnull CBPeripheral *)peripheral
                              sucBlock:(void (^)(NSDictionary *result))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    if (self.readingNeedPassword) {
        [self operationFailedBlockWithMsg:@"Device is busy now" failedBlock:failedBlock];
        return;
    }
    self.readingNeedPassword = YES;
    self.needPasswordBlock = nil;
    self.failedBlock = nil;
    self.failedBlock = failedBlock;
    __weak typeof(self) weakSelf = self;
    self.needPasswordBlock = ^(NSDictionary *result) {
        __strong typeof(self) sself = weakSelf;
        if (!MKValidDict(result)) {
            [sself clearAllParams];
            [self operationFailedBlockWithMsg:@"Read Error" failedBlock:failedBlock];
            return;
        }
        [sself clearAllParams];
        if (sucBlock) {
            MKBLEBase_main_safe(^{sucBlock(result);});
        }
    };
    MKBXDPeripheral *bxdPeripheral = [[MKBXDPeripheral alloc] initWithPeripheral:peripheral];
    [[MKBLEBaseCentralManager shared] connectDevice:bxdPeripheral sucBlock:^(CBPeripheral * _Nonnull peripheral) {
        [self confirmNeedPassword];
    } failedBlock:^(NSError * _Nonnull error) {
        __strong typeof(self) sself = weakSelf;
        [sself clearAllParams];
        if (failedBlock) {
            failedBlock(error);
        }
    }];
}

- (void)connectPeripheral:(CBPeripheral *)peripheral
                 password:(NSString *)password
                 sucBlock:(void (^)(CBPeripheral * _Nonnull))sucBlock
              failedBlock:(void (^)(NSError * error))failedBlock {
    if (!peripheral) {
        [MKBLEBaseSDKAdopter operationConnectFailedBlock:failedBlock];
        return;
    }
    if (!MKValidStr(password) || password.length > 16 || ![MKBLEBaseSDKAdopter asciiString:password]) {
        [self operationFailedBlockWithMsg:@"The password should be no more than 16 characters." failedBlock:failedBlock];
        return;
    }
    self.password = @"";
    self.password = password;
    __weak typeof(self) weakSelf = self;
    [self connectPeripheral:peripheral successBlock:^(CBPeripheral *peripheral) {
        __strong typeof(self) sself = weakSelf;
        sself.sucBlock = nil;
        sself.failedBlock = nil;
        if (sucBlock) {
            sucBlock(peripheral);
        }
    } failedBlock:^(NSError *error) {
        __strong typeof(self) sself = weakSelf;
        sself.sucBlock = nil;
        sself.failedBlock = nil;
        if (failedBlock) {
            failedBlock(error);
        }
    }];
}

- (void)connectPeripheral:(nonnull CBPeripheral *)peripheral
                 sucBlock:(void (^)(CBPeripheral *peripheral))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock {
    if (!peripheral) {
        [MKBLEBaseSDKAdopter operationConnectFailedBlock:failedBlock];
        return;
    }
    self.password = @"";
    __weak typeof(self) weakSelf = self;
    [self connectPeripheral:peripheral successBlock:^(CBPeripheral *peripheral) {
        __strong typeof(self) sself = weakSelf;
        sself.sucBlock = nil;
        sself.failedBlock = nil;
        if (sucBlock) {
            sucBlock(peripheral);
        }
    } failedBlock:^(NSError *error) {
        __strong typeof(self) sself = weakSelf;
        sself.sucBlock = nil;
        sself.failedBlock = nil;
        if (failedBlock) {
            failedBlock(error);
        }
    }];
}

- (void)disconnect {
    [[MKBLEBaseCentralManager shared] disconnect];
}

- (void)addTaskWithTaskID:(mk_bxd_taskOperationID)operationID
           characteristic:(CBCharacteristic *)characteristic
              commandData:(NSString *)commandData
             successBlock:(void (^)(id returnData))successBlock
             failureBlock:(void (^)(NSError *error))failureBlock {
    MKBXDOperation <MKBLEBaseOperationProtocol>*operation = [self generateOperationWithOperationID:operationID
                                                                                    characteristic:characteristic
                                                                                       commandData:commandData
                                                                                      successBlock:successBlock
                                                                                      failureBlock:failureBlock];
    if (!operation) {
        return;
    }
    [[MKBLEBaseCentralManager shared] addOperation:operation];
}

- (void)addReadTaskWithTaskID:(mk_bxd_taskOperationID)operationID
               characteristic:(CBCharacteristic *)characteristic
                 successBlock:(void (^)(id returnData))successBlock
                 failureBlock:(void (^)(NSError *error))failureBlock {
    MKBXDOperation <MKBLEBaseOperationProtocol>*operation = [self generateReadOperationWithOperationID:operationID
                                                                                        characteristic:characteristic
                                                                                          successBlock:successBlock
                                                                                          failureBlock:failureBlock];
    if (!operation) {
        return;
    }
    [[MKBLEBaseCentralManager shared] addOperation:operation];
}

- (BOOL)notifySinglePressEventData:(BOOL)notify {
    if (self.connectStatus != mk_bxd_centralConnectStatusConnected || self.peripheral == nil || self.peripheral.bxd_singleAlarmData == nil) {
        return NO;
    }
    [self.peripheral setNotifyValue:notify forCharacteristic:self.peripheral.bxd_singleAlarmData];
    return YES;
}

- (BOOL)notifyDoublePressEventData:(BOOL)notify {
    if (self.connectStatus != mk_bxd_centralConnectStatusConnected || self.peripheral == nil || self.peripheral.bxd_doubleAlarmData == nil) {
        return NO;
    }
    [self.peripheral setNotifyValue:notify forCharacteristic:self.peripheral.bxd_doubleAlarmData];
    return YES;
}

- (BOOL)notifyLongPressEventData:(BOOL)notify {
    if (self.connectStatus != mk_bxd_centralConnectStatusConnected || self.peripheral == nil || self.peripheral.bxd_longAlarmData == nil) {
        return NO;
    }
    [self.peripheral setNotifyValue:notify forCharacteristic:self.peripheral.bxd_longAlarmData];
    return YES;
}

- (BOOL)notifyThreeAxisData:(BOOL)notify {
    if (self.connectStatus != mk_bxd_centralConnectStatusConnected || self.peripheral == nil || self.peripheral.bxd_threeAxisData == nil) {
        return NO;
    }
    [self.peripheral setNotifyValue:notify forCharacteristic:self.peripheral.bxd_threeAxisData];
    return YES;
}

#pragma mark - password method
- (void)connectPeripheral:(CBPeripheral *)peripheral
             successBlock:(void (^)(CBPeripheral *peripheral))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock {
    self.sucBlock = nil;
    self.sucBlock = sucBlock;
    self.failedBlock = nil;
    self.failedBlock = failedBlock;
    MKBXDPeripheral *bxdPeripheral = [[MKBXDPeripheral alloc] initWithPeripheral:peripheral];
    [[MKBLEBaseCentralManager shared] connectDevice:bxdPeripheral sucBlock:^(CBPeripheral * _Nonnull peripheral) {
        if (MKValidStr(self.password) && self.password.length <= 16) {
            //需要密码登录
            [self sendPasswordToDevice];
            return;
        }
        //免密登录
        MKBLEBase_main_safe(^{
            self.connectStatus = mk_bxd_centralConnectStatusConnected;
            [[NSNotificationCenter defaultCenter] postNotificationName:mk_bxd_peripheralConnectStateChangedNotification object:nil];
            if (self.sucBlock) {
                self.sucBlock(peripheral);
            }
        });
    } failedBlock:failedBlock];
}

- (void)sendPasswordToDevice {
    NSString *lenString = [NSString stringWithFormat:@"%1lx",(long)self.password.length];
    if (lenString.length == 1) {
        lenString = [@"0" stringByAppendingString:lenString];
    }
    NSString *commandData = [@"ea0155" stringByAppendingString:lenString];
    for (NSInteger i = 0; i < self.password.length; i ++) {
        int asciiCode = [self.password characterAtIndex:i];
        commandData = [commandData stringByAppendingString:[NSString stringWithFormat:@"%1lx",(unsigned long)asciiCode]];
    }
    __weak typeof(self) weakSelf = self;
    MKBXDOperation *operation = [[MKBXDOperation alloc] initOperationWithID:mk_bxd_connectPasswordOperation commandBlock:^{
        [[MKBLEBaseCentralManager shared] sendDataToPeripheral:commandData characteristic:[MKBLEBaseCentralManager shared].peripheral.bxd_password type:CBCharacteristicWriteWithResponse];
    } completeBlock:^(NSError * _Nullable error, id  _Nullable returnData) {
        __strong typeof(self) sself = weakSelf;
        if (error || !MKValidDict(returnData) || ![returnData[@"success"] boolValue]) {
            //密码错误
            [sself operationFailedBlockWithMsg:@"Password Error" failedBlock:sself.failedBlock];
            return ;
        }
        //密码正确
        MKBLEBase_main_safe(^{
            sself.connectStatus = mk_bxd_centralConnectStatusConnected;
            [[NSNotificationCenter defaultCenter] postNotificationName:mk_bxd_peripheralConnectStateChangedNotification object:nil];
            if (sself.sucBlock) {
                sself.sucBlock([MKBLEBaseCentralManager shared].peripheral);
            }
        });
    }];
    [[MKBLEBaseCentralManager shared] addOperation:operation];
}

- (void)confirmNeedPassword {
    NSString *commandData = @"ea002300";
    __weak typeof(self) weakSelf = self;
    MKBXDOperation *operation = [[MKBXDOperation alloc] initOperationWithID:mk_bxd_taskReadNeedPasswordOperation commandBlock:^{
        [[MKBLEBaseCentralManager shared] sendDataToPeripheral:commandData characteristic:[MKBLEBaseCentralManager shared].peripheral.bxd_password type:CBCharacteristicWriteWithResponse];
    } completeBlock:^(NSError * _Nullable error, id  _Nullable returnData) {
        __strong typeof(self) sself = weakSelf;
        //读取成功
        MKBLEBase_main_safe(^{
            if (sself.needPasswordBlock) {
                sself.needPasswordBlock(returnData);
            }
        });
    }];
    [[MKBLEBaseCentralManager shared] addOperation:operation];
}

#pragma mark - task method
- (MKBXDOperation <MKBLEBaseOperationProtocol>*)generateOperationWithOperationID:(mk_bxd_taskOperationID)operationID
                                                                  characteristic:(CBCharacteristic *)characteristic
                                                                     commandData:(NSString *)commandData
                                                                    successBlock:(void (^)(id returnData))successBlock
                                                                    failureBlock:(void (^)(NSError *error))failureBlock{
    if (![[MKBLEBaseCentralManager shared] readyToCommunication]) {
        [self operationFailedBlockWithMsg:@"The current connection device is in disconnect" failedBlock:failureBlock];
        return nil;
    }
    if (!MKValidStr(commandData)) {
        [self operationFailedBlockWithMsg:@"The data sent to the device cannot be empty" failedBlock:failureBlock];
        return nil;
    }
    if (!characteristic) {
        [self operationFailedBlockWithMsg:@"Characteristic error" failedBlock:failureBlock];
        return nil;
    }
    __weak typeof(self) weakSelf = self;
    MKBXDOperation <MKBLEBaseOperationProtocol>*operation = [[MKBXDOperation alloc] initOperationWithID:operationID commandBlock:^{
        [[MKBLEBaseCentralManager shared] sendDataToPeripheral:commandData characteristic:characteristic type:CBCharacteristicWriteWithResponse];
    } completeBlock:^(NSError * _Nullable error, id  _Nullable returnData) {
        __strong typeof(self) sself = weakSelf;
        if (error) {
            MKBLEBase_main_safe(^{
                if (failureBlock) {
                    failureBlock(error);
                }
            });
            return ;
        }
        if (!returnData) {
            [sself operationFailedBlockWithMsg:@"Request data error" failedBlock:failureBlock];
            return ;
        }
        NSDictionary *resultDic = @{@"msg":@"success",
                                    @"code":@"1",
                                    @"result":returnData,
                                    };
        MKBLEBase_main_safe(^{
            if (successBlock) {
                successBlock(resultDic);
            }
        });
    }];
    return operation;
}

- (MKBXDOperation <MKBLEBaseOperationProtocol>*)generateReadOperationWithOperationID:(mk_bxd_taskOperationID)operationID
                                                                      characteristic:(CBCharacteristic *)characteristic
                                                                        successBlock:(void (^)(id returnData))successBlock
                                                                        failureBlock:(void (^)(NSError *error))failureBlock{
    if (![[MKBLEBaseCentralManager shared] readyToCommunication]) {
        [self operationFailedBlockWithMsg:@"The current connection device is in disconnect" failedBlock:failureBlock];
        return nil;
    }
    if (!characteristic) {
        [self operationFailedBlockWithMsg:@"Characteristic error" failedBlock:failureBlock];
        return nil;
    }
    __weak typeof(self) weakSelf = self;
    MKBXDOperation <MKBLEBaseOperationProtocol>*operation = [[MKBXDOperation alloc] initOperationWithID:operationID commandBlock:^{
        [[MKBLEBaseCentralManager shared].peripheral readValueForCharacteristic:characteristic];
    } completeBlock:^(NSError * _Nullable error, id  _Nullable returnData) {
        __strong typeof(self) sself = weakSelf;
        if (error) {
            MKBLEBase_main_safe(^{
                if (failureBlock) {
                    failureBlock(error);
                }
            });
            return ;
        }
        if (!returnData) {
            [sself operationFailedBlockWithMsg:@"Request data error" failedBlock:failureBlock];
            return ;
        }
        NSDictionary *resultDic = @{@"msg":@"success",
                                    @"code":@"1",
                                    @"result":returnData,
                                    };
        MKBLEBase_main_safe(^{
            if (successBlock) {
                successBlock(resultDic);
            }
        });
    }];
    return operation;
}

- (void)clearAllParams {
    self.sucBlock = nil;
    self.failedBlock = nil;
    if (!self.needPasswordBlock) {
        return;
    }
    //读取是否需要密码
    [self disconnect];
    self.needPasswordBlock = nil;
    self.readingNeedPassword = NO;
}

- (void)operationFailedBlockWithMsg:(NSString *)message failedBlock:(void (^)(NSError *error))failedBlock {
    NSError *error = [[NSError alloc] initWithDomain:@"com.moko.BXDCentralManager"
                                                code:-999
                                            userInfo:@{@"errorInfo":message}];
    MKBLEBase_main_safe(^{
        if (failedBlock) {
            failedBlock(error);
        }
    });
}

@end
