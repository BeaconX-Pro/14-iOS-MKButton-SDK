//
//  MKBXDAlarmEventCell.h
//  MKBeaconXDButton_Example
//
//  Created by aa on 2025/10/9.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXDAlarmEventCellModel : NSObject

@property (nonatomic, copy)NSString *count;

@end

@protocol MKBXDAlarmEventCellDelegate <NSObject>

- (void)bxd_alarmEventCell_clearButtonPressed;

@end

@interface MKBXDAlarmEventCell : MKBaseCell

@property (nonatomic, weak)id <MKBXDAlarmEventCellDelegate>delegate;

@property (nonatomic, strong)MKBXDAlarmEventCellModel *dataModel;

+ (MKBXDAlarmEventCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
