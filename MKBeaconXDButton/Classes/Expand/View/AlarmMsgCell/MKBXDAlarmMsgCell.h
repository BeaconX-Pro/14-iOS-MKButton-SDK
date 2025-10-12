//
//  MKBXDAlarmMsgCell.h
//  MKBeaconXDButton_Example
//
//  Created by aa on 2025/10/9.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXDAlarmMsgCellModel : NSObject

@property (nonatomic, copy)NSString *msg;

- (CGFloat )fetchCellHeight;

@end

@interface MKBXDAlarmMsgCell : MKBaseCell

@property (nonatomic, strong)MKBXDAlarmMsgCellModel *dataModel;

+ (MKBXDAlarmMsgCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
