//
//  MKBXDBaseCentralManager.h
//  Pods-MKBXDBaseModule_Example
//
//  Created by aa on 2019/11/14.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#import "MKBXDBaseDataProtocol.h"

NS_ASSUME_NONNULL_BEGIN

///  当前外设连接状态发生改变通知
extern NSString *const MKBXDPeripheralConnectStateChangedNotification;
///  当前蓝牙中心状态发生改变通知
extern NSString *const MKBXDCentralManagerStateChangedNotification;

/// 连接外设失败block
typedef void(^MKBXDConnectFailedBlock)(NSError *error);
///  连接外设成功block
typedef void(^MKBXDConnectSuccessBlock)(CBPeripheral *peripheral);
/// 状态恢复完成block
typedef void(^MKBXDStateRestorationCompletion)(NSArray<CBPeripheral *> * _Nullable restoredPeripherals);

@interface MKBXDBaseCentralManager : NSObject

/// 当前中心
@property (nonatomic, strong, readonly)CBCentralManager *centralManager;

/// 当前外设连接状态
@property (nonatomic, assign, readonly)MKBXDPeripheralConnectState connectStatus;

/// 当前蓝牙中心状态
@property (nonatomic, assign, readonly)MKBXDCentralManagerState centralStatus;

/// 状态恢复回调（当应用被系统重启并恢复蓝牙状态时调用）
@property (nonatomic, copy, nullable)MKBXDStateRestorationCompletion restorationCompletion;

+ (MKBXDBaseCentralManager *)shared;

/// 销毁单例
+ (void)singleDealloc;

/// 初始化CentralManager（支持状态恢复）- 必须在shared之前调用
/// @param restoreIdentifier 状态恢复标识符，传nil则不启用状态恢复，建议使用Bundle ID
+ (void)initializeWithRestoreIdentifier:(nullable NSString *)restoreIdentifier;

/// 当前连接的外设
- (nullable CBPeripheral *)peripheral;

/// 将一个满足MKBXDCentralManagerProtocol的对象作为管理
/// @param dataManager MKBXDCentralManagerProtocol
- (void)loadDataManager:(nonnull id <MKBXDCentralManagerProtocol>)dataManager;

- (void)removeDataManager;

#pragma mark - ************************* 扫描 **************************

/// 扫描
/// @param services A list of <code>CBUUID</code> objects representing the service(s) to scan for.
/// @param options An optional dictionary specifying options for the scan.
- (BOOL)scanForPeripheralsWithServices:(nullable NSArray<CBUUID *> *)services
                               options:(nullable NSDictionary<NSString *,id> *)options;

/// 停止扫描
- (BOOL)stopScan;

#pragma mark - ************************* 连接 **************************

/// 连接设备
/// @param peripheralProtocol MKBXDPeripheralProtocol
/// @param sucBlock Success Callback
/// @param failedBlock Failure Callback
- (void)connectDevice:(nonnull id <MKBXDPeripheralProtocol>)peripheralProtocol
             sucBlock:(nullable MKBXDConnectSuccessBlock)sucBlock
          failedBlock:(nullable MKBXDConnectFailedBlock)failedBlock;

/// 断开当前连接的外设
- (void)disconnect;

#pragma mark - ************************* 数据交互 **************************

/// 给当前连接的外设发送数据
/// @param data Data
/// @param characteristic characteristic
/// @param type Specifies which type of write is to be performed on a CBCharacteristic.
- (BOOL)sendDataToPeripheral:(nonnull NSString *)data
              characteristic:(nonnull CBCharacteristic *)characteristic
                        type:(CBCharacteristicWriteType)type;

/// 当前设备是否可以通信
- (BOOL)readyToCommunication;

@end

NS_ASSUME_NONNULL_END
