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

@interface MKBXDBaseCentralManager : NSObject

/// 当前中心
@property (nonatomic, strong, readonly)CBCentralManager *centralManager;

/// 当前外设连接状态
@property (nonatomic, assign, readonly)MKBXDPeripheralConnectState connectStatus;

/// 当前蓝牙中心状态
@property (nonatomic, assign, readonly)MKBXDCentralManagerState centralStatus;

+ (MKBXDBaseCentralManager *)shared;

/// 销毁单例
+ (void)singleDealloc;

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
