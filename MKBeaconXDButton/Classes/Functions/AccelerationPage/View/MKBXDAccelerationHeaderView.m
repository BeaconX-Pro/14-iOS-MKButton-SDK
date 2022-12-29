//
//  MKBXDAccelerationHeaderView.m
//  MKBeaconXDButton_Example
//
//  Created by aa on 2021/3/3.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXDAccelerationHeaderView.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

#import "MKCustomUIAdopter.h"

@interface MKBXDAccelerationHeaderView ()

@property (nonatomic, strong)UIView *backView;

@property (nonatomic, strong)UIButton *syncButton;

@property (nonatomic, strong)UIImageView *synIcon;

@property (nonatomic, strong)UILabel *syncLabel;

@property (nonatomic, strong)UILabel *xDataLabel;

@property (nonatomic, strong)UILabel *yDataLabel;

@property (nonatomic, strong)UILabel *zDataLabel;

@end

@implementation MKBXDAccelerationHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_WHITE_MACROS;
        [self addSubview:self.syncButton];
        [self.syncButton addSubview:self.synIcon];
        [self addSubview:self.syncLabel];
        [self addSubview:self.xDataLabel];
        [self addSubview:self.yDataLabel];
        [self addSubview:self.zDataLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.syncButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(30.f);
        make.top.mas_equalTo(5.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.synIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.syncButton.mas_centerX);
        make.centerY.mas_equalTo(self.syncButton.mas_centerY);
        make.width.mas_equalTo(25.f);
        make.height.mas_equalTo(25.f);
    }];
    [self.syncLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(25.f);
        make.top.mas_equalTo(self.syncButton.mas_bottom).mas_offset(2.f);
        make.height.mas_equalTo(MKFont(10.f).lineHeight);
    }];
    CGFloat width = (kViewWidth - 6 * 15.f) / 3;
    [self.xDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.syncButton.mas_right).mas_offset(5.f);
        make.width.mas_equalTo(width);
        make.centerY.mas_equalTo(self.syncButton.mas_centerY).mas_offset(2.f);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.yDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.xDataLabel.mas_right).mas_offset(5.f);
        make.width.mas_equalTo(width);
        make.centerY.mas_equalTo(self.xDataLabel.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.zDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.yDataLabel.mas_right).mas_offset(5.f);
        make.width.mas_equalTo(width);
        make.centerY.mas_equalTo(self.xDataLabel.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
}

#pragma mark - event method
- (void)syncButtonPressed {
    self.syncButton.selected = !self.syncButton.selected;
    [self.synIcon.layer removeAnimationForKey:@"bxd_synIconAnimationKey"];
    if ([self.delegate respondsToSelector:@selector(bxd_updateThreeAxisNotifyStatus:)]) {
        [self.delegate bxd_updateThreeAxisNotifyStatus:self.syncButton.selected];
    }
    if (self.syncButton.selected) {
        //开始旋转
        [self.synIcon.layer addAnimation:[MKCustomUIAdopter refreshAnimation:2.f] forKey:@"bxd_synIconAnimationKey"];
        self.syncLabel.text = @"Stop";
        return;
    }
    self.syncLabel.text = @"Sync";
}

#pragma mark - public method
- (void)updateDataWithXData:(NSString *)xData yData:(NSString *)yData zData:(NSString *)zData {
    self.xDataLabel.text = [NSString stringWithFormat:@"X-axis:%@mg",xData];
    self.yDataLabel.text = [NSString stringWithFormat:@"Y-axis:%@mg",yData];
    self.zDataLabel.text = [NSString stringWithFormat:@"Z-axis:%@mg",zData];
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

- (UIImageView *)synIcon {
    if (!_synIcon) {
        _synIcon = [[UIImageView alloc] init];
        _synIcon.image = LOADICON(@"MKBeaconXDButton", @"MKBXDAccelerationHeaderView", @"bxd_threeAxisAcceLoadingIcon.png");
    }
    return _synIcon;
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

- (UILabel *)xDataLabel {
    if (!_xDataLabel) {
        _xDataLabel = [[UILabel alloc] init];
        _xDataLabel.textColor = DEFAULT_TEXT_COLOR;
        _xDataLabel.textAlignment = NSTextAlignmentCenter;
        _xDataLabel.font = MKFont(12.f);
        _xDataLabel.text = @"X-axis:N/A";
    }
    return _xDataLabel;
}

- (UILabel *)yDataLabel {
    if (!_yDataLabel) {
        _yDataLabel = [[UILabel alloc] init];
        _yDataLabel.textColor = DEFAULT_TEXT_COLOR;
        _yDataLabel.textAlignment = NSTextAlignmentCenter;
        _yDataLabel.font = MKFont(12.f);
        _yDataLabel.text = @"Y-axis:N/A";
    }
    return _yDataLabel;
}

- (UILabel *)zDataLabel {
    if (!_zDataLabel) {
        _zDataLabel = [[UILabel alloc] init];
        _zDataLabel.textColor = DEFAULT_TEXT_COLOR;
        _zDataLabel.textAlignment = NSTextAlignmentCenter;
        _zDataLabel.font = MKFont(12.f);
        _zDataLabel.text = @"Z-axis:N/A";
    }
    return _zDataLabel;
}

@end
