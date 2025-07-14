
#pragma mark - *****************枚举*********************
typedef NS_ENUM(NSInteger, MKBXDChannelAlarmType) {
    MKBXDChannelAlarmType_single,
    MKBXDChannelAlarmType_double,
    MKBXDChannelAlarmType_long,
    MKBXDChannelAlarmType_abnormalInactivity,
};

typedef NS_ENUM(NSInteger, MKBXDChannelAlarmNotifyType) {
    MKBXDChannelAlarmNotifyType_single,
    MKBXDChannelAlarmNotifyType_double,
    MKBXDChannelAlarmNotifyType_long,
    MKBXDChannelAlarmNotifyType_abnormalInactivity,
    MKBXDChannelAlarmNotifyType_longConMode,        //V1 don't support
};

typedef NS_ENUM(NSInteger, mk_bxd_txPower) {
    mk_bxd_txPowerNeg40dBm,   //RadioTxPower:-40dBm
    mk_bxd_txPowerNeg20dBm,   //-20dBm
    mk_bxd_txPowerNeg16dBm,   //-16dBm
    mk_bxd_txPowerNeg12dBm,   //-12dBm
    mk_bxd_txPowerNeg8dBm,    //-8dBm
    mk_bxd_txPowerNeg4dBm,    //-4dBm
    mk_bxd_txPower0dBm,       //0dBm
    mk_bxd_txPower3dBm,       //3dBm
    mk_bxd_txPower4dBm,       //4dBm
};

typedef NS_ENUM(NSInteger, mk_bxd_reminderType) {
    mk_bxd_reminderType_silent,
    mk_bxd_reminderType_led,
    mk_bxd_reminderType_vibration,
    mk_bxd_reminderType_buzzer,
    mk_bxd_reminderType_ledAndVibration,
    mk_bxd_reminderType_ledAndBuzzer,
};

typedef NS_ENUM(NSInteger, mk_bxd_threeAxisDataRate) {
    mk_bxd_threeAxisDataRate1hz,           //1hz
    mk_bxd_threeAxisDataRate10hz,          //10hz
    mk_bxd_threeAxisDataRate25hz,          //25hz
    mk_bxd_threeAxisDataRate50hz,          //50hz
    mk_bxd_threeAxisDataRate100hz          //100hz
};

typedef NS_ENUM(NSInteger, mk_bxd_threeAxisDataAG) {
    mk_bxd_threeAxisDataAG0,               //±2g
    mk_bxd_threeAxisDataAG1,               //±4g
    mk_bxd_threeAxisDataAG2,               //±8g
    mk_bxd_threeAxisDataAG3                //±16g
};

#pragma mark - *****************Protocol*********************
@protocol MKBXDTriggerChannelAdvParamsProtocol <NSObject>

@property (nonatomic, assign)MKBXDChannelAlarmType alarmType;

/// Whether to enable advertising.
@property (nonatomic, assign)BOOL isOn;

/// Ranging data.(-100dBm~0dBm)
@property (nonatomic, assign)NSInteger rssi;

/// advertising interval.(1~500,unit:20ms)
@property (nonatomic, copy)NSString *advInterval;

@property (nonatomic, assign)mk_bxd_txPower txPower;

@end



@protocol MKBXDChannelTriggerParamsProtocol <NSObject>

@property (nonatomic, assign)MKBXDChannelAlarmType alarmType;

/// Whether to enable trigger function.
@property (nonatomic, assign)BOOL alarm;

/// Ranging data.(-100dBm~0dBm)
@property (nonatomic, assign)NSInteger rssi;

/// advertising interval.(1~500,unit:20ms)
@property (nonatomic, copy)NSString *advInterval;

/// broadcast time after trigger.1s~65535s.
@property (nonatomic, copy)NSString *advertisingTime;

@property (nonatomic, assign)mk_bxd_txPower txPower;

@end

#pragma mark - **************************************

