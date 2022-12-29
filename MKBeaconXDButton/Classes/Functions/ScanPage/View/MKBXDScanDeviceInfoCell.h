//
//  MKBXDScanDeviceInfoCell.h
//  MKBeaconXDButton_Example
//
//  Created by aa on 2022/2/26.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXDScanDeviceInfoCellModel : NSObject

@property (nonatomic, copy)NSString *rangingData;

@property (nonatomic, copy)NSString *xData;

@property (nonatomic, copy)NSString *yData;

@property (nonatomic, copy)NSString *zData;

@end

@interface MKBXDScanDeviceInfoCell : MKBaseCell

@property (nonatomic, strong)MKBXDScanDeviceInfoCellModel *dataModel;

+ (MKBXDScanDeviceInfoCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
