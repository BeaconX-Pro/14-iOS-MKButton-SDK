//
//  MKBXDSlotHubbleCell.h
//  MKBeaconXDButton_Example
//
//  Created by aa on 2026/11/6.
//  Copyright © 2026 aadyx2007@163.com. All rights reserved.
//

#import "MKBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKBXDSlotHubbleCellModel : NSObject

@property (nonatomic, copy)NSString *deviceKey;

@property (nonatomic, copy)NSString *deviceID;

@property (nonatomic, copy)NSString *rawData;

@end

@protocol MKBXDSlotHubbleCellDelegate <NSObject>

- (void)bxd_hubble_deviceKeyChanged:(NSString *)text;

- (void)bxd_hubble_deviceIDChanged:(NSString *)text;

- (void)bxd_hubble_rawDataChanged:(NSString *)text;

@end

@interface MKBXDSlotHubbleCell : MKBaseCell

@property (nonatomic, strong)MKBXDSlotHubbleCellModel *dataModel;

@property (nonatomic, weak)id <MKBXDSlotHubbleCellDelegate>delegate;

+ (MKBXDSlotHubbleCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
