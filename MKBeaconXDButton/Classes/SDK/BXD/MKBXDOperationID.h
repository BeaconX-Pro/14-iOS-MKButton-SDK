
typedef NS_ENUM(NSInteger, mk_bxd_taskOperationID) {
    mk_bxd_defaultTaskOperationID,
    
    mk_bxd_taskReadDeviceModelOperation,        //读取产品型号
    mk_bxd_taskReadProductionDateOperation,     //读取生产日期
    mk_bxd_taskReadFirmwareOperation,           //读取固件版本
    mk_bxd_taskReadHardwareOperation,           //读取硬件类型
    mk_bxd_taskReadSoftwareOperation,           //读取软件版本
    mk_bxd_taskReadManufacturerOperation,       //读取厂商信息
    
#pragma mark - 密码
    mk_bxd_taskReadNeedPasswordOperation,               //读取设备是否需要连接密码
    mk_bxd_connectPasswordOperation,                    //连接密码
    
#pragma mark - custom read
    mk_bxd_taskReadMacAddressOperation,                 //读取mac地址
    mk_bxd_taskReadThreeAxisDataParamsOperation,        //读取3轴传感器数据
    mk_bxd_taskReadConnectableOperation,                //读取设备的可连接状态
    mk_bxd_taskReadConnectPasswordOperation,            //读取设备的连接密码
    mk_bxd_taskReadEffectiveClickIntervalOperation,     //读取连续按键有效时长
    mk_bxd_taskReadTurnOffByButtonStatusOperation,      //读取按键开关机状态
    mk_bxd_taskReadScanResponsePacketOperation,         //读取回应包开关
    mk_bxd_taskReadResetDeviceByButtonStatusOperation,  //读取按键是否可以恢复出厂设置
    mk_bxd_taskReadTriggerChannelStateOperation,        //读取各通道广播使能情况
    mk_bxd_taskReadChannelAdvContentOperation,          //读取通道广播帧内容
    mk_bxd_taskReadTriggerChannelAdvParamsOperation,    //读取活跃通道广播参数
    mk_bxd_taskReadChannelTriggerParamsOperation,       //读取活跃通道触发广播参数
    mk_bxd_taskReadStayAdvertisingBeforeTriggeredOperation,     //读取活跃通道触发前广播开关
    mk_bxd_taskReadAlarmNotificationTypeOperation,      //读取触发提醒模式
    mk_bxd_taskReadAbnormalInactivityTimeOperation,     //读取异常活动报警静止时间
    mk_bxd_taskReadPowerSavingModeOperation,            //读取省电模式开关
    mk_bxd_taskReadStaticTriggerTimeOperation,          //读取省电模式静止时间
    mk_bxd_taskReadAlarmLEDNotiParamsOperation,         //读取通道触发LED提醒参数
    mk_bxd_taskReadAlarmVibrateNotiParamsOperation,     //读取通道触发马达提醒参数
    mk_bxd_taskReadAlarmBuzzerNotiParamsOperation,      //读取通道触发蜂鸣器提醒参数
    mk_bxd_taskReadRemoteReminderLEDNotiParamsOperation,    //读取远程LED提醒参数
    mk_bxd_taskReadRemoteReminderVibrationNotiParamsOperation,  //读取远程马达提醒参数
    mk_bxd_taskReadRemoteReminderBuzzerNotiParamsOperation,     //读取远程蜂鸣器提醒参数
    mk_bxd_taskReadDismissAlarmByButtonOperation,               //读取按键消警使能
    mk_bxd_taskReadDismissAlarmLEDNotiParamsOperation,  //读取LED消警参数
    mk_bxd_taskReadDismissAlarmVibrationNotiParamsOperation,    //读取马达消警参数
    mk_bxd_taskReadDismissAlarmBuzzerNotiParamsOperation,       //读取蜂鸣器消警参数
    mk_bxd_taskReadDismissAlarmNotificationTypeOperation,   //读取消警提醒模式
    mk_bxd_taskReadBatteryVoltageOperation,             //读取电池电压
    mk_bxd_taskReadDeviceTimestampOperation,            //读取设备当前时间戳
    mk_bxd_taskReadSensorStatusOperation,               //读取传感器状态
    mk_bxd_taskReadDeviceIDOperation,                   //读取deviceID
    mk_bxd_taskReadDeviceNameOperation,                 //读取设备名称
    mk_bxd_taskReadSinglePressEventCountOperation,      //读取单击触发次数
    mk_bxd_taskReadDoublePressEventCountOperation,      //读取双击触发次数
    mk_bxd_taskReadLongPressEventCountOperation,        //读取长按触发次数
    mk_bxd_taskReadDeviceTypeOperation,                 //读取设备类型
    mk_bxd_taskReadDeviceBatteryPercentOperation,       //读取电池实时百分比
    mk_bxd_taskReadDevicePCBTypeOperation,              //读取板子类型
    mk_bxd_taskReadSubButtonSinglePressEventCountOperation, //读取副按键单击触发次数
    mk_bxd_taskReadSubButtonDoublePressEventCountOperation, //读取副按键双击触发次数
    mk_bxd_taskReadSubButtonLongPressEventCountOperation,   //读取副按键长按触发次数

#pragma mark - custom write
    mk_bxd_taskConfigThreeAxisDataParamsOperation,      //设置3轴传感器参数
    mk_bxd_taskConfigConnectableOperation,              //设置设备的可连接性
    mk_bxd_taskConfigConnectPasswordOperation,          //设置连接密码
    mk_bxd_taskConfigEffectiveClickIntervalOperation,   //设置连续按键有效时长
    mk_bxd_taskConfigPowerOffOperation,                 //关机
    mk_bxd_taskConfigFactoryResetOperation,             //恢复出厂设置
    mk_bxd_taskConfigTurnOffByButtonOperation,          //配置按键开关机状态
    mk_bxd_taskConfigScanResponsePacketOperation,       //设置回应包开关
    mk_bxd_taskConfigResetDeviceByButtonStatusOperation,    //设置按键是否可以恢复出厂设置
    mk_bxd_taskConfigChannelContentOperation,               //设置通道广播帧类型
    mk_bxd_taskConfigTriggerChannelAdvParamsOperation,  //设置活跃通道广播参数
    mk_bxd_taskConfigChannelTriggerParamsOperation,     //设置活跃通道触发广播参数
    mk_bxd_taskConfigStayAdvertisingBeforeTriggeredOperation,       //设置活跃通道触发前广播开关
    mk_bxd_taskConfigAlarmNotificationTypeOperation,    //设置触发提醒模式
    mk_bxd_taskConfigAbnormalInactivityTimeOperation,   //设置异常活动报警静止时间
    mk_bxd_taskConfigPowerSavingModeOperation,          //设置省电模式开关
    mk_bxd_taskConfigStaticTriggerTimeOperation,        //设置省电模式静止时间
    mk_bxd_taskConfigAlarmLEDNotiParamsOperation,       //设置通道触发LED提醒参数
    mk_bxd_taskConfigAlarmVibrateNotiParamsOperation,   //设置通道触发马达提醒参数
    mk_bxd_taskConfigAlarmBuzzerNotiParamsOperation,    //设置通道触发蜂鸣器提醒参数
    mk_bxd_taskConfigRemoteReminderLEDNotiParamsOperation,  //设置远程LED提醒参数
    mk_bxd_taskConfigRemoteReminderVibrationNotiParamsOperation,    //设置远程马达提醒参数
    mk_bxd_taskConfigRemoteReminderBuzzerNotiParamsOperation,       //设置远程蜂鸣器提醒参数
    mk_bxd_taskConfigDismissAlarmOperation,             //设置远程消警
    mk_bxd_taskConfigDismissAlarmByButtonOperation,     //设置按键消警使能
    mk_bxd_taskConfigDismissAlarmLEDNotiParamsOperation,    //设置远程LED消警参数
    mk_bxd_taskConfigDismissAlarmVibrationNotiParamsOperation,  //设置远程马达消警参数
    mk_bxd_taskConfigDismissAlarmBuzzerNotiParamsOperation,     //设置远程蜂鸣器消警参数
    mk_bxd_taskConfigDismissAlarmNotificationTypeOperation,     //设置消警提醒模式
    mk_bxd_taskClearSinglePressEventDataOperation,      //删除单击通道触发记录
    mk_bxd_taskClearDoublePressEventDataOperation,      //删除双击通道触发记录
    mk_bxd_taskClearLongPressEventDataOperation,        //删除长按通道触发记录
    mk_bxd_taskConfigDeviceTimestampOperation,          //设置设备当前系统时间
    mk_bxd_taskClearLongConnectionModeEventDataOperation,   //删除长链接模式通道触发记录
    mk_bxd_taskConfigDeviceIDOperation,                 //设置deviceID
    mk_bxd_taskConfigDeviceNameOperation,               //设置设备名称
    mk_bxd_taskBatteryResetOperation,                   //重置电池
    mk_bxd_taskClearSubBtnSinglePressEventDataOperation,    //清除副按键单击触发次数
    mk_bxd_taskClearSubBtnDoublePressEventDataOperation,    //清除副按键双击触发次数
    mk_bxd_taskClearSubBtnLongPressEventDataOperation,      //清除副按键长按触发次数
    
#pragma mark - password
    mk_bxd_taskConfigPasswordVerificationOperation,     //设置设备密码验证
};
