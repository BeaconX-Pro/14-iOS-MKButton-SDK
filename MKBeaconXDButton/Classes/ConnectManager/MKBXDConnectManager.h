//
//  MKBXDConnectManager.h
//  MKBeaconXDButton_Example
//
//  Created by aa on 2022/2/18.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CBPeripheral;
@interface MKBXDConnectManager : NSObject

/// 当前连接密码
@property (nonatomic, copy)NSString *password;

/// 是否需要密码连接
@property (nonatomic, assign)BOOL needPassword;

/// 设备类型
@property (nonatomic, copy)NSString *deviceType;

/// 是否带有三轴传感器
@property (nonatomic, assign)BOOL threeSensor;

/// 是否带有温湿度传感器
@property (nonatomic, assign)BOOL htSensor;

/// 是否带有光感传感器
@property (nonatomic, assign)BOOL lightSensor;

/// 是否是BXP-CR
@property (nonatomic, assign)BOOL isCR;

+ (MKBXDConnectManager *)shared;

/// 连接设备
/// @param peripheral 设备
/// @param password 密码
/// @param sucBlock 成功回调
/// @param failedBlock 失败回调
- (void)connectDevice:(CBPeripheral *)peripheral
             password:(NSString *)password
             sucBlock:(void (^)(void))sucBlock
          failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
