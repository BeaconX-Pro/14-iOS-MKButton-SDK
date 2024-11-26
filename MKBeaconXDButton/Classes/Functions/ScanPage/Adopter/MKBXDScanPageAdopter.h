//
//  MKBXDScanPageAdopter.h
//  MKBeaconXDButton_Example
//
//  Created by aa on 2022/2/24.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MKBXDBaseAdvModel;
@class MKBXDScanDataModel;
@interface MKBXDScanPageAdopter : NSObject

/// 将扫描到的数据转换成对应的MKBXDScanAdvCellModel
+ (NSObject *)parseAdvDatas:(MKBXDBaseAdvModel *)advModel;

/// 将扫描到的数据转换成对应的MKBXDScanDataModel
+ (MKBXDScanDataModel *)parseBaseAdvDataToInfoModel:(MKBXDBaseAdvModel *)advData;

/// 新扫描到的数据已经在列表的数据源中存在，则需要替换，不存在则添加

/// @param exsitModel 列表数据源中已经存在的数据
/// @param advData 刚扫描到的广播数据
+ (void)updateInfoCellModel:(MKBXDScanDataModel *)exsitModel advData:(MKBXDBaseAdvModel *)advData;

/// 根据不同的dataModel加载cell
/*
 目前支持
 MKBXDcanBeaconCell:        iBeacon广播帧(对应的dataModel是MKBXDcanBeaconCellModel类型)
 MKBXDcanUIDCell:           UID广播帧(对应的dataModel是MKBXDcanUIDCellModel类型)
 MKBXDScanDeviceInfoCell:   设备信息帧
 MKBXDScanAdvCell:          广播帧
 如果不是其中的一种，则返回一个初始化的UITableViewCell
 */
/// @param tableView tableView
/// @param dataModel dataModel
+ (UITableViewCell *)loadCellWithTableView:(UITableView *)tableView dataModel:(NSObject *)dataModel;

/// 根据不同的dataModel返回cell的高度
/*
 目前支持
 根据UUID动态计算:        iBeacon广播帧(对应的dataModel是MKBXDcanBeaconCellModel类型)
 85.f:                  UID广播帧(对应的dataModel是MKBXDcanUIDCellModel类型)
 105.f:                 Device Info信息帧(对应的dataModel是MKBXDScanDeviceInfoCellModel类型)
 70.f:                  Adv广播帧(对应的dataModel是MKBXDScanAdvCellModel类型)
 如果不是其中的一种，则返回0
 */
/// @param indexPath indexPath
+ (CGFloat)loadCellHeightWithDataModel:(NSObject *)dataModel;

@end

NS_ASSUME_NONNULL_END
