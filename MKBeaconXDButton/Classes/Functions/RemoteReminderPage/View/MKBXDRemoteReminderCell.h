//
//  MKBXDRemoteReminderCell.h
//  MKBeaconXDButton_Example
//
//  Created by aa on 2022/3/3.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXDRemoteReminderCellModel : NSObject

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, assign)NSInteger index;

@end

@protocol MKBXDRemoteReminderCellDelegate <NSObject>

- (void)bxd_remindButtonPressed:(NSInteger)index;

@end

@interface MKBXDRemoteReminderCell : MKBaseCell

@property (nonatomic, strong)MKBXDRemoteReminderCellModel *dataModel;

@property (nonatomic, weak)id <MKBXDRemoteReminderCellDelegate>delegate;

+ (MKBXDRemoteReminderCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
