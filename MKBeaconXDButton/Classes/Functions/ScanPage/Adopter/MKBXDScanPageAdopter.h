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

@end

NS_ASSUME_NONNULL_END
