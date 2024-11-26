//
//  MKBXDAlarmV2MsgCell.h
//  MKBeaconXDButton_Example
//
//  Created by aa on 2024/11/25.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXDAlarmV2MsgCellModel : NSObject

@property (nonatomic, copy)NSString *msg;

- (CGFloat )fetchCellHeight;

@end

@interface MKBXDAlarmV2MsgCell : MKBaseCell

@property (nonatomic, strong)MKBXDAlarmV2MsgCellModel *dataModel;

+ (MKBXDAlarmV2MsgCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
