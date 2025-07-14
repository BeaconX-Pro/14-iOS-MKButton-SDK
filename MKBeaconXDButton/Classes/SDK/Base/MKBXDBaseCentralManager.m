//
//  MKBXDBaseCentralManager.m
//  Pods-MKBXDBaseModule_Example
//
//  Created by aa on 2019/11/14.
//

#import "MKBXDBaseCentralManager.h"

#import "MKBXDBaseSDKAdopter.h"

typedef NS_ENUM(NSInteger, mk_bxd_currentAction) {
    mk_bxd_managerActionDefault,
    mk_bxd_managerActionScan,
    mk_bxd_managerActionConnecting,
};

NSString *const MKBXDPeripheralConnectStateChangedNotification = @"MKBXDPeripheralConnectStateChangedNotification";
NSString *const MKBXDCentralManagerStateChangedNotification = @"MKBXDCentralManagerStateChangedNotification";

static MKBXDBaseCentralManager *manager = nil;
static dispatch_once_t onceToken;

static NSTimeInterval const defaultConnectTime = 20.f;

@interface NSObject (MKBXDCentralManager)

@end

@implementation NSObject (MKBXDCentralManager)

+ (void)load{
    [MKBXDBaseCentralManager shared];
}

@end

@interface MKBXDBaseCentralManager ()<CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, strong)CBCentralManager *centralManager;

@property (nonatomic, strong)id <MKBXDPeripheralProtocol>peripheralManager;

@property (nonatomic, strong)id <MKBXDCentralManagerProtocol> managerPro;

@property (nonatomic, strong)dispatch_queue_t centralManagerQueue;

@property (nonatomic, assign)MKBXDPeripheralConnectState connectStatus;

@property (nonatomic, assign)MKBXDCentralManagerState centralStatus;

@property (nonatomic, assign)mk_bxd_currentAction managerAction;

@property (nonatomic, strong)dispatch_source_t connectTimer;

@property (nonatomic, copy)MKBXDConnectFailedBlock connectFailBlock;

@property (nonatomic, copy)MKBXDConnectSuccessBlock connectSucBlock;

@property (nonatomic, assign)BOOL connectTimeout;

@property (nonatomic, assign)BOOL isConnecting;

@end

@implementation MKBXDBaseCentralManager

#pragma mark - life circle

- (instancetype)init {
    if (self = [super init]) {
        _centralManagerQueue = dispatch_queue_create("moko.com.centralManager", DISPATCH_QUEUE_SERIAL);
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:_centralManagerQueue];
    }
    return self;
}

+ (MKBXDBaseCentralManager *)shared {
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [[MKBXDBaseCentralManager alloc] init];
        }
    });
    return manager;
}

+ (void)singleDealloc {
    onceToken = 0;
    manager = nil;
}

#pragma mark - CBCentralManagerDelegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    [self updateCentralManagerState];
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    if ([RSSI integerValue] == 127) {
        return;
    }
    if ([self.managerPro respondsToSelector:@selector(MKBXDCentralManagerDiscoverPeripheral:advertisementData:RSSI:)]) {
        [self.managerPro MKBXDCentralManagerDiscoverPeripheral:peripheral advertisementData:advertisementData RSSI:RSSI];
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    if (self.connectTimeout || !self.peripheralManager || self.managerAction != mk_bxd_managerActionConnecting) {
        return;
    }
    peripheral.delegate = self;
    [self.peripheralManager setNil];
    [self.peripheralManager discoverServices];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    [self connectPeripheralFailed];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"---------->The peripheral is disconnect");
    if (self.connectStatus != MKBXDPeripheralConnectStateConnected) {
        //连接过程中的断开不处理
        return;
    }
    [self.peripheralManager setNil];
    self.peripheralManager = nil;
    [self updatePeripheralConnectState:MKBXDPeripheralConnectStateDisconnect];
}

#pragma mark - CBPeripheralDelegate
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    if (self.connectTimeout || !self.peripheralManager || self.managerAction != mk_bxd_managerActionConnecting) {
        return;
    }
    if (error) {
        [self connectPeripheralFailed];
        return;
    }
    [self.peripheralManager setNil];
    [self.peripheralManager discoverCharacteristics];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    if (self.connectTimeout || !self.peripheralManager || self.managerAction != mk_bxd_managerActionConnecting) {
        return;
    }
    if (error) {
        [self connectPeripheralFailed];
        return;
    }
    [self.peripheralManager updateCharacterWithService:service];
    if ([self.peripheralManager connectSuccess]) {
        [self connectPeripheralSuccess];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error || self.connectTimeout || !self.peripheralManager || self.managerAction != mk_bxd_managerActionConnecting) {
        return;
    }
    [self.peripheralManager updateCurrentNotifySuccess:characteristic];
    if ([self.peripheralManager connectSuccess]) {
        [self connectPeripheralSuccess];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (self.managerPro && [self.managerPro respondsToSelector:@selector(peripheral:didUpdateValueForCharacteristic:error:)]) {
        [self.managerPro peripheral:peripheral didUpdateValueForCharacteristic:characteristic error:error];
    }
}
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    if (self.managerPro && [self.managerPro respondsToSelector:@selector(peripheral:didWriteValueForCharacteristic:error:)]) {
        [self.managerPro peripheral:peripheral didWriteValueForCharacteristic:characteristic error:error];
    }
}

#pragma mark - public method
- (CBPeripheral *)peripheral {
    return self.peripheralManager.peripheral;
}

- (void)loadDataManager:(id<MKBXDCentralManagerProtocol>)dataManager {
    if (!dataManager) {
        return;
    }
    self.managerPro = nil;
    self.managerPro = dataManager;
}

- (void)removeDataManager {
    self.managerPro = nil;
}

- (BOOL)scanForPeripheralsWithServices:(NSArray<CBUUID *> *)services options:(NSDictionary<NSString *,id> *)options {
    if (self.centralManager.state != CBManagerStatePoweredOn) {
        //当前蓝牙状态不可用
        return NO;
    }
    if (self.managerAction == mk_bxd_managerActionScan) {
        //处于扫描状态
        [self.centralManager stopScan];
    }else if (self.managerAction == mk_bxd_managerActionConnecting) {
        //处于连接状态
        [self connectPeripheralFailed];
    }
    self.managerAction = mk_bxd_managerActionScan;
    if (self.managerPro && [self.managerPro respondsToSelector:@selector(MKBXDCentralManagerStartScan)]) {
        [self.managerPro MKBXDCentralManagerStartScan];
    }
    [self.centralManager scanForPeripheralsWithServices:services options:options];
    return YES;
}

- (BOOL)stopScan {
    if (self.managerAction == mk_bxd_managerActionScan) {
        [self.centralManager stopScan];
    }else if (self.managerAction == mk_bxd_managerActionConnecting) {
        [self connectPeripheralFailed];
    }
    self.managerAction = mk_bxd_managerActionDefault;
    if (self.managerPro && [self.managerPro respondsToSelector:@selector(MKBXDCentralManagerStopScan)]) {
        [self.managerPro MKBXDCentralManagerStopScan];
    }
    return YES;
}

- (void)connectDevice:(id <MKBXDPeripheralProtocol>)peripheralProtocol
             sucBlock:(MKBXDConnectSuccessBlock)sucBlock
          failedBlock:(MKBXDConnectFailedBlock)failedBlock {
    if (!peripheralProtocol || !peripheralProtocol.peripheral || ![peripheralProtocol conformsToProtocol:@protocol(MKBXDPeripheralProtocol)]) {
        [MKBXDBaseSDKAdopter operationProtocolErrorBlock:failedBlock];
        return;
    }
    if (self.centralManager.state != CBManagerStatePoweredOn) {
        //蓝牙状态不可用
        [MKBXDBaseSDKAdopter operationCentralBlePowerOffBlock:failedBlock];
        return;
    }
    if (self.isConnecting) {
        [MKBXDBaseSDKAdopter operationConnectingErrorBlock:failedBlock];
        return;
    }
    self.isConnecting = YES;
    __weak typeof(self) weakSelf = self;
    [self connectWithProtocol:peripheralProtocol sucBlock:^(CBPeripheral * _Nonnull peripheral) {
        __strong typeof(self) sself = weakSelf;
        [sself clearConnectBlock];
        if (sucBlock) {
            sucBlock(peripheral);
        }
    } failedBlock:^(NSError * _Nonnull error) {
        __strong typeof(self) sself = weakSelf;
        [sself clearConnectBlock];
        if (failedBlock) {
            failedBlock(error);
        }
    }];
}
- (void)disconnect {
    if (self.centralManager.state != CBManagerStatePoweredOn || !self.peripheralManager || !self.peripheralManager.peripheral) {
        return;
    }
    [self.centralManager cancelPeripheralConnection:self.peripheralManager.peripheral];
    self.peripheralManager = nil;
    self.isConnecting = NO;
}

- (BOOL)sendDataToPeripheral:(NSString *)data
              characteristic:(CBCharacteristic *)characteristic
                        type:(CBCharacteristicWriteType)type {
    if (!self.peripheralManager
        || !self.peripheralManager.peripheral
        || ![data isKindOfClass:NSString.class]
        || data.length == 0
        || !characteristic
        || self.peripheralManager.peripheral.state != CBPeripheralStateConnected) {
        return NO;
    }
    NSData *commandData = [MKBXDBaseSDKAdopter stringToData:data];
    if (![commandData isKindOfClass:NSData.class] || commandData.length == 0) {
        return NO;
    }
    [self.peripheralManager.peripheral writeValue:commandData forCharacteristic:characteristic type:type];
    return YES;
}

- (BOOL)readyToCommunication{
    if (!self.peripheralManager || !self.peripheralManager.peripheral) {
        return NO;
    }
    return (self.connectStatus == MKBXDPeripheralConnectStateConnected);
}
 
#pragma mark - private method
- (void)updateCentralManagerState {
    MKBXDCentralManagerState managerState = (self.centralManager.state == CBManagerStatePoweredOn ? MKBXDCentralManagerStateEnable : MKBXDCentralManagerStateUnable);
    self.centralStatus = managerState;
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:MKBXDCentralManagerStateChangedNotification object:nil];
        if (self.managerPro && [self.managerPro respondsToSelector:@selector(MKBXDCentralManagerStateChanged:)]) {
            [self.managerPro MKBXDCentralManagerStateChanged:managerState];
        }
    });
    if (self.centralManager.state == CBManagerStatePoweredOn) {
        return;
    }
    switch (self.managerAction) {
        case mk_bxd_managerActionDefault:
            {
                if (self.connectStatus == MKBXDPeripheralConnectStateConnected) {
                    [self updatePeripheralConnectState:MKBXDPeripheralConnectStateDisconnect];
                }
                if (self.peripheralManager) {
                    [self.peripheralManager setNil];
                    self.peripheralManager = nil;
                }
            }
            break;
        case mk_bxd_managerActionScan:
            {
                [self stopScan];
            }
            break;
        case mk_bxd_managerActionConnecting:
            {
                [self connectPeripheralFailed];
            }
            break;
        default:
            break;
    }
}

#pragma mark - connect private method
- (void)connectWithProtocol:(id <MKBXDPeripheralProtocol>)peripheralProtocol
                        sucBlock:(MKBXDConnectSuccessBlock)sucBlock
                    failedBlock:(MKBXDConnectFailedBlock)failedBlock{
    if (self.peripheralManager) {
        if (self.peripheralManager.peripheral) {
            [self.centralManager cancelPeripheralConnection:self.peripheralManager.peripheral];
        }
        [self.peripheralManager setNil];
        self.peripheralManager = nil;
    }
    
    self.peripheralManager = peripheralProtocol;
    self.managerAction = mk_bxd_managerActionConnecting;
    self.connectSucBlock = nil;
    self.connectSucBlock = sucBlock;
    self.connectFailBlock = nil;
    self.connectFailBlock = failedBlock;
    [self centralConnectPeripheral:peripheralProtocol.peripheral];
}

- (void)centralConnectPeripheral:(CBPeripheral *)peripheral{
    if (!peripheral) {
        return;
    }
    [self.centralManager stopScan];
    [self updatePeripheralConnectState:MKBXDPeripheralConnectStateConnecting];
    [self initConnectTimer];
    [self.centralManager connectPeripheral:peripheral options:@{}];
}

- (void)initConnectTimer{
    self.connectTimeout = NO;
    self.connectTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,_centralManagerQueue);
    dispatch_source_set_timer(self.connectTimer, dispatch_time(DISPATCH_TIME_NOW, defaultConnectTime * NSEC_PER_SEC),  defaultConnectTime * NSEC_PER_SEC, 0);
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(self.connectTimer, ^{
        __strong typeof(self) sself = weakSelf;
        sself.connectTimeout = YES;
        [sself connectPeripheralFailed];
    });
    dispatch_resume(self.connectTimer);
}

- (void)resetOriSettings{
    if (self.connectTimer) {
        dispatch_cancel(self.connectTimer);
    }
    self.managerAction = mk_bxd_managerActionDefault;
    self.connectTimeout = NO;
    self.isConnecting = NO;
}

- (void)connectPeripheralFailed{
    [self resetOriSettings];
    if (self.peripheralManager) {
        if (self.peripheralManager.peripheral) {
            [self.centralManager cancelPeripheralConnection:self.peripheralManager.peripheral];
        }
        [self.peripheralManager setNil];
        self.peripheralManager = nil;
    }
    [self updatePeripheralConnectState:MKBXDPeripheralConnectStateConnectedFailed];
    [MKBXDBaseSDKAdopter operationConnectFailedBlock:self.connectFailBlock];
}

- (void)connectPeripheralSuccess{
    if (self.connectTimeout || !self.peripheralManager) {
        return;
    }
    [self resetOriSettings];
    [self updatePeripheralConnectState:MKBXDPeripheralConnectStateConnected];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.connectSucBlock) {
            self.connectSucBlock(self.peripheralManager.peripheral);
        }
    });
}

- (void)updatePeripheralConnectState:(MKBXDPeripheralConnectState)state {
    self.connectStatus = state;
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:MKBXDPeripheralConnectStateChangedNotification object:nil];
        if (self.managerPro && [self.managerPro respondsToSelector:@selector(MKBXDPeripheralConnectStateChanged:)]) {
            [self.managerPro MKBXDPeripheralConnectStateChanged:state];
        }
    });
}

- (void)clearConnectBlock{
    if (self.connectSucBlock) {
        self.connectSucBlock = nil;
    }
    if (self.connectFailBlock) {
        self.connectFailBlock = nil;
    }
}

@end
