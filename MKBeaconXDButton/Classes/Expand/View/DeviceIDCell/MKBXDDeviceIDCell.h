//
//  MKBXDDeviceIDCell.h
//  MKBeaconXDButton_Example
//
//  Created by aa on 2022/2/19.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXDDeviceIDCellModel : NSObject

@property (nonatomic, copy)NSString *deviceID;

@end

@protocol MKBXDDeviceIDCellDelegate <NSObject>

- (void)bxd_deviceIDChanged:(NSString *)text;

@end

@interface MKBXDDeviceIDCell : MKBaseCell

@property (nonatomic, weak)id <MKBXDDeviceIDCellDelegate>delegate;

@property (nonatomic, strong)MKBXDDeviceIDCellModel *dataModel;

+ (MKBXDDeviceIDCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
