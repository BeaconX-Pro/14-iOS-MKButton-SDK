//
//  MKBXDBaseAdvModel.m
//  MKBeaconXDButton_Example
//
//  Created by aa on 2022/2/23.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXDBaseAdvModel.h"

#import <CoreBluetooth/CoreBluetooth.h>

#import "MKBLEBaseLogManager.h"

#import "MKBLEBaseSDKDefines.h"
#import "MKBLEBaseSDKAdopter.h"

@implementation MKBXDBaseAdvModel

+ (NSArray <MKBXDBaseAdvModel *>*)parseAdvData:(NSDictionary *)advData
                                    peripheral:(CBPeripheral *)peripheral
                                          RSSI:(NSNumber *)RSSI {
    if (!MKValidDict(advData)) {
        return @[];
    }
    NSDictionary *advDic = advData[CBAdvertisementDataServiceDataKey];
    if (!MKValidDict(advDic)) {
        return @[];
    }
    
    NSMutableArray *beaconList = [NSMutableArray array];
    NSArray *keys = [advDic allKeys];
    
    for (id key in keys) {
        if ([key isEqual:[CBUUID UUIDWithString:@"FEAA"]]) {
            NSData *feaaData = advDic[[CBUUID UUIDWithString:@"FEAA"]];
            if (MKValidData(feaaData)) {
                MKBXDDataFrameType frameType = [self fetchFEAAFrameType:feaaData];
                if (frameType == MKBXDUIDFrameType) {
                    MKBXDUIDBeacon *beacon = [[MKBXDUIDBeacon alloc] initWithAdvertiseData:feaaData];
                    beacon.frameType = MKBXDUIDFrameType;
                    if (beacon) {
                        [beaconList addObject:beacon];
                    }
                }
            }
        }else if ([key isEqual:[CBUUID UUIDWithString:@"FEAB"]]) {
            NSData *feabData = advDic[[CBUUID UUIDWithString:@"FEAB"]];
            if (MKValidData(feabData)) {
                MKBXDDataFrameType frameType = [self fetchFEABFrameType:feabData];
                if (frameType == MKBXDBeaconFrameType) {
                    MKBXDBeacon *beacon = [[MKBXDBeacon alloc] initWithAdvertiseData:feabData];
                    beacon.frameType = MKBXDBeaconFrameType;
                    if (beacon) {
                        beacon.txPower = advData[CBAdvertisementDataTxPowerLevelKey];
                        [beaconList addObject:beacon];
                    }
                }
            }
        }else if ([key isEqual:[CBUUID UUIDWithString:@"FEE0"]]) {
            NSArray *tempList = [self parseAdvDataList:advData peripheral:peripheral RSSI:RSSI];
            if (tempList.count > 0) {
                [beaconList addObjectsFromArray:tempList];
            }
        }
    }
    
    return beaconList;
}

+ (NSArray <MKBXDBaseAdvModel *>*)parseAdvDataList:(NSDictionary *)advData
                                        peripheral:(CBPeripheral *)peripheral
                                              RSSI:(NSNumber *)RSSI {
    NSDictionary *advDic = advData[CBAdvertisementDataServiceDataKey];
    NSMutableArray *beaconList = [NSMutableArray array];
    NSData *scanData = advDic[[CBUUID UUIDWithString:@"FEE0"]];
    NSData *respondData = advDic[[CBUUID UUIDWithString:@"EA00"]];
    if (!MKValidData(scanData)) {
        return beaconList;
    }
    [MKBLEBaseLogManager saveDataWithFileName:@"BXP-B-D" dataList:@[[MKBLEBaseSDKAdopter hexStringFromData:scanData],
                                                                    [MKBLEBaseSDKAdopter hexStringFromData:respondData]]];
    MKBXDBaseAdvModel *scanModel = [self parseAdvModeWithData:scanData];
    MKBXDBaseAdvModel *respondModel = [self parseAdvModeWithData:respondData];
    if (respondModel && [respondModel isKindOfClass:MKBXDAdvRespondDataModel.class]) {
        //回应包内容
        MKBXDAdvRespondDataModel *tempModel = (MKBXDAdvRespondDataModel *)respondModel;
        tempModel.txPower = advData[CBAdvertisementDataTxPowerLevelKey];
        [beaconList addObject:tempModel];
    }
    if (scanModel && [scanModel isKindOfClass:MKBXDAdvDataModel.class]) {
        //触发广播包
        MKBXDAdvDataModel *tempModel = (MKBXDAdvDataModel *)scanModel;
        [beaconList addObject:tempModel];
    }
    
    return beaconList;
}

+ (MKBXDBaseAdvModel *)parseAdvModeWithData:(NSData *)advData {
    if (!MKValidData(advData) || advData.length < 6) {
        return nil;
    }
    NSString *tempDataString = [MKBLEBaseSDKAdopter hexStringFromData:advData];
    if (!MKValidStr(tempDataString)) {
        return nil;
    }
    NSString *typeString = [tempDataString substringWithRange:NSMakeRange(0, 2)];
    if ([typeString isEqualToString:@"00"]) {
        //回应包内容
        MKBXDAdvRespondDataModel *tempModel = [[MKBXDAdvRespondDataModel alloc] initRespondWithAdvertiseData:advData];
        tempModel.frameType = MKBXDRespondFrameType;
        return tempModel;
    }
    if ([typeString isEqualToString:@"20"] || [typeString isEqualToString:@"21"]
        || [typeString isEqualToString:@"22"] || [typeString isEqualToString:@"23"]) {
        //触发广播包
        MKBXDAdvDataModel *tempModel = [[MKBXDAdvDataModel alloc] initWithAdvertiseData:advData];
        tempModel.frameType = MKBXDAdvFrameType;
        return tempModel;
    }
    return nil;
}

+ (MKBXDDataFrameType)fetchFEAAFrameType:(NSData *)stoneData {
    if (!MKValidData(stoneData)) {
        return MKBXDUnknownFrameType;
    }
    //Eddystone信息帧
    if (stoneData.length == 0) {
        return MKBXDUnknownFrameType;
    }
    const unsigned char *cData = [stoneData bytes];
    switch (*cData) {
        case 0x00:
            return MKBXDUIDFrameType;
        default:
            return MKBXDUnknownFrameType;
    }
}

+ (MKBXDDataFrameType)fetchFEABFrameType:(NSData *)customData {
    if (!MKValidData(customData) || customData.length == 0) {
        return MKBXDUnknownFrameType;
    }
    const unsigned char *cData = [customData bytes];
    switch (*cData) {
        case 0x50:
            return MKBXDBeaconFrameType;
        default:
            return MKBXDUnknownFrameType;
    }
}

@end


@implementation MKBXDAdvDataModel

- (MKBXDAdvDataModel *)initWithAdvertiseData:(NSData *)advData {
    if (self = [super init]) {
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:advData];
        NSString *typeString = [content substringWithRange:NSMakeRange(0, 2)];
        MKBXDAdvAlarmType alarmType = MKBXDAdvAlarmType_single;
        if ([typeString isEqualToString:@"21"]) {
            alarmType = MKBXDAdvAlarmType_double;
        }else if ([typeString isEqualToString:@"22"]) {
            alarmType = MKBXDAdvAlarmType_long;
        }else if ([typeString isEqualToString:@"23"]) {
            alarmType = MKBXDAdvAlarmType_abnormalInactivity;
        }
        self.alarmType = alarmType;
        NSString *state = [content substringWithRange:NSMakeRange(2, 2)];
        NSString *binary = [MKBLEBaseSDKAdopter binaryByhex:state];
        self.trigger = [[binary substringWithRange:NSMakeRange(6, 1)] isEqualToString:@"1"];
        self.triggerCount = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(4, 4)];
        NSInteger len = advData.length - 6;
        self.deviceID = [content substringWithRange:NSMakeRange(8, 2 * len)];
        self.deviceType = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(8 + 2 * len, 2)];
    }
    return self;
}

@end


@implementation MKBXDAdvRespondDataModel

- (MKBXDAdvRespondDataModel *)initRespondWithAdvertiseData:(NSData *)advData {
    if (self = [super init]) {
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:advData];
        self.fullScale = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 2)];
        self.motionThreshold = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(4, 4)];
        NSNumber *xValue = [MKBLEBaseSDKAdopter signedHexTurnString:[content substringWithRange:NSMakeRange(8, 4)]];
        self.xData = [NSString stringWithFormat:@"%ld",(long)[xValue integerValue]];
        NSNumber *yValue = [MKBLEBaseSDKAdopter signedHexTurnString:[content substringWithRange:NSMakeRange(12, 4)]];
        self.yData = [NSString stringWithFormat:@"%ld",(long)[yValue integerValue]];
        NSNumber *zValue = [MKBLEBaseSDKAdopter signedHexTurnString:[content substringWithRange:NSMakeRange(16, 4)]];
        self.zData = [NSString stringWithFormat:@"%ld",(long)[zValue integerValue]];
        NSString *temperature = [content substringWithRange:NSMakeRange(20, 4)];
        if ([temperature isEqualToString:@"ffff"]) {
            //不支持芯片温度
            self.beaconTemperature = temperature;
        }else {
            //支持芯片温度
            NSNumber *tempHight = [MKBLEBaseSDKAdopter signedHexTurnString:[temperature substringWithRange:NSMakeRange(0, 2)]];
            NSInteger tempLow = [MKBLEBaseSDKAdopter getDecimalWithHex:temperature range:NSMakeRange(2, 2)];
            self.beaconTemperature = [NSString stringWithFormat:@"%ld.%.2f",(long)[tempHight integerValue],(tempLow / 256.f)];
        }
        NSNumber *tempRssi = [MKBLEBaseSDKAdopter signedHexTurnString:[content substringWithRange:NSMakeRange(24, 2)]];
        self.rangingData = [NSString stringWithFormat:@"%ld",(long)[tempRssi integerValue]];
        self.voltage = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(26, 4)];
        NSString *tempMac = [[content substringWithRange:NSMakeRange(30, 12)] uppercaseString];
        NSString *macAddress = [NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@",
        [tempMac substringWithRange:NSMakeRange(0, 2)],
        [tempMac substringWithRange:NSMakeRange(2, 2)],
        [tempMac substringWithRange:NSMakeRange(4, 2)],
        [tempMac substringWithRange:NSMakeRange(6, 2)],
        [tempMac substringWithRange:NSMakeRange(8, 2)],
        [tempMac substringWithRange:NSMakeRange(10, 2)]];
        self.macAddress = macAddress;
    }
    return self;
}

@end



@implementation MKBXDBeacon

- (MKBXDBeacon *)initWithAdvertiseData:(NSData *)advData {
    if (self = [super init]) {
        NSAssert1(!(advData.length < 7), @"Invalid advertiseData:%@", advData);

        const unsigned char *cData = [advData bytes];
        unsigned char *data;
        // Malloc advertise data for char*
        data = malloc(sizeof(unsigned char) * 2);
        if (!data) {
            return nil;
        }
        for (int i = 0; i < 2; i++) {
            data[i] = *cData++;
        }
        unsigned char txPowerChar = *(data+1);
        if (txPowerChar & 0x80) {
            self.rssi1M = [NSNumber numberWithInt:(- 0x100 + txPowerChar)];
        }
        else {
            self.rssi1M = [NSNumber numberWithInt:txPowerChar];
        }
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:advData];
        NSString *temp = [content substringWithRange:NSMakeRange(4, content.length - 4)];
        self.interval = [MKBLEBaseSDKAdopter getDecimalStringWithHex:temp range:NSMakeRange(0, 2)];
        NSMutableArray *array = [NSMutableArray arrayWithObjects:[temp substringWithRange:NSMakeRange(2, 8)],
                                 [temp substringWithRange:NSMakeRange(10, 4)],
                                 [temp substringWithRange:NSMakeRange(14, 4)],
                                 [temp substringWithRange:NSMakeRange(18,4)],
                                 [temp substringWithRange:NSMakeRange(22, 12)], nil];
        [array insertObject:@"-" atIndex:1];
        [array insertObject:@"-" atIndex:3];
        [array insertObject:@"-" atIndex:5];
        [array insertObject:@"-" atIndex:7];
        NSString *uuid = @"";
        for (NSString *string in array) {
            uuid = [uuid stringByAppendingString:string];
        }
        self.uuid = [uuid uppercaseString];
        self.major = [NSString stringWithFormat:@"%ld",(long)strtoul([[temp substringWithRange:NSMakeRange(34, 4)] UTF8String],0,16)];
        self.minor = [NSString stringWithFormat:@"%ld",(long)strtoul([[temp substringWithRange:NSMakeRange(38, 4)] UTF8String],0,16)];
        free(data);
    }
    return self;
}

@end


@implementation MKBXDUIDBeacon

- (MKBXDUIDBeacon *)initWithAdvertiseData:(NSData *)advData {
    if (self = [super init]) {
        // On the spec, its 20 bytes. But some beacons doesn't advertise the last 2 RFU bytes.
        if (advData.length < 18) {
            return nil;
        }
        const unsigned char *cData = [advData bytes];
        unsigned char *data;
        // Malloc advertise data for char*
        data = malloc(sizeof(unsigned char) * advData.length);
        NSAssert(data, @"failed to malloc");
        for (int i = 0; i < advData.length; i++) {
            data[i] = *cData++;
        }
        unsigned char txPowerChar = *(data+1);
        if (txPowerChar & 0x80) {
            self.txPower = [NSNumber numberWithInt:(- 0x100 + txPowerChar)];
        }
        else {
            self.txPower = [NSNumber numberWithInt:txPowerChar];
        }
        self.namespaceId = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",*(data+2), *(data+3), *(data+4), *(data+5), *(data+6), *(data+7), *(data+8), *(data+9), *(data+10), *(data+11)];
        self.instanceId = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x",*(data+12), *(data+13), *(data+14), *(data+15), *(data+16), *(data+17)];
        // Free advertise data for char*
        free(data);
    }
    return self;
}

@end
