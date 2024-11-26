//
//  MKBXDSlotParamCell.h
//  MKBeaconXDButton_Example
//
//  Created by aa on 2022/7/25.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

#import "MKBXDSlotConfigDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKBXDSlotParamCellModel : NSObject

@property (nonatomic, assign)bxd_slotType cellType;

@property (nonatomic, copy)NSString *interval;

@property (nonatomic, assign)NSInteger rssi;

/*
 0:-20dBm
 1:-16dBm
 2:-12dBm
 3:-8dBm
 4:-4dBm
 5:0dBm
 6:3dBm
 7:4dBm
 8:6dBm
 */
@property (nonatomic, assign)NSInteger txPower;

@end

@protocol MKBXDSlotParamCellDelegate <NSObject>

- (void)bxd_slotParam_advIntervalChanged:(NSString *)interval;

- (void)bxd_slotParam_rssiChanged:(NSInteger)rssi;

- (void)bxd_slotParam_txPowerChanged:(NSInteger)txPower;

@end

@interface MKBXDSlotParamCell : MKBaseCell

@property (nonatomic, strong)MKBXDSlotParamCellModel *dataModel;

@property (nonatomic, weak)id <MKBXDSlotParamCellDelegate>delegate;

+ (MKBXDSlotParamCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
