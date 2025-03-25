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
 BXP-B-D:
 0:Silent
 1:LED
 2:Buzzer
 3:LED+Buzzer
 
 BXP-CR:
 0:Silent
 1:LED
 2:Vibaration
 3:Buzzer
 4:LED+Vibaration
 5:LED+Buzzer
 */
@property (nonatomic, assign)NSInteger triggerAlarmType;

/// BXP-B-D:    @[@"Silent",@"LED",@"Buzzer",@"LED+Buzzer"]
/// BXP-CR:     @[@"Silent",@"LED",@"Vibration",@"Buzzer",@"LED+Vibration",@"LED+Buzzer"]
@property (nonatomic, strong)NSArray *typeList;

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
