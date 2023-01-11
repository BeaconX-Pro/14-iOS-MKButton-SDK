//
//  MKBXDAlarmEventCountCell.h
//  MKBeaconXDButton_Example
//
//  Created by aa on 2022/2/22.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXDAlarmEventCountCellModel : NSObject

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, copy)NSString *count;

@end

@protocol MKBXDAlarmEventCountCellDelegate <NSObject>

- (void)bxd_alarmEvent_clearButtonPressed:(NSInteger)index;

@end

@interface MKBXDAlarmEventCountCell : MKBaseCell

@property (nonatomic, strong)MKBXDAlarmEventCountCellModel *dataModel;

@property (nonatomic, weak)id <MKBXDAlarmEventCountCellDelegate>delegate;

+ (MKBXDAlarmEventCountCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
