//
//  MKBXDAbnormalInactivityTimeCell.h
//  MKBeaconXDButton_Example
//
//  Created by aa on 2022/2/21.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXDAbnormalInactivityTimeCellModel : NSObject

@property (nonatomic, copy)NSString *time;

@property (nonatomic, copy)NSString *advTime;

@end

@protocol MKBXDAbnormalInactivityTimeCellDelegate <NSObject>

- (void)bxd_abnormalInactivityTimeChanged:(NSString *)time;

@end

@interface MKBXDAbnormalInactivityTimeCell : MKBaseCell

@property (nonatomic, strong)MKBXDAbnormalInactivityTimeCellModel *dataModel;

@property (nonatomic, weak)id <MKBXDAbnormalInactivityTimeCellDelegate>delegate;

+ (MKBXDAbnormalInactivityTimeCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
