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
 0:-40dBm
 1:-20dBm
 2:-16dBm
 3:-12dBm
 4:-8dBm
 5:-4dBm
 6:0dBm
 7:+3dBm
 8:+4dBm
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
