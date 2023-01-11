//
//  MKBXDAdopter.m
//  MKBeaconXDButton_Example
//
//  Created by aa on 2022/2/18.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXDAdopter.h"

#import "MKBLEBaseSDKDefines.h"
#import "MKBLEBaseSDKAdopter.h"

@implementation MKBXDAdopter

+ (BOOL)validTriggerChannelAdvParamsProtocol:(id <MKBXDTriggerChannelAdvParamsProtocol>)protocol {
    if (!protocol) {
        return NO;
    }
    if (protocol.rssi < -100 || protocol.rssi > 0) {
        return NO;
    }
    if (!MKValidStr(protocol.advInterval) || [protocol.advInterval integerValue] < 1 || [protocol.advInterval integerValue] > 500) {
        return NO;
    }
    return YES;
}

+ (NSString *)parseTriggerChannelAdvParamsProtocol:(id <MKBXDTriggerChannelAdvParamsProtocol>)protocol {
    if (![self validTriggerChannelAdvParamsProtocol:protocol]) {
        return @"";
    }
    NSString *channel = [MKBLEBaseSDKAdopter fetchHexValue:protocol.alarmType byteLen:1];
    NSString *state = (protocol.isOn ? @"01" : @"00");
    NSString *rssiValue = [MKBLEBaseSDKAdopter hexStringFromSignedNumber:protocol.rssi];
    NSString *advInterval = [MKBLEBaseSDKAdopter fetchHexValue:([protocol.advInterval integerValue] * 20) byteLen:2];
    NSString *txPower = [self fetchTxPower:protocol.txPower];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@%@%@",@"ea013406",channel,state,rssiValue,advInterval,txPower];
    return commandString;
}

+ (BOOL)validChannelTriggerParamsProtocol:(id <MKBXDChannelTriggerParamsProtocol>)protocol {
    if (!protocol) {
        return NO;
    }
    if (protocol.rssi < -100 || protocol.rssi > 0) {
        return NO;
    }
    if (!MKValidStr(protocol.advInterval) || [protocol.advInterval integerValue] < 1 || [protocol.advInterval integerValue] > 500) {
        return NO;
    }
    if (!MKValidStr(protocol.advertisingTime) || [protocol.advertisingTime integerValue] < 1 || [protocol.advertisingTime integerValue] > 65535) {
        return NO;
    }
    return YES;
}

+ (NSString *)parseChannelTriggerParamsProtocol:(id <MKBXDChannelTriggerParamsProtocol>)protocol {
    if (![self validChannelTriggerParamsProtocol:protocol]) {
        return @"";
    }
    NSString *channel = [MKBLEBaseSDKAdopter fetchHexValue:protocol.alarmType byteLen:1];
    NSString *state = (protocol.alarm ? @"01" : @"00");
    NSString *rssiValue = [MKBLEBaseSDKAdopter hexStringFromSignedNumber:protocol.rssi];
    NSString *advInterval = [MKBLEBaseSDKAdopter fetchHexValue:([protocol.advInterval integerValue] * 20) byteLen:2];
    NSString *txPower = [self fetchTxPower:protocol.txPower];
    NSString *advTime = [MKBLEBaseSDKAdopter fetchHexValue:[protocol.advertisingTime integerValue] byteLen:2];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",@"ea013508",channel,state,rssiValue,advInterval,txPower,advTime];
    return commandString;
}

+ (NSString *)fetchTxPower:(mk_bxd_txPower)txPower {
    switch (txPower) {
        case mk_bxd_txPower4dBm:
            return @"04";
            
        case mk_bxd_txPower3dBm:
            return @"03";
            
        case mk_bxd_txPower0dBm:
            return @"00";
            
        case mk_bxd_txPowerNeg4dBm:
            return @"fc";
            
        case mk_bxd_txPowerNeg8dBm:
            return @"f8";
            
        case mk_bxd_txPowerNeg12dBm:
            return @"f4";
            
        case mk_bxd_txPowerNeg16dBm:
            return @"f0";
            
        case mk_bxd_txPowerNeg20dBm:
            return @"ec";
            
        case mk_bxd_txPowerNeg40dBm:
            return @"d8";
    }
}

+ (NSString *)fetchTxPowerValueString:(NSString *)content {
    if ([content isEqualToString:@"04"]) {
        return @"4dBm";
    }
    if ([content isEqualToString:@"03"]) {
        return @"3dBm";
    }
    if ([content isEqualToString:@"00"]) {
        return @"0dBm";
    }
    if ([content isEqualToString:@"fc"]) {
        return @"-4dBm";
    }
    if ([content isEqualToString:@"f8"]) {
        return @"-8dBm";
    }
    if ([content isEqualToString:@"f4"]) {
        return @"-12dBm";
    }
    if ([content isEqualToString:@"f0"]) {
        return @"-16dBm";
    }
    if ([content isEqualToString:@"ec"]) {
        return @"-20dBm";
    }
    if ([content isEqualToString:@"d8"]) {
        return @"-40dBm";
    }
    return @"0dBm";
}

+ (NSString *)fetchReminderTypeString:(mk_bxd_reminderType)type {
    switch (type) {
        case mk_bxd_reminderType_silent:
            return @"00";
        case mk_bxd_reminderType_led:
            return @"01";
        case mk_bxd_reminderType_buzzer:
            return @"03";
        case mk_bxd_reminderType_ledAndBuzzer:
            return @"05";
    }
}

+ (NSString *)fetchThreeAxisDataRate:(mk_bxd_threeAxisDataRate)dataRate {
    switch (dataRate) {
        case mk_bxd_threeAxisDataRate1hz:
            return @"00";
        case mk_bxd_threeAxisDataRate10hz:
            return @"01";
        case mk_bxd_threeAxisDataRate25hz:
            return @"02";
        case mk_bxd_threeAxisDataRate50hz:
            return @"03";
        case mk_bxd_threeAxisDataRate100hz:
            return @"04";
    }
}

+ (NSString *)fetchThreeAxisDataAG:(mk_bxd_threeAxisDataAG)ag {
    switch (ag) {
        case mk_bxd_threeAxisDataAG0:
            return @"00";
        case mk_bxd_threeAxisDataAG1:
            return @"01";
        case mk_bxd_threeAxisDataAG2:
            return @"02";
        case mk_bxd_threeAxisDataAG3:
            return @"03";
    }
}

@end
