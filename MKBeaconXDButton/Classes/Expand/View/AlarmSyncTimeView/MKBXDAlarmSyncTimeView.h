//
//  MKBXDAlarmSyncTimeView.h
//  MKBeaconXDButton_Example
//
//  Created by aa on 2022/2/22.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKBXDAlarmSyncTimeViewDelegate <NSObject>

- (void)bxd_alarmSyncTimeButtonPressed;

@end

@interface MKBXDAlarmSyncTimeView : UIView

@property (nonatomic, weak)id <MKBXDAlarmSyncTimeViewDelegate>delegate;

- (void)updateTimestamp:(NSString *)timestamp;

@end

NS_ASSUME_NONNULL_END
