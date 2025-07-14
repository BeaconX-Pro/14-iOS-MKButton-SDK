//
//  MKBXDBaseDataProtocol.h
//  Pods-MKBXDModule_Example
//
//  Created by aa on 2019/11/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MKBXDPeripheralConnectState) {
    MKBXDPeripheralConnectStateUnknow,                                           //未知状态
    MKBXDPeripheralConnectStateConnecting,                                       //正在连接
    MKBXDPeripheralConnectStateConnected,                                        //连接成功
    MKBXDPeripheralConnectStateConnectedFailed,                                  //连接失败
    MKBXDPeripheralConnectStateDisconnect,                                       //连接断开
};
typedef NS_ENUM(NSInteger, MKBXDCentralManagerState) {
    MKBXDCentralManagerStateUnable,                           //不可用
    MKBXDCentralManagerStateEnable,                           //可用状态
};

@class CBPeripheral,CBService,CBCharacteristic,CBUUID;

#pragma mark - 中心扫描部分
@protocol MKBXDScanProtocol <NSObject>

@required

/// 蓝牙中心搜索到新的设备
/// @param peripheral 搜索到的设备
/// @param advertisementData 设备广播数据
/// @param RSSI 设备当前RSSI
- (void)MKBXDCentralManagerDiscoverPeripheral:(CBPeripheral *)peripheral
                            advertisementData:(NSDictionary<NSString *,id> *)advertisementData
                                         RSSI:(NSNumber *)RSSI;

@optional

/// 中心开始扫描
- (void)MKBXDCentralManagerStartScan;

/// 中心停止扫描
- (void)MKBXDCentralManagerStopScan;

@end


#pragma mark - 中心蓝牙状态和外设连接状态
@protocol MKBXDCentralManagerStateProtocol <NSObject>

@required

/// 当前蓝牙中心状态发生改变
/// @param centralManagerState centralManagerState
- (void)MKBXDCentralManagerStateChanged:(MKBXDCentralManagerState)centralManagerState;

/// 当前中心的外设连接状态发生改变
/// @param connectState connectState
- (void)MKBXDPeripheralConnectStateChanged:(MKBXDPeripheralConnectState)connectState;

@end

@protocol MKBXDCentralManagerProtocol <NSObject,MKBXDScanProtocol,MKBXDCentralManagerStateProtocol>

@required

/// 蓝牙中心接收到特征发过来的数据
/// @param peripheral 发送数据的外设
/// @param characteristic 数据交互特征
/// @param error 是否产生了错误
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error;

/// 中心蓝牙使用某个特征发送数据结果
/// @param peripheral 接收数据的外设
/// @param characteristic 数据交互特征
/// @param error 是否产生了错误
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error;

@end

@protocol MKBXDPeripheralProtocol <NSObject>

@required

/// 当前要连接的目标设备
- (nonnull CBPeripheral *)peripheral;

/// 当前设备支持哪些服务
- (void)discoverServices;

/// 当前设备支持哪些特征
- (void)discoverCharacteristics;

/// 中心发现的目标设备的服务
/// @param service service
- (void)updateCharacterWithService:(CBService *)service;

/// 对于需要监听的特征，打开监听之后系统显示已经监听成功
/// @param characteristic characteristic
- (void)updateCurrentNotifySuccess:(CBCharacteristic *)characteristic;

/// 不同设备会有不同服务和特征，中心需要通过这个接口知道目标设备是否完全具备通信的条件
- (BOOL)connectSuccess;

/// 连接过程或者已经连接上的设备出现断开连接或者连接出错的情况下，目标设备需要清空当前已经设备的服务和特征值
- (void)setNil;

@end

NS_ASSUME_NONNULL_END
