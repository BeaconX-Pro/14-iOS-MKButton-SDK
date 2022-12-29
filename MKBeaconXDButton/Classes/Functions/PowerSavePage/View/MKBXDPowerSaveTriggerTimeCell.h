//
//  MKBXDPowerSaveTriggerTimeCell.h
//  MKBeaconXDButton_Example
//
//  Created by aa on 2022/2/22.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXDPowerSaveTriggerTimeCellModel : NSObject

@property (nonatomic, copy)NSString *time;

@end

@protocol MKBXDPowerSaveTriggerTimeCellDelegate <NSObject>

- (void)bxd_powerSaveTriggerTimeChanged:(NSString *)time;

@end

@interface MKBXDPowerSaveTriggerTimeCell : MKBaseCell

@property (nonatomic, strong)MKBXDPowerSaveTriggerTimeCellModel *dataModel;

@property (nonatomic, weak)id <MKBXDPowerSaveTriggerTimeCellDelegate>delegate;

+ (MKBXDPowerSaveTriggerTimeCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
