//
//  MKBXDTriggerTypeClickCell.h
//  MKBeaconXDButton_Example
//
//  Created by aa on 2024/11/26.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXDTriggerTypeClickCellModel : NSObject

@property (nonatomic, assign)BOOL selected;

@end

@protocol MKBXDTriggerTypeClickCellDelegate <NSObject>

- (void)bxd_triggerTypeClickCell_pressed:(BOOL)selected;

@end

@interface MKBXDTriggerTypeClickCell : MKBaseCell

@property (nonatomic, strong)MKBXDTriggerTypeClickCellModel *dataModel;

@property (nonatomic, weak)id <MKBXDTriggerTypeClickCellDelegate>delegate;

+ (MKBXDTriggerTypeClickCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
