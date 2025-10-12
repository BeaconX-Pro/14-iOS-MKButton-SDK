//
//  MKBXDScanAdvCell.h
//  MKBeaconXDButton_Example
//
//  Created by aa on 2022/2/24.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXDScanAdvCellModel : NSObject

/// 0:Single 1:Double 2:Long 3:Abnormal inactivity
@property (nonatomic, assign)NSInteger alarmMode;

/*
 version = 0/1 0: Standby 1:Trigger
 version = 2 0: Standby 1:Main-Triggered 2:Sub-Triggered
 */
@property (nonatomic, assign)NSInteger triggerStatus;

@property (nonatomic, copy)NSString *triggerCount;

/// Only used for version is V2(Double button).
@property (nonatomic, assign)BOOL motionStatus;

/// 0: V1 1: Long connection 2:V2(Double button)
@property (nonatomic, assign)NSInteger version;

@end

@interface MKBXDScanAdvCell : MKBaseCell

@property (nonatomic, strong)MKBXDScanAdvCellModel *dataModel;

+ (MKBXDScanAdvCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
