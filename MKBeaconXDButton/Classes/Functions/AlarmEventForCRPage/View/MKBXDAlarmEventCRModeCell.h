//
//  MKBXDAlarmEventCRModeCell.h
//  MKBeaconXDButton_Example
//
//  Created by aa on 2025/3/19.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXDAlarmEventCRModeCellModel : NSObject

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, copy)NSString *count;

@end

@protocol MKBXDAlarmEventCRModeCellDelegate <NSObject>

- (void)bxd_alarmEventCRModeCell_clearBtnPressed:(NSInteger)index;

- (void)bxd_alarmEventCRModeCell_exportBtnPressed:(NSInteger)index;

@end

@interface MKBXDAlarmEventCRModeCell : MKBaseCell

@property (nonatomic, weak)id <MKBXDAlarmEventCRModeCellDelegate>delegate;

@property (nonatomic, strong)MKBXDAlarmEventCRModeCellModel *dataModel;

+ (MKBXDAlarmEventCRModeCell *)initCellWithTableView:(UITableView *)tableView;


@end

NS_ASSUME_NONNULL_END
