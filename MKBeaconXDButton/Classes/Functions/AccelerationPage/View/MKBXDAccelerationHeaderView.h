//
//  MKBXDAccelerationHeaderView.h
//  MKBeaconXDButton_Example
//
//  Created by aa on 2021/3/3.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKBXDAccelerationHeaderViewDelegate <NSObject>

- (void)bxd_updateThreeAxisNotifyStatus:(BOOL)notify;

@end

@interface MKBXDAccelerationHeaderView : UIView

@property (nonatomic, weak)id <MKBXDAccelerationHeaderViewDelegate>delegate;

- (void)updateDataWithXData:(NSString *)xData yData:(NSString *)yData zData:(NSString *)zData;

@end

NS_ASSUME_NONNULL_END
