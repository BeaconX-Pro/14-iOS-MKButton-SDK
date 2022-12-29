//
//  MKBXDBaseAdvModel.m
//  MKBeaconXDButton_Example
//
//  Created by aa on 2022/2/23.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXDBaseAdvModel.h"

#import <CoreBluetooth/CoreBluetooth.h>

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
    NSData *scanData = advDic[[CBUUID UUIDWithString:@"FEE0"]];
    NSData *respondData = advDic[[CBUUID UUIDWithString:@"EA00"]];
    if (!MKValidData(scanData)) {
        return @[];
    }
    NSMutableArray *dataList = [NSMutableArray array];
    MKBXDBaseAdvModel *scanModel = [self parseAdvModeWithData:scanData];
    MKBXDBaseAdvModel *respondModel = [self parseAdvModeWithData:respondData];
    if (respondModel && [respondModel isKindOfClass:MKBXDAdvRespondDataModel.class]) {
        //回应包内容
        MKBXDAdvRespondDataModel *tempModel = (MKBXDAdvRespondDataModel *)respondModel;
        tempModel.txPower = advData[CBAdvertisementDataTxPowerLevelKey];
        tempModel.rssi = RSSI;
        tempModel.connectEnable = [advData[CBAdvertisementDataIsConnectable] boolValue];
        tempModel.identifier = peripheral.identifier.UUIDString;
        tempModel.peripheral = peripheral;
        tempModel.advertiseData = respondData;
        tempModel.deviceName = advData[CBAdvertisementDataLocalNameKey];
        [dataList addObject:tempModel];
    }
    if (scanModel && [scanModel isKindOfClass:MKBXDAdvDataModel.class]) {
        //触发广播包
        MKBXDAdvDataModel *tempModel = (MKBXDAdvDataModel *)scanModel;
        tempModel.rssi = RSSI;
        tempModel.connectEnable = [advData[CBAdvertisementDataIsConnectable] boolValue];
        tempModel.identifier = peripheral.identifier.UUIDString;
        tempModel.peripheral = peripheral;
        tempModel.advertiseData = respondData;
        tempModel.deviceName = advData[CBAdvertisementDataLocalNameKey];
        [dataList addObject:tempModel];
    }
    
    return dataList;
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
