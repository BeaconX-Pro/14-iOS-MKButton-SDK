//
//  MKBXDSlotUIDCell.h
//  MKBeaconXDButton_Example
//
//  Created by aa on 2024/1/18.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXDSlotUIDCellModel : NSObject

@property (nonatomic, copy)NSString *namespaceID;

@property (nonatomic, copy)NSString *instanceID;

@end

@protocol MKBXDSlotUIDCellDelegate <NSObject>

- (void)bxd_advContent_namespaceIDChanged:(NSString *)text;

- (void)bxd_advContent_instanceIDChanged:(NSString *)text;

@end

@interface MKBXDSlotUIDCell : MKBaseCell

@property (nonatomic, strong)MKBXDSlotUIDCellModel *dataModel;

@property (nonatomic, weak)id <MKBXDSlotUIDCellDelegate>delegate;

+ (MKBXDSlotUIDCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
