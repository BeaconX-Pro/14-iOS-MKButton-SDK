//
//  MKBXDScanPageAdopter.m
//  MKBeaconXDButton_Example
//
//  Created by aa on 2022/2/24.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXDScanPageAdopter.h"

#import <CoreBluetooth/CoreBluetooth.h>

#import <objc/runtime.h>

#import "MKMacroDefines.h"

#import "MKBXScanBeaconCell.h"
#import "MKBXScanUIDCell.h"

#import "MKBXDScanDeviceDataCell.h"
#import "MKBXDScanAdvCell.h"
#import "MKBXDScanDeviceInfoCell.h"

#import "MKBXDScanDataModel.h"

#import "MKBXDBaseAdvModel.h"

#pragma mark - *********************此处分类为了对数据列表里面的设备信息帧数据和设备信息帧数据里面的广播帧数据进行替换和排序使用**********************

static const char *indexKey = "indexKey";
static const char *frameTypeKey = "frameTypeKey";

@interface NSObject (MKBXDcanAdd)

/// 用来标示数据model在设备列表或者设备信息广播帧数组里的index
@property (nonatomic, assign)NSInteger index;

/*
 用来对同一个设备的广播帧进行排序，顺序为
 MKBXDAdvAlarmType_single,(MKBXDAdvFrameType)
 MKBXDAdvAlarmType_double,(MKBXDAdvFrameType)
 MKBXDAdvAlarmType_long,(MKBXDAdvFrameType)
 MKBXDAdvAlarmType_abnormalInactivity,(MKBXDAdvFrameType)
 MKBXDRespondFrameType,
 MKBXDUIDFrameType,
 MKBXDBeaconFrameType
 */
@property (nonatomic, assign)NSInteger frameIndex;

@end

@implementation NSObject (MKBXDcanAdd)

- (void)setIndex:(NSInteger)index {
    objc_setAssociatedObject(self, &indexKey, @(index), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)index {
    return [objc_getAssociatedObject(self, &indexKey) integerValue];
}

- (void)setFrameIndex:(NSInteger)frameIndex {
    objc_setAssociatedObject(self, &frameTypeKey, @(frameIndex), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)frameIndex {
    return [objc_getAssociatedObject(self, &frameTypeKey) integerValue];
}

@end




#pragma mark - *****************************MKBXDScanPageAdopter**********************


@implementation MKBXDScanPageAdopter

+ (NSObject *)parseAdvDatas:(MKBXDBaseAdvModel *)advModel {
    if ([advModel isKindOfClass:MKBXDBeacon.class]) {
        //iBeacon
        MKBXDBeacon *tempModel = (MKBXDBeacon *)advModel;
        MKBXScanBeaconCellModel *cellModel = [[MKBXScanBeaconCellModel alloc] init];
        cellModel.rssi = [NSString stringWithFormat:@"%ld",(long)[tempModel.rssi integerValue]];
        cellModel.rssi1M = [NSString stringWithFormat:@"%ld",(long)[tempModel.rssi1M integerValue]];
        cellModel.txPower = [NSString stringWithFormat:@"%ld",(long)[tempModel.txPower integerValue]];
        cellModel.interval = tempModel.interval;
        cellModel.major = tempModel.major;
        cellModel.minor = tempModel.minor;
        cellModel.uuid = [tempModel.uuid lowercaseString];
        return cellModel;
    }
    if ([advModel isKindOfClass:MKBXDUIDBeacon.class]) {
        //UID
        MKBXDUIDBeacon *tempModel = (MKBXDUIDBeacon *)advModel;
        MKBXScanUIDCellModel *cellModel = [[MKBXScanUIDCellModel alloc] init];
        cellModel.txPower = [NSString stringWithFormat:@"%ld",(long)[tempModel.txPower integerValue]];
        cellModel.namespaceId = tempModel.namespaceId;
        cellModel.instanceId = tempModel.instanceId;
        return cellModel;
    }
    if ([advModel isKindOfClass:MKBXDAdvDataModel.class]) {
        //触发数据包
        MKBXDAdvDataModel *tempModel = (MKBXDAdvDataModel *)advModel;
        MKBXDScanAdvCellModel *cellModel = [[MKBXDScanAdvCellModel alloc] init];
        cellModel.alarmMode = tempModel.alarmType;
        cellModel.triggerStatus = tempModel.trigger;
        cellModel.triggerCount = tempModel.triggerCount;
        
        return cellModel;
    }
    if ([advModel isKindOfClass:MKBXDAdvRespondDataModel.class]) {
        //芯片信息报
        MKBXDAdvRespondDataModel *tempModel = (MKBXDAdvRespondDataModel *)advModel;
        MKBXDScanDeviceInfoCellModel *cellModel = [[MKBXDScanDeviceInfoCellModel alloc] init];
        cellModel.rangingData = [tempModel.rangingData stringByAppendingString:@"dBm"];
        cellModel.xData = [SafeStr(tempModel.xData) stringByAppendingString:@"mg"];
        cellModel.yData = [SafeStr(tempModel.yData) stringByAppendingString:@"mg"];
        cellModel.zData = [SafeStr(tempModel.zData) stringByAppendingString:@"mg"];
        
        return cellModel;
    }
    return nil;
}

+ (MKBXDScanDataModel *)parseBaseAdvDataToInfoModel:(MKBXDBaseAdvModel *)advData {
    if (!advData || ![advData isKindOfClass:MKBXDBaseAdvModel.class]) {
        return [[MKBXDScanDataModel alloc] init];
    }
    MKBXDScanDataModel *deviceModel = [[MKBXDScanDataModel alloc] init];
    deviceModel.identifier = advData.peripheral.identifier.UUIDString;
    deviceModel.rssi = [NSString stringWithFormat:@"%ld",(long)[advData.rssi integerValue]];
    deviceModel.displayTime = @"N/A";
    deviceModel.lastScanDate = [[NSDate date] timeIntervalSince1970] * 1000;
    deviceModel.connectEnable = advData.connectEnable;
    deviceModel.peripheral = advData.peripheral;
    NSInteger frameType = 0;
    if ([advData isKindOfClass:MKBXDAdvRespondDataModel.class]) {
        //如果是回应包
        MKBXDAdvRespondDataModel *tempDataModel = (MKBXDAdvRespondDataModel *)advData;
        deviceModel.battery = tempDataModel.voltage;
        deviceModel.txPower = [NSString stringWithFormat:@"%ld",(long)[tempDataModel.txPower integerValue]];
        deviceModel.macAddress = SafeStr(tempDataModel.macAddress);
        frameType = 4;
    }else if ([advData isKindOfClass:MKBXDAdvDataModel.class]) {
        MKBXDAdvDataModel *tempDataModel = (MKBXDAdvDataModel *)advData;
        deviceModel.deviceName = SafeStr(tempDataModel.deviceName);
        frameType = tempDataModel.alarmType;
        deviceModel.deviceID = tempDataModel.deviceID;
    }else if ([advData isKindOfClass:MKBXDUIDBeacon.class]) {
        frameType = 5;
    }else if ([advData isKindOfClass:MKBXDBeacon.class]) {
        frameType = 6;
    }
    
    NSObject *obj = [self parseAdvDatas:advData];
    if (!obj) {
        return deviceModel;
    }
    obj.index = 0;
    obj.frameIndex = frameType;
    [deviceModel.advertiseList addObject:obj];
    
    return deviceModel;
}

+ (void)updateInfoCellModel:(MKBXDScanDataModel *)exsitModel advData:(MKBXDBaseAdvModel *)advData {
    exsitModel.connectEnable = advData.connectEnable;
    exsitModel.peripheral = advData.peripheral;
    exsitModel.rssi = [NSString stringWithFormat:@"%ld",(long)[advData.rssi integerValue]];
    if (exsitModel.lastScanDate > 0) {
        NSTimeInterval space = [[NSDate date] timeIntervalSince1970] * 1000 - exsitModel.lastScanDate;
        if (space > 10) {
            exsitModel.displayTime = [NSString stringWithFormat:@"%@%ld%@",@"<->",(long)space,@"ms"];
            exsitModel.lastScanDate = [[NSDate date] timeIntervalSince1970] * 1000;
        }
    }
    NSInteger frameType = 0;
    if ([advData isKindOfClass:MKBXDAdvRespondDataModel.class]) {
        //如果是回应包
        MKBXDAdvRespondDataModel *tempDataModel = (MKBXDAdvRespondDataModel *)advData;
        exsitModel.battery = tempDataModel.voltage;
        exsitModel.txPower = [NSString stringWithFormat:@"%ld",(long)[tempDataModel.txPower integerValue]];
        exsitModel.macAddress = SafeStr(tempDataModel.macAddress);
        frameType = 4;
    }else if ([advData isKindOfClass:MKBXDAdvDataModel.class]) {
        MKBXDAdvDataModel *tempDataModel = (MKBXDAdvDataModel *)advData;
        exsitModel.deviceName = SafeStr(tempDataModel.deviceName);
        frameType = tempDataModel.alarmType;
        exsitModel.deviceID = tempDataModel.deviceID;
    }else if ([advData isKindOfClass:MKBXDUIDBeacon.class]) {
        frameType = 5;
    }else if ([advData isKindOfClass:MKBXDBeacon.class]) {
        frameType = 6;
    }
    NSObject *tempModel = [self parseAdvDatas:advData];
    if (!tempModel) {
        return;
    }
    tempModel.frameIndex = frameType;
    for (NSObject *model in exsitModel.advertiseList) {
        if (tempModel.frameIndex == model.frameIndex) {
            //需要替换
            tempModel.index = model.index;
            [exsitModel.advertiseList replaceObjectAtIndex:model.index withObject:tempModel];
            return;
        }
    }
    //如果eddStone帧数组里面不包含该数据，直接添加
    [exsitModel.advertiseList addObject:tempModel];
    tempModel.index = exsitModel.advertiseList.count - 1;
    NSArray *tempArray = [NSArray arrayWithArray:exsitModel.advertiseList];
    NSArray *sortedArray = [tempArray sortedArrayUsingComparator:^NSComparisonResult(NSObject *p1, NSObject *p2){
        if (p1.frameIndex > p2.frameIndex) {
            return NSOrderedDescending;
        }else{
            return NSOrderedAscending;
        }
    }];
    [exsitModel.advertiseList removeAllObjects];
    for (NSInteger i = 0; i < sortedArray.count; i ++) {
        NSObject *tempModel = sortedArray[i];
        tempModel.index = i;
        [exsitModel.advertiseList addObject:tempModel];
    }
}

+ (UITableViewCell *)loadCellWithTableView:(UITableView *)tableView dataModel:(NSObject *)dataModel {
    if ([dataModel isKindOfClass:MKBXScanUIDCellModel.class]) {
        //UID
        MKBXScanUIDCell *cell = [MKBXScanUIDCell initCellWithTableView:tableView];
        cell.dataModel = dataModel;
        return cell;
    }
    if ([dataModel isKindOfClass:MKBXScanBeaconCellModel.class]){
        //iBeacon
        MKBXScanBeaconCell *cell = [MKBXScanBeaconCell initCellWithTableView:tableView];
        cell.dataModel = dataModel;
        return cell;
    }
    if ([dataModel isKindOfClass:MKBXDScanDeviceInfoCellModel.class]) {
        //Device Info
        MKBXDScanDeviceInfoCell *cell = [MKBXDScanDeviceInfoCell initCellWithTableView:tableView];
        cell.dataModel = dataModel;
        return cell;
    }
    if ([dataModel isKindOfClass:MKBXDScanAdvCellModel.class]) {
        //Adv Data
        MKBXDScanAdvCell *cell = [MKBXDScanAdvCell initCellWithTableView:tableView];
        cell.dataModel = dataModel;
        return cell;
    }
    
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKBXDScanPageAdopterIdenty"];
}

+ (CGFloat)loadCellHeightWithDataModel:(NSObject *)dataModel {
    if ([dataModel isKindOfClass:MKBXScanUIDCellModel.class]) {
        //UID
        return 85.f;
    }
    if ([dataModel isKindOfClass:MKBXScanBeaconCellModel.class]){
        //iBeacon
        MKBXScanBeaconCellModel *model = (MKBXScanBeaconCellModel *)dataModel;
        return [MKBXScanBeaconCell getCellHeightWithUUID:model.uuid];
    }
    if ([dataModel isKindOfClass:MKBXDScanDeviceInfoCellModel.class]) {
        //Device Info
        return 105.f;
    }
    if ([dataModel isKindOfClass:MKBXDScanAdvCellModel.class]) {
        //Adv Data
        return 70.f;
    }
    
    return 0;
}

@end
