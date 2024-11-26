//
//  MKBXDSlotBeaconCell.h
//  MKBeaconXDButton_Example
//
//  Created by aa on 2024/1/18.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXDSlotBeaconCellModel : NSObject

@property (nonatomic, copy)NSString *major;

@property (nonatomic, copy)NSString *minor;

@property (nonatomic, copy)NSString *uuid;

@end

@protocol MKBXDSlotBeaconCellDelegate <NSObject>

- (void)bxd_advContent_majorChanged:(NSString *)major;

- (void)bxd_advContent_minorChanged:(NSString *)minor;

- (void)bxd_advContent_uuidChanged:(NSString *)uuid;

@end

@interface MKBXDSlotBeaconCell : MKBaseCell

@property (nonatomic, strong)MKBXDSlotBeaconCellModel *dataModel;

@property (nonatomic, weak)id <MKBXDSlotBeaconCellDelegate>delegate;

+ (MKBXDSlotBeaconCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
