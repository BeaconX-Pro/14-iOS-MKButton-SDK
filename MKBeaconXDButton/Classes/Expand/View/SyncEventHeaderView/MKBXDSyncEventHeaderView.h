//
//  MKBXDSyncEventHeaderView.h
//  MKBeaconXDButton_Example
//
//  Created by aa on 2025/3/19.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKBXDSyncEventHeaderViewDelegate <NSObject>

- (void)bxd_syncEventHeaderView_syncBtnPressed:(BOOL)selected;

- (void)bxd_syncEventHeaderView_deleteBtnPressed;

- (void)bxd_syncEventHeaderView_exportBtnPressed;

@end

@interface MKBXDSyncEventHeaderView : UIView

@property (nonatomic, weak)id <MKBXDSyncEventHeaderViewDelegate>delegate;

@property (nonatomic, assign)BOOL sync;

@property (nonatomic, copy)NSString *modeMsg;

@end

NS_ASSUME_NONNULL_END
