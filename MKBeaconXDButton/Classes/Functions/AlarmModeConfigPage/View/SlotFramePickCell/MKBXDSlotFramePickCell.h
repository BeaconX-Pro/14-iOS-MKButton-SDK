//
//  MKBXDSlotFramePickCell.h
//  MKBeaconXDButton_Example
//
//  Created by aa on 2024/11/25.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

#import "MKBXDSlotConfigDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKBXDSlotFramePickCellModel : NSObject

@property (nonatomic, assign)bxd_slotType frameType;

@end

@protocol MKBXDSlotFramePickCellDelegate <NSObject>

- (void)bxd_slotFrameTypeChanged:(bxd_slotType)frameType;

@end

@interface MKBXDSlotFramePickCell : MKBaseCell

@property (nonatomic, weak)id <MKBXDSlotFramePickCellDelegate>delegate;

@property (nonatomic, strong)MKBXDSlotFramePickCellModel *dataModel;

+ (MKBXDSlotFramePickCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
