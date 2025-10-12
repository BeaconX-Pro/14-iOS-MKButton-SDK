//
//  MKBXDAlarmEventDBCountCell.h
//  MKBeaconXDButton_Example
//
//  Created by aa on 2025/10/10.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXDAlarmEventDBCountCellModel : NSObject

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, copy)NSString *mainCount;

@property (nonatomic, copy)NSString *subCount;

@end

@protocol MKBXDAlarmEventDBCountCellDelegate <NSObject>

- (void)bxd_alarmEventDBCell_mainClearButtonPressed:(NSInteger)index;

- (void)bxd_alarmEventDBCell_subClearButtonPressed:(NSInteger)index;

@end

@interface MKBXDAlarmEventDBCountCell : MKBaseCell

@property (nonatomic, strong)MKBXDAlarmEventDBCountCellModel *dataModel;

@property (nonatomic, weak)id <MKBXDAlarmEventDBCountCellDelegate>delegate;

+ (MKBXDAlarmEventDBCountCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
