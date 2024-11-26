//
//  MKBXDAlarmTypePickCell.h
//  MKBeaconXDButton_Example
//
//  Created by aa on 2024/11/26.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXDAlarmTypePickCellModel : NSObject

/*
 0:Silent
 1:LED
 2:Buzzer
 3:LED+Buzzer
 */
@property (nonatomic, assign)NSInteger triggerAlarmType;

@end

@protocol MKBXDAlarmTypePickCellDelegate <NSObject>

- (void)bxd_triggerAlarmTypeChanged:(NSInteger)triggerAlarmType;

@end

@interface MKBXDAlarmTypePickCell : MKBaseCell

@property (nonatomic, weak)id <MKBXDAlarmTypePickCellDelegate>delegate;

@property (nonatomic, strong)MKBXDAlarmTypePickCellModel *dataModel;

+ (MKBXDAlarmTypePickCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
