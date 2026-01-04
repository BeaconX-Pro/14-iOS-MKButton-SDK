//
//  MKBXDCentralManager.m
//  MKBeaconXDButton_Example
//
//  Created by aa on 2022/2/18.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXDCentralManager.h"

#import "MKBXDBaseCentralManager.h"
#import "MKBXDBaseSDKAdopter.h"
#import "MKBXDBaseLogManager.h"

#import "MKBXDPeripheral.h"
#import "MKBXDOperation.h"
#import "MKBXDTaskAdopter.h"
#import "MKBXDAdopter.h"
#import "CBPeripheral+MKBXDAdd.h"
#import "MKBXDBaseAdvModel.h"

static NSString *const mk_bxp_button_d_logName = @"mk_bxp_button_d_log";

NSString *const mk_bxd_peripheralConnectStateChangedNotification = @"mk_bxd_peripheralConnectStateChangedNotification";
NSString *const mk_bxd_centralManagerStateChangedNotification = @"mk_bxd_centralManagerStateChangedNotification";

NSString *const mk_bxd_deviceDisconnectTypeNotification = @"mk_bxd_deviceDisconnectTypeNotification";

NSString *const mk_bxd_receiveLongConnectionModeDataNotification = @"mk_bxd_receiveLongConnectionModeDataNotification";

NSString *const mk_bxd_receiveThreeAxisDataNotification = @"mk_bxd_receiveThreeAxisDataNotification";

NSString *const mk_bxd_receiveSubClickDataNotification = @"mk_bxd_receiveSubClickDataNotification";

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

@property (nonatomic, strong)NSMutableArray *operationList;

@property (nonatomic, assign)BOOL isAction;

@end

@implementation MKBXDCentralManager

- (void)dealloc {
    [self logToLocal:@"MKBXDCentralManager销毁"];
    NSLog(@"MKBXDCentralManager销毁");
}

- (instancetype)init {
    if (self = [super init]) {
        [self logToLocal:@"MKBXDCentralManager初始化"];
        [[MKBXDBaseCentralManager shared] loadDataManager:self];
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
    [MKBXDBaseCentralManager singleDealloc];
    manager = nil;
    onceToken = 0;
}

+ (void)removeFromCentralList {
    [[MKBXDBaseCentralManager shared] removeDataManager];
    manager = nil;
    onceToken = 0;
}

#pragma mark - MKBXDScanProtocol
- (void)MKBXDCentralManagerDiscoverPeripheral:(CBPeripheral *)peripheral
                                advertisementData:(NSDictionary<NSString *,id> *)advertisementData
                                             RSSI:(NSNumber *)RSSI {
    NSArray *deviceList = [MKBXDBaseAdvModel parseAdvData:advertisementData
                                               peripheral:peripheral
                                                     RSSI:RSSI];
    for (NSInteger i = 0; i < deviceList.count; i ++) {
        MKBXDBaseAdvModel *beaconModel = deviceList[i];
        beaconModel.identifier = peripheral.identifier.UUIDString;
        beaconModel.rssi = RSSI;
        beaconModel.peripheral = peripheral;
        beaconModel.deviceName = advertisementData[CBAdvertisementDataLocalNameKey];
        beaconModel.connectEnable = [advertisementData[CBAdvertisementDataIsConnectable] boolValue];
    }
    if (deviceList.count == 0) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(mk_bxd_receiveAdvData:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate mk_bxd_receiveAdvData:deviceList];
        });
    }
}

- (void)MKBXDCentralManagerStartScan {
    [self logToLocal:@"开始扫描"];
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(mk_bxd_startScan)]) {
            [self.delegate mk_bxd_startScan];
        }
    });
}

- (void)MKBXDCentralManagerStopScan {
    [self logToLocal:@"停止扫描"];
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(mk_bxd_stopScan)]) {
            [self.delegate mk_bxd_stopScan];
        }
    });
}

#pragma mark - MKBXDCentralManagerStateProtocol
- (void)MKBXDCentralManagerStateChanged:(MKBXDCentralManagerState)centralManagerState {
    NSString *string = [NSString stringWithFormat:@"蓝牙中心改变:%@",@(centralManagerState)];
    [self.operationList removeAllObjects];
    self.isAction = NO;
    [self logToLocal:string];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:mk_bxd_centralManagerStateChangedNotification object:nil];
    });
}

- (void)MKBXDPeripheralConnectStateChanged:(MKBXDPeripheralConnectState)connectState {
    [self.operationList removeAllObjects];
    self.isAction = NO;
    if (self.readingNeedPassword) {
        //正在读取lockState的时候不对连接状态做出回调
        return;
    }
    //连接成功的判断必须是发送密码成功之后
    if (connectState == MKBXDPeripheralConnectStateUnknow) {
        self.connectStatus = mk_bxd_centralConnectStatusUnknow;
    }else if (connectState == MKBXDPeripheralConnectStateConnecting) {
        self.connectStatus = mk_bxd_centralConnectStatusConnecting;
    }else if (connectState == MKBXDPeripheralConnectStateDisconnect) {
        self.connectStatus = mk_bxd_centralConnectStatusDisconnect;
    }else if (connectState == MKBXDPeripheralConnectStateConnectedFailed) {
        self.connectStatus = mk_bxd_centralConnectStatusConnectedFailed;
    }
    NSString *string = [NSString stringWithFormat:@"连接状态发生改变:%@",@(connectState)];
    [self logToLocal:string];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:mk_bxd_peripheralConnectStateChangedNotification object:nil];
    });
}

#pragma mark - MKBXDCentralManagerProtocol
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        NSLog(@"+++++++++++++++++接收数据出错");
        return;
    }
    NSString *content = [MKBXDBaseSDKAdopter hexStringFromData:characteristic.value];
    NSLog(@"%@-%@",characteristic.UUID.UUIDString,content);
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA03"]] || [characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA04"]] || [characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA05"]] || [characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA09"]]) {
        //单击数据/双击数据/长按数据/长连接模式数据/副按键数据
        NSString *alarmType = @"0";
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA03"]]) {
            alarmType = @"0";
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA04"]]) {
            alarmType = @"1";
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA05"]]) {
            alarmType = @"2";
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA09"]]) {
            alarmType = @"3";
        }else {
            alarmType = @"4";
        }
        NSString *content = [MKBXDBaseSDKAdopter hexStringFromData:characteristic.value];
        NSDictionary *dic = @{
            @"alarmType":alarmType,
            @"content":[content substringFromIndex:8]
        };
        if ([self.eventDelegate respondsToSelector:@selector(mk_bxd_receiveAlarmEventData:)]) {
            [self.eventDelegate mk_bxd_receiveAlarmEventData:dic];
        }
        return;
    }
    
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA02"]]) {
        //引起设备断开连接的类型
        NSString *content = [MKBXDBaseSDKAdopter hexStringFromData:characteristic.value];
        [self saveToLogData:content appToDevice:NO];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:mk_bxd_deviceDisconnectTypeNotification
                                                                object:nil
                                                              userInfo:@{@"type":[content substringWithRange:NSMakeRange(8, 2)]}];
        });
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA06"]]) {
        //三轴数据
        NSString *content = [MKBXDBaseSDKAdopter hexStringFromData:characteristic.value];
        [self saveToLogData:content appToDevice:NO];
        NSNumber *xData = [MKBXDBaseSDKAdopter signedHexTurnString:[content substringWithRange:NSMakeRange(8, 4)]];
        NSString *xDataString = [NSString stringWithFormat:@"%ld",(long)[xData integerValue]];
        NSNumber *yData = [MKBXDBaseSDKAdopter signedHexTurnString:[content substringWithRange:NSMakeRange(12, 4)]];
        NSString *yDataString = [NSString stringWithFormat:@"%ld",(long)[yData integerValue]];
        NSNumber *zData = [MKBXDBaseSDKAdopter signedHexTurnString:[content substringWithRange:NSMakeRange(16, 4)]];
        NSString *zDataString = [NSString stringWithFormat:@"%ld",(long)[zData integerValue]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:mk_bxd_receiveThreeAxisDataNotification
                                                                object:nil
                                                              userInfo:@{@"x-Data":xDataString,
                                                                         @"y-Data":yDataString,
                                                                         @"z-Data":zDataString,
                                                                       }];
        });
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA08"]]) {
        NSString *content = [MKBXDBaseSDKAdopter hexStringFromData:characteristic.value];
        [self saveToLogData:content appToDevice:NO];
        //长连接按键触发次数
        NSString *count = [MKBXDBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(8, 2)];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:mk_bxd_receiveLongConnectionModeDataNotification
                                                                object:nil
                                                              userInfo:@{@"count":count,
                                                                       }];
        });
        return;
    }
    
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA0A"]]) {
        NSString *content = [MKBXDBaseSDKAdopter hexStringFromData:characteristic.value];
        [self saveToLogData:content appToDevice:NO];
        //副按键触发次数
        NSString *count = [MKBXDBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(8, 2)];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:mk_bxd_receiveSubClickDataNotification
                                                                object:nil
                                                              userInfo:@{@"count":count,
                                                                       }];
        });
        return;
    }
    
    if (self.operationList.count == 0 || !self.isAction) {
        return;
    }
    MKBXDOperation *currentOperation = self.operationList[0];
    [currentOperation didUpdateValueForCharacteristic:characteristic];
}
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    if (error) {
        NSLog(@"+++++++++++++++++发送数据出错");
        [self logToLocal:@"发送数据出错"];
        return;
    }
    
}

#pragma mark - public method
- (CBCentralManager *)centralManager {
    return [MKBXDBaseCentralManager shared].centralManager;
}

- (CBPeripheral *)peripheral {
    return [MKBXDBaseCentralManager shared].peripheral;
}

- (mk_bxd_centralManagerStatus )centralStatus {
    return ([MKBXDBaseCentralManager shared].centralStatus == MKBXDCentralManagerStateEnable)
    ? mk_bxd_centralManagerStatusEnable
    : mk_bxd_centralManagerStatusUnable;
}

- (void)startScan {
    [[MKBXDBaseCentralManager shared] scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:@"FEAA"],
                                                                       [CBUUID UUIDWithString:@"FEAB"],
                                                                       [CBUUID UUIDWithString:@"FEE0"],
                                                                       [CBUUID UUIDWithString:@"EA00"]]
                                                             options:nil];
}

- (void)stopScan {
    [[MKBXDBaseCentralManager shared] stopScan];
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
        if (![result isKindOfClass:NSDictionary.class]) {
            [sself clearAllParams];
            [self operationFailedBlockWithMsg:@"Read Error" failedBlock:failedBlock];
            return;
        }
        [sself clearAllParams];
        if (sucBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                sucBlock(result);
            });
        }
    };
    MKBXDPeripheral *bxdPeripheral = [[MKBXDPeripheral alloc] initWithPeripheral:peripheral dfuMode:NO];
    [[MKBXDBaseCentralManager shared] connectDevice:bxdPeripheral sucBlock:^(CBPeripheral * _Nonnull peripheral) {
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
        [MKBXDBaseSDKAdopter operationConnectFailedBlock:failedBlock];
        return;
    }
    if (![password isKindOfClass:NSString.class] || password.length == 0 || password.length > 16 || ![MKBXDBaseSDKAdopter asciiString:password]) {
        [self operationFailedBlockWithMsg:@"The password should be no more than 16 characters." failedBlock:failedBlock];
        return;
    }
    self.password = @"";
    self.password = password;
    __weak typeof(self) weakSelf = self;
    [self connectPeripheral:peripheral dfu:NO successBlock:^(CBPeripheral *peripheral) {
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
        [MKBXDBaseSDKAdopter operationConnectFailedBlock:failedBlock];
        return;
    }
    self.password = @"";
    __weak typeof(self) weakSelf = self;
    [self connectPeripheral:peripheral dfu:NO successBlock:^(CBPeripheral *peripheral) {
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

- (void)dfuconnectPeripheral:(nonnull CBPeripheral *)peripheral
                    sucBlock:(void (^)(CBPeripheral *peripheral))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock {
    if (!peripheral) {
        [MKBXDBaseSDKAdopter operationConnectFailedBlock:failedBlock];
        return;
    }
    self.password = @"";
    __weak typeof(self) weakSelf = self;
    [self connectPeripheral:peripheral dfu:YES successBlock:^(CBPeripheral *peripheral) {
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
    [[MKBXDBaseCentralManager shared] disconnect];
}

- (void)addTaskWithTaskID:(mk_bxd_taskOperationID)operationID
           characteristic:(CBCharacteristic *)characteristic
              commandData:(NSString *)commandData
             successBlock:(void (^)(id returnData))successBlock
             failureBlock:(void (^)(NSError *error))failureBlock {
    MKBXDOperation *operation = [self generateOperationWithOperationID:operationID
                                                        characteristic:characteristic
                                                           commandData:commandData
                                                          successBlock:successBlock
                                                          failureBlock:failureBlock];
    if (!operation) {
        return;
    }
    [self.operationList addObject:operation];
    [self operationAction];
}

- (void)addReadTaskWithTaskID:(mk_bxd_taskOperationID)operationID
               characteristic:(CBCharacteristic *)characteristic
                 successBlock:(void (^)(id returnData))successBlock
                 failureBlock:(void (^)(NSError *error))failureBlock {
    MKBXDOperation *operation = [self generateReadOperationWithOperationID:operationID
                                                            characteristic:characteristic
                                                              successBlock:successBlock
                                                              failureBlock:failureBlock];
    if (!operation) {
        return;
    }
    [self.operationList addObject:operation];
    [self operationAction];
}

- (BOOL)notifySingleClickData:(BOOL)notify {
    if (self.connectStatus != mk_bxd_centralConnectStatusConnected || self.peripheral == nil || self.peripheral.bxd_singleRecord == nil) {
        return NO;
    }
    [self.peripheral setNotifyValue:notify forCharacteristic:self.peripheral.bxd_singleRecord];
    return YES;
}

- (BOOL)notifyDoubleClickData:(BOOL)notify {
    if (self.connectStatus != mk_bxd_centralConnectStatusConnected || self.peripheral == nil || self.peripheral.bxd_doubleRecord == nil) {
        return NO;
    }
    [self.peripheral setNotifyValue:notify forCharacteristic:self.peripheral.bxd_doubleRecord];
    return YES;
}

- (BOOL)notifyLongClickData:(BOOL)notify {
    if (self.connectStatus != mk_bxd_centralConnectStatusConnected || self.peripheral == nil || self.peripheral.bxd_longRecord == nil) {
        return NO;
    }
    [self.peripheral setNotifyValue:notify forCharacteristic:self.peripheral.bxd_longRecord];
    return YES;
}

- (BOOL)notifyLongConnectClickData:(BOOL)notify {
    if (self.connectStatus != mk_bxd_centralConnectStatusConnected || self.peripheral == nil || self.peripheral.bxd_longConnectRecord == nil) {
        return NO;
    }
    [self.peripheral setNotifyValue:notify forCharacteristic:self.peripheral.bxd_longConnectRecord];
    return YES;
}

- (BOOL)notifySubClickData:(BOOL)notify {
    if (self.connectStatus != mk_bxd_centralConnectStatusConnected || self.peripheral == nil || self.peripheral.bxd_subBtnData == nil) {
        return NO;
    }
    [self.peripheral setNotifyValue:notify forCharacteristic:self.peripheral.bxd_subBtnData];
    return YES;
}

- (BOOL)notifyThreeAxisData:(BOOL)notify {
    if (self.connectStatus != mk_bxd_centralConnectStatusConnected || self.peripheral == nil || self.peripheral.bxd_threeAxisData == nil) {
        return NO;
    }
    [self.peripheral setNotifyValue:notify forCharacteristic:self.peripheral.bxd_threeAxisData];
    return YES;
}

- (BOOL)notifyLongConModeData:(BOOL)notify {
    if (self.connectStatus != mk_bxd_centralConnectStatusConnected || self.peripheral == nil || self.peripheral.bxd_longConModeData == nil) {
        return NO;
    }
    [self.peripheral setNotifyValue:notify forCharacteristic:self.peripheral.bxd_longConModeData];
    return YES;
}

#pragma mark - password method
- (void)connectPeripheral:(CBPeripheral *)peripheral
                      dfu:(BOOL)dfu
             successBlock:(void (^)(CBPeripheral *peripheral))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock {
    self.sucBlock = nil;
    self.sucBlock = sucBlock;
    self.failedBlock = nil;
    self.failedBlock = failedBlock;
    MKBXDPeripheral *bxdPeripheral = [[MKBXDPeripheral alloc] initWithPeripheral:peripheral dfuMode:dfu];
    [[MKBXDBaseCentralManager shared] connectDevice:bxdPeripheral sucBlock:^(CBPeripheral * _Nonnull peripheral) {
        if (self.password.length > 0 && self.password.length <= 16) {
            //需要密码登录
            [self logToLocal:@"密码登录"];
            [self sendPasswordToDevice];
            return;
        }
        if (dfu) {
            //免密登录
            [self logToLocal:@"DFU升级"];
        }else {
            //免密登录
            [self logToLocal:@"免密登录"];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
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
        [[MKBXDBaseCentralManager shared] sendDataToPeripheral:commandData characteristic:[MKBXDBaseCentralManager shared].peripheral.bxd_password type:CBCharacteristicWriteWithResponse];
    } completeBlock:^(NSError * _Nullable error, id  _Nullable returnData) {
        __strong typeof(self) sself = weakSelf;
        sself.isAction = NO;
        if (sself.operationList.count > 0) {
            [sself.operationList removeObjectAtIndex:0];
            [sself operationAction];
        }
        if (error || ![returnData isKindOfClass:NSDictionary.class] || ![returnData[@"success"] boolValue]) {
            //密码错误
            [sself operationFailedBlockWithMsg:@"Password Error" failedBlock:sself.failedBlock];
            return ;
        }
        //密码正确
        dispatch_async(dispatch_get_main_queue(), ^{
            sself.connectStatus = mk_bxd_centralConnectStatusConnected;
            [[NSNotificationCenter defaultCenter] postNotificationName:mk_bxd_peripheralConnectStateChangedNotification object:nil];
            if (sself.sucBlock) {
                sself.sucBlock([MKBXDBaseCentralManager shared].peripheral);
            }
        });
    }];
    [self.operationList addObject:operation];
    [self operationAction];
}

- (void)confirmNeedPassword {
    NSString *commandData = @"ea002300";
    __weak typeof(self) weakSelf = self;
    MKBXDOperation *operation = [[MKBXDOperation alloc] initOperationWithID:mk_bxd_taskReadNeedPasswordOperation commandBlock:^{
        [[MKBXDBaseCentralManager shared] sendDataToPeripheral:commandData characteristic:[MKBXDBaseCentralManager shared].peripheral.bxd_password type:CBCharacteristicWriteWithResponse];
    } completeBlock:^(NSError * _Nullable error, id  _Nullable returnData) {
        __strong typeof(self) sself = weakSelf;
        sself.isAction = NO;
        if (sself.operationList.count > 0) {
            [sself.operationList removeObjectAtIndex:0];
            [sself operationAction];
        }
        //读取成功
        dispatch_async(dispatch_get_main_queue(), ^{
            if (sself.needPasswordBlock) {
                sself.needPasswordBlock(returnData);
            }
        });
    }];
    [self.operationList addObject:operation];
    [self operationAction];
}

#pragma mark - task method
- (MKBXDOperation *)generateOperationWithOperationID:(mk_bxd_taskOperationID)operationID
                                      characteristic:(CBCharacteristic *)characteristic
                                         commandData:(NSString *)commandData
                                        successBlock:(void (^)(id returnData))successBlock
                                        failureBlock:(void (^)(NSError *error))failureBlock {
    if (![[MKBXDBaseCentralManager shared] readyToCommunication]) {
        [self operationFailedBlockWithMsg:@"The current connection device is in disconnect" failedBlock:failureBlock];
        return nil;
    }
    if (![commandData isKindOfClass:NSString.class] || commandData.length == 0) {
        [self operationFailedBlockWithMsg:@"The data sent to the device cannot be empty" failedBlock:failureBlock];
        return nil;
    }
    if (!characteristic) {
        [self operationFailedBlockWithMsg:@"Characteristic error" failedBlock:failureBlock];
        return nil;
    }
    __weak typeof(self) weakSelf = self;
    MKBXDOperation *operation = [[MKBXDOperation alloc] initOperationWithID:operationID commandBlock:^{
        [[MKBXDBaseCentralManager shared] sendDataToPeripheral:commandData characteristic:characteristic type:CBCharacteristicWriteWithResponse];
    } completeBlock:^(NSError * _Nullable error, id  _Nullable returnData) {
        __strong typeof(self) sself = weakSelf;
        sself.isAction = NO;
        if (sself.operationList.count > 0) {
            [sself.operationList removeObjectAtIndex:0];
            [sself operationAction];
        }
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
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
        dispatch_async(dispatch_get_main_queue(), ^{
            if (successBlock) {
                successBlock(resultDic);
            }
        });
    }];
    return operation;
}

- (MKBXDOperation *)generateReadOperationWithOperationID:(mk_bxd_taskOperationID)operationID
                                          characteristic:(CBCharacteristic *)characteristic
                                            successBlock:(void (^)(id returnData))successBlock
                                            failureBlock:(void (^)(NSError *error))failureBlock {
    if (![[MKBXDBaseCentralManager shared] readyToCommunication]) {
        [self operationFailedBlockWithMsg:@"The current connection device is in disconnect" failedBlock:failureBlock];
        return nil;
    }
    if (!characteristic) {
        [self operationFailedBlockWithMsg:@"Characteristic error" failedBlock:failureBlock];
        return nil;
    }
    __weak typeof(self) weakSelf = self;
    MKBXDOperation *operation = [[MKBXDOperation alloc] initOperationWithID:operationID commandBlock:^{
        [[MKBXDBaseCentralManager shared].peripheral readValueForCharacteristic:characteristic];
    } completeBlock:^(NSError * _Nullable error, id  _Nullable returnData) {
        __strong typeof(self) sself = weakSelf;
        sself.isAction = NO;
        if (sself.operationList.count > 0) {
            [sself.operationList removeObjectAtIndex:0];
            [sself operationAction];
        }
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
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
        dispatch_async(dispatch_get_main_queue(), ^{
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
    [self.operationList removeAllObjects];
    self.isAction = NO;
}

- (void)operationAction {
    if (self.operationList.count == 0 || self.isAction) {
        return;
    }
    self.isAction = YES;
    MKBXDOperation *currentOperation = self.operationList[0];
    [currentOperation startCommunication];
}

- (void)operationFailedBlockWithMsg:(NSString *)message failedBlock:(void (^)(NSError *error))failedBlock {
    NSError *error = [[NSError alloc] initWithDomain:@"com.moko.BXDCentralManager"
                                                code:-999
                                            userInfo:@{@"errorInfo":message}];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (failedBlock) {
            failedBlock(error);
        }
    });
}

- (void)saveToLogData:(NSString *)string appToDevice:(BOOL)app {
    NSString *fuction = (app ? @"App To Device" : @"Device To App");
    NSString *recordString = [NSString stringWithFormat:@"%@---->%@",fuction,string];
    [self logToLocal:recordString];
}

- (void)logToLocal:(NSString *)string {
    [MKBXDBaseLogManager saveDataWithFileName:mk_bxp_button_d_logName dataList:@[string]];
}

- (NSMutableArray *)operationList {
    if (!_operationList) {
        _operationList = [NSMutableArray array];
    }
    return _operationList;
}

@end
