//
//  MKBXDAlarmV2EventCell.h
//  MKBeaconXDButton_Example
//
//  Created by aa on 2025/10/9.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXDAlarmV2EventCellModel : NSObject

@property (nonatomic, copy)NSString *mainCount;

@property (nonatomic, copy)NSString *subCount;

@end

@protocol MKBXDAlarmV2EventCellDelegate <NSObject>

- (void)bxd_alarmV2EventCell_clearButtonPressed;

@end

@interface MKBXDAlarmV2EventCell : MKBaseCell

@property (nonatomic, weak)id <MKBXDAlarmV2EventCellDelegate>delegate;

@property (nonatomic, strong)MKBXDAlarmV2EventCellModel *dataModel;

+ (MKBXDAlarmV2EventCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
