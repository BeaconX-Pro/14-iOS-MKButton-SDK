//
//  MKBXDAlarmSyncTimeView.m
//  MKBeaconXDButton_Example
//
//  Created by aa on 2022/2/22.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXDAlarmSyncTimeView.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKCustomUIAdopter.h"

@interface MKBXDAlarmSyncTimeView ()

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UIButton *syncButton;

@property (nonatomic, strong)UILabel *timeLabel;

@end

@implementation MKBXDAlarmSyncTimeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_WHITE_MACROS;
        [self addSubview:self.msgLabel];
        [self addSubview:self.syncButton];
        [self addSubview:self.timeLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.syncButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(45.f);
        make.top.mas_equalTo(10.f);
        make.height.mas_equalTo(30.f);
    }];
    CGSize msgSize = [NSString sizeWithText:self.msgLabel.text
                                    andFont:self.msgLabel.font
                                 andMaxSize:CGSizeMake(kViewWidth - 3 * 15.f - 45.f, MAXFLOAT)];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.syncButton.mas_left).mas_offset(-15.f);
        make.centerY.mas_equalTo(self.syncButton.mas_centerY);
        make.height.mas_equalTo(msgSize.height);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.bottom.mas_equalTo(-20.f);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
}

#pragma mark - event method
- (void)syncButtonPressed {
    if ([self.delegate respondsToSelector:@selector(bxd_alarmSyncTimeButtonPressed)]) {
        [self.delegate bxd_alarmSyncTimeButtonPressed];
    }
}

#pragma mark - public method
- (void)updateTimestamp:(NSString *)timestamp {
    self.timeLabel.text = SafeStr(timestamp);
}

#pragma mark - getter
- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.font = MKFont(15.f);
        _msgLabel.text = @"Sync standard UTC time";
        _msgLabel.numberOfLines = 0;
    }
    return _msgLabel;
}

- (UIButton *)syncButton {
    if (!_syncButton) {
        _syncButton = [MKCustomUIAdopter customButtonWithTitle:@"Sync"
                                                        target:self
                                                        action:@selector(syncButtonPressed)];
    }
    return _syncButton;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.textColor = DEFAULT_TEXT_COLOR;
        _timeLabel.font = MKFont(15.f);
    }
    return _timeLabel;
}

@end
