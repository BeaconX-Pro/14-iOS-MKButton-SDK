//
//  MKBXDScanDeviceDataCell.h
//  MKBeaconXDButton_Example
//
//  Created by aa on 2022/2/26.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@class CBPeripheral;
@class MKBXDScanDataModel;
@protocol MKBXDScanDeviceDataCellDelegate <NSObject>

- (void)mk_bxd_connectPeripheral:(CBPeripheral *)peripheral;

@end
@interface MKBXDScanDeviceDataCell : MKBaseCell

@property (nonatomic, strong)MKBXDScanDataModel *dataModel;

@property (nonatomic, weak)id <MKBXDScanDeviceDataCellDelegate>delegate;

+ (MKBXDScanDeviceDataCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
