//
//  MKBXDSyncEventHeaderView.m
//  MKBeaconXDButton_Example
//
//  Created by aa on 2025/3/19.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import "MKBXDSyncEventHeaderView.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKCustomUIAdopter.h"

@interface MKBXDSyncEventHeaderBtn : UIControl

@property (nonatomic, strong)UIImageView *icon;

@property (nonatomic, strong)UILabel *msgLabel;

@end

@implementation MKBXDSyncEventHeaderBtn

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.icon];
        [self addSubview:self.msgLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize iconSize = self.icon.image.size;
    [self.icon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(iconSize.width);
        make.top.mas_equalTo(2.f);
        make.height.mas_equalTo(iconSize.height);
    }];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
}

#pragma mark - getter
- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
    }
    return _icon;
}

- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.textAlignment = NSTextAlignmentCenter;
        _msgLabel.font = MKFont(11.f);
    }
    return _msgLabel;
}

@end

@interface MKBXDSyncEventHeaderView ()

@property (nonatomic, strong)UIImageView *syncIcon;

@property (nonatomic, strong)UIButton *syncButton;

@property (nonatomic, strong)UILabel *syncLabel;

@property (nonatomic, strong)MKBXDSyncEventHeaderBtn *deleteButton;

@property (nonatomic, strong)MKBXDSyncEventHeaderBtn *exportButton;

@property (nonatomic, strong)UILabel *timestampLabel;

@property (nonatomic, strong)UILabel *modeLabel;

@end

@implementation MKBXDSyncEventHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.syncButton];
        [self addSubview:self.syncLabel];
        [self.syncButton addSubview:self.syncIcon];
        [self addSubview:self.deleteButton];
        [self addSubview:self.exportButton];
        [self addSubview:self.timestampLabel];
        [self addSubview:self.modeLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.syncButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(30.f);
        make.top.mas_equalTo(15.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.syncIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.syncButton.mas_centerX);
        make.centerY.mas_equalTo(self.syncButton.mas_centerY);
        make.width.mas_equalTo(25.f);
        make.height.mas_equalTo(25.f);
    }];
    [self.syncLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(30.f);
        make.top.mas_equalTo(self.syncButton.mas_bottom).mas_offset(2.f);
        make.height.mas_equalTo(MKFont(10.f).lineHeight);
    }];
    [self.exportButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(50.f);
        make.top.mas_equalTo(10.f);
        make.height.mas_equalTo(50.f);
    }];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(50.f);
        make.centerY.mas_equalTo(self.exportButton.mas_centerY);
        make.height.mas_equalTo(50.f);
    }];
    [self.timestampLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.mas_centerX).mas_offset(-5.f);
        make.top.mas_equalTo(self.exportButton.mas_bottom).mas_offset(15.f);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.modeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.left.mas_equalTo(self.mas_centerX).mas_offset(5.f);
        make.top.mas_equalTo(self.exportButton.mas_bottom).mas_offset(15.f);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
}

#pragma mark - event method
- (void)syncButtonPressed {
    self.syncButton.selected = !self.syncButton.selected;
    [self.syncIcon.layer removeAnimationForKey:@"synIconAnimationKey"];
    
    if (self.syncButton.selected) {
        //开始旋转
        [self.syncIcon.layer addAnimation:[MKCustomUIAdopter refreshAnimation:2.f] forKey:@"synIconAnimationKey"];
        self.syncLabel.text = @"Stop";
    }else {
        self.syncLabel.text = @"Sync";
    }
    if ([self.delegate respondsToSelector:@selector(bxd_syncEventHeaderView_syncBtnPressed:)]) {
        [self.delegate bxd_syncEventHeaderView_syncBtnPressed:self.syncButton.selected];
    }
}

- (void)deleteButtonPressed {
    if ([self.delegate respondsToSelector:@selector(bxd_syncEventHeaderView_deleteBtnPressed)]) {
        [self.delegate bxd_syncEventHeaderView_deleteBtnPressed];
    }
}

- (void)exportButtonPressed {
    if ([self.delegate respondsToSelector:@selector(bxd_syncEventHeaderView_exportBtnPressed)]) {
        [self.delegate bxd_syncEventHeaderView_exportBtnPressed];
    }
}

#pragma mark - setter
- (void)setModeMsg:(NSString *)modeMsg {
    _modeMsg = modeMsg;
    self.modeLabel.text = _modeMsg;
}

- (void)setSync:(BOOL)sync {
    _sync = sync;
    self.syncButton.selected = NO;
    [self.syncIcon.layer removeAnimationForKey:@"synIconAnimationKey"];
    self.syncLabel.text = @"Sync";
}

#pragma mark - getter
- (UIButton *)syncButton {
    if (!_syncButton) {
        _syncButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_syncButton addTarget:self
                        action:@selector(syncButtonPressed)
              forControlEvents:UIControlEventTouchUpInside];
    }
    return _syncButton;
}

- (UIImageView *)syncIcon {
    if (!_syncIcon) {
        _syncIcon = [[UIImageView alloc] init];
        _syncIcon.image = LOADICON(@"MKBeaconXDButton", @"MKBXDSyncEventHeaderView", @"bxd_threeAxisAcceLoadingIcon.png");
    }
    return _syncIcon;
}

- (UILabel *)syncLabel {
    if (!_syncLabel) {
        _syncLabel = [[UILabel alloc] init];
        _syncLabel.textColor = DEFAULT_TEXT_COLOR;
        _syncLabel.textAlignment = NSTextAlignmentCenter;
        _syncLabel.font = MKFont(10.f);
        _syncLabel.text = @"Sync";
    }
    return _syncLabel;
}

- (MKBXDSyncEventHeaderBtn *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [[MKBXDSyncEventHeaderBtn alloc] init];
        _deleteButton.msgLabel.text = @"Erase all";
        _deleteButton.icon.image = LOADICON(@"MKBeaconXDButton", @"MKBXDSyncEventHeaderView", @"bxd_slotExportDeleteIcon.png");
        [_deleteButton addTarget:self
                          action:@selector(deleteButtonPressed)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

- (MKBXDSyncEventHeaderBtn *)exportButton {
    if (!_exportButton) {
        _exportButton = [[MKBXDSyncEventHeaderBtn alloc] init];
        _exportButton.msgLabel.text = @"Export";
        _exportButton.icon.image = LOADICON(@"MKBeaconXDButton", @"MKBXDSyncEventHeaderView", @"bxd_slotExportEnableIcon.png");
        [_exportButton addTarget:self
                          action:@selector(exportButtonPressed)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _exportButton;
}

- (UILabel *)timestampLabel {
    if (!_timestampLabel) {
        _timestampLabel = [[UILabel alloc] init];
        _timestampLabel.textColor = DEFAULT_TEXT_COLOR;
        _timestampLabel.font = MKFont(15.f);
        _timestampLabel.textAlignment = NSTextAlignmentCenter;
        _timestampLabel.text = @"Timestamp";
    }
    return _timestampLabel;
}

- (UILabel *)modeLabel {
    if (!_modeLabel) {
        _modeLabel = [[UILabel alloc] init];
        _modeLabel.textColor = DEFAULT_TEXT_COLOR;
        _modeLabel.font = MKFont(15.f);
        _modeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _modeLabel;
}

@end
