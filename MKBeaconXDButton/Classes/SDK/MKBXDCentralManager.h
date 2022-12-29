//
//  MKBXDCentralManager.h
//  MKBeaconXDButton_Example
//
//  Created by aa on 2022/2/18.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MKBaseBleModule/MKBLEBaseDataProtocol.h>

#import "MKBXDOperationID.h"

@class CBCentralManager,CBPeripheral;
@class MKBXDBaseAdvModel;

NS_ASSUME_NONNULL_BEGIN

//Notification of device connection status changes.
extern NSString *const mk_bxd_peripheralConnectStateChangedNotification;

//Notification of changes in the status of the Bluetooth Center.
extern NSString *const mk_bxd_centralManagerStateChangedNotification;

/*
 After connecting the device, if no password is entered within one minute, it returns 0x01. After successful password change, it returns 0x02.The device reset ,it returns 0x03.Power Off the device ,it returns 0x04.
 */
extern NSString *const mk_bxd_deviceDisconnectTypeNotification;

/*
 The current trigger record returned by the device.
        @{
    @"timestamp":timestamp,         //Record trigger timestamp (accurate to millisecond level).
     @"alarmType":alarmType,        //Type of trigger.(00:Single press event  01:Double press event 02:Long press event )
 }
 
 */
extern NSString *const mk_bxd_receiveAlarmEventDataNotification;

extern NSString *const mk_bxd_receiveThreeAxisDataNotification;

typedef NS_ENUM(NSInteger, mk_bxd_centralManagerStatus) {
    mk_bxd_centralManagerStatusUnable,                           //不可用
    mk_bxd_centralManagerStatusEnable,                           //可用状态
};

typedef NS_ENUM(NSInteger, mk_bxd_centralConnectStatus) {
    mk_bxd_centralConnectStatusUnknow,                                           //未知状态
    mk_bxd_centralConnectStatusConnecting,                                       //正在连接
    mk_bxd_centralConnectStatusConnected,                                        //连接成功
    mk_bxd_centralConnectStatusConnectedFailed,                                  //连接失败
    mk_bxd_centralConnectStatusDisconnect,
};

@protocol mk_bxd_centralManagerScanDelegate <NSObject>

/// Scan to new device.
/// @param deviceList deviceList
- (void)mk_bxd_receiveAdvData:(NSArray <MKBXDBaseAdvModel *>*)deviceList;

@optional

/// Starts scanning equipment.
- (void)mk_bxd_startScan;

/// Stops scanning equipment.
- (void)mk_bxd_stopScan;

@end

@interface MKBXDCentralManager : NSObject<MKBLEBaseCentralManagerProtocol>

@property (nonatomic, weak)id <mk_bxd_centralManagerScanDelegate>delegate;

/// Current connection status
@property (nonatomic, assign, readonly)mk_bxd_centralConnectStatus connectStatus;

+ (MKBXDCentralManager *)shared;

/// Destroy the MKBXDCentralManager singleton and the MKBLEBaseCentralManager singleton. After the dfu upgrade, you need to destroy these two and then reinitialize.
+ (void)sharedDealloc;

/// Destroy the MKBXDCentralManager singleton and remove the manager list of MKBLEBaseCentralManager.
+ (void)removeFromCentralList;

- (nonnull CBCentralManager *)centralManager;

/// Currently connected devices
- (nullable CBPeripheral *)peripheral;

/// Current Bluetooth center status
- (mk_bxd_centralManagerStatus )centralStatus;

/// Bluetooth Center starts scanning
- (void)startScan;

/// Bluetooth center stops scanning
- (void)stopScan;

/// Read whether a connected device requires a password.
/*
 @{
 @"state":@"00",            //@"00":Password-free connection   @"01":password connection
 }
 */
/// @param peripheral peripheral
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
- (void)readNeedPasswordWithPeripheral:(nonnull CBPeripheral *)peripheral
                              sucBlock:(void (^)(NSDictionary *result))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/// Connect device function.
/// @param peripheral peripheral
/// @param password Device connection password.No more than 16 characters.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
- (void)connectPeripheral:(nonnull CBPeripheral *)peripheral
                 password:(nonnull NSString *)password
                 sucBlock:(void (^)(CBPeripheral *peripheral))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock;

/// Connect device function.
/// @param peripheral peripheral
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
- (void)connectPeripheral:(nonnull CBPeripheral *)peripheral
                 sucBlock:(void (^)(CBPeripheral *peripheral))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock;

- (void)disconnect;

/// Start a task for data communication with the device
/// @param operationID operation id
/// @param characteristic characteristic for communication
/// @param commandData Data to be sent to the device for this communication
/// @param successBlock Successful callback
/// @param failureBlock Failure callback
- (void)addTaskWithTaskID:(mk_bxd_taskOperationID)operationID
           characteristic:(CBCharacteristic *)characteristic
              commandData:(NSString *)commandData
             successBlock:(void (^)(id returnData))successBlock
             failureBlock:(void (^)(NSError *error))failureBlock;

/// Start a task to read device characteristic data
/// @param operationID operation id
/// @param characteristic characteristic for communication
/// @param successBlock Successful callback
/// @param failureBlock Failure callback
- (void)addReadTaskWithTaskID:(mk_bxd_taskOperationID)operationID
               characteristic:(CBCharacteristic *)characteristic
                 successBlock:(void (^)(id returnData))successBlock
                 failureBlock:(void (^)(NSError *error))failureBlock;

/// Alarm event data(Single press event.).
/// @param notify notify
- (BOOL)notifySinglePressEventData:(BOOL)notify;

/// Alarm event data(Double press event.).
/// @param notify notify
- (BOOL)notifyDoublePressEventData:(BOOL)notify;

/// Alarm event data(Long press event.).
/// @param notify notify
- (BOOL)notifyLongPressEventData:(BOOL)notify;

/// Monitor three-axis accelerometer data.
/// @param notify notify
- (BOOL)notifyThreeAxisData:(BOOL)notify;

@end

NS_ASSUME_NONNULL_END
