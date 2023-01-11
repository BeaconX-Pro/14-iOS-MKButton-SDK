//
//  MKBXDNotificationTypePickerView.h
//  MKBeaconXDButton_Example
//
//  Created by aa on 2022/2/21.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXDNotificationTypePickerViewModel : NSObject

/// 是否显示顶部按钮和按钮那一行的label
@property (nonatomic, assign)BOOL needButton;

/// 跟button一行的msgLabel显示内容(needButton=YES有效)
@property (nonatomic, copy)NSString *msg;

/// 蓝色按钮标题(可以选择不显示)(needButton=YES有效)
@property (nonatomic, copy)NSString *buttonTitle;

/// pickerView一行的label显示内容
@property (nonatomic, copy)NSString *typeLabelMsg;

@end

@protocol MKBXDNotificationTypePickerViewDelegate <NSObject>

- (void)bxd_notiTypePickerViewTypeChanged:(NSInteger)type;

@optional
- (void)bxd_notiTypePickerViewButtonPressed;

@end

@interface MKBXDNotificationTypePickerView : UIView

@property (nonatomic, weak)id <MKBXDNotificationTypePickerViewDelegate>delegate;

@property (nonatomic, strong)MKBXDNotificationTypePickerViewModel *dataModel;

/// 更新pickerView
/// @param notiType 参见下面
/*
0:Silent
1:LED
2:Buzzer
3:LED+Buzzer
*/
- (void)updateNotificationType:(NSInteger)notiType;

@end

NS_ASSUME_NONNULL_END
