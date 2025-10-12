//
//  MKBXDAlarmEventDBCountCell.m
//  MKBeaconXDButton_Example
//
//  Created by aa on 2025/10/10.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import "MKBXDAlarmEventDBCountCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKCustomUIAdopter.h"

static CGFloat const buttonWidth = 55.f;
static CGFloat const buttonHeight = 30.f;

@implementation MKBXDAlarmEventDBCountCellModel
@end

@interface MKBXDAlarmEventDBCountCell ()

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UILabel *mainLabel;

@property (nonatomic, strong)UILabel *mainCountLabel;

@property (nonatomic, strong)UIButton *mainClearButton;

@property (nonatomic, strong)UILabel *subLabel;

@property (nonatomic, strong)UILabel *subCountLabel;

@property (nonatomic, strong)UIButton *subClearButton;

@end

@implementation MKBXDAlarmEventDBCountCell

+ (MKBXDAlarmEventDBCountCell *)initCellWithTableView:(UITableView *)tableView {
    MKBXDAlarmEventDBCountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKBXDAlarmEventDBCountCellIdenty"];
    if (!cell) {
        cell = [[MKBXDAlarmEventDBCountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKBXDAlarmEventDBCountCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.mainLabel];
        [self.contentView addSubview:self.mainCountLabel];
        [self.contentView addSubview:self.mainClearButton];
        [self.contentView addSubview:self.subLabel];
        [self.contentView addSubview:self.subCountLabel];
        [self.contentView addSubview:self.subClearButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(10.f);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.mainClearButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(buttonWidth);
        make.top.mas_equalTo(self.msgLabel.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(buttonHeight);
    }];
    [self.mainLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30.f);
        make.width.mas_equalTo(120.f);
        make.centerY.mas_equalTo(self.mainClearButton.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.mainCountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mainClearButton.mas_left).mas_offset(-10.f);
        make.width.mas_equalTo(150.f);
        make.centerY.mas_equalTo(self.mainClearButton.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.subClearButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(buttonWidth);
        make.top.mas_equalTo(self.mainClearButton.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(buttonHeight);
    }];
    [self.subLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30.f);
        make.width.mas_equalTo(120.f);
        make.centerY.mas_equalTo(self.subClearButton.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.subCountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.subClearButton.mas_left).mas_offset(-10.f);
        make.width.mas_equalTo(150.f);
        make.centerY.mas_equalTo(self.subClearButton.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
}

#pragma mark - event method

- (void)mainClearButtonPressed {
    if ([self.delegate respondsToSelector:@selector(bxd_alarmEventDBCell_mainClearButtonPressed:)]) {
        [self.delegate bxd_alarmEventDBCell_mainClearButtonPressed:self.dataModel.index];
    }
}

- (void)subClearButtonPressed {
    if ([self.delegate respondsToSelector:@selector(bxd_alarmEventDBCell_subClearButtonPressed:)]) {
        [self.delegate bxd_alarmEventDBCell_subClearButtonPressed:self.dataModel.index];
    }
}

#pragma mark - setter
- (void)setDataModel:(MKBXDAlarmEventDBCountCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKBXDAlarmEventDBCountCellModel.class]) {
        return;
    }
    self.msgLabel.text = SafeStr(_dataModel.msg);
    self.mainCountLabel.text = SafeStr(_dataModel.mainCount);
    self.subCountLabel.text = SafeStr(_dataModel.subCount);
}

#pragma mark - getter
- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.font = MKFont(15.f);
    }
    return _msgLabel;
}

- (UILabel *)mainLabel {
    if (!_mainLabel) {
        _mainLabel = [[UILabel alloc] init];
        _mainLabel.textAlignment = NSTextAlignmentLeft;
        _mainLabel.textColor = DEFAULT_TEXT_COLOR;
        _mainLabel.font = MKFont(13.f);
        _mainLabel.text = @"Main button";
    }
    return _mainLabel;
}

- (UILabel *)mainCountLabel {
    if (!_mainCountLabel) {
        _mainCountLabel = [[UILabel alloc] init];
        _mainCountLabel.textColor = DEFAULT_TEXT_COLOR;
        _mainCountLabel.textAlignment = NSTextAlignmentCenter;
        _mainCountLabel.font = MKFont(13.f);
        _mainCountLabel.text = @"0";
    }
    return _mainCountLabel;
}

- (UIButton *)mainClearButton {
    if (!_mainClearButton) {
        _mainClearButton = [MKCustomUIAdopter customButtonWithTitle:@"Clear"
                                                             target:self
                                                             action:@selector(mainClearButtonPressed)];
    }
    return _mainClearButton;
}

- (UILabel *)subLabel {
    if (!_subLabel) {
        _subLabel = [[UILabel alloc] init];
        _subLabel.textAlignment = NSTextAlignmentLeft;
        _subLabel.textColor = DEFAULT_TEXT_COLOR;
        _subLabel.font = MKFont(13.f);
        _subLabel.text = @"Sub button";
    }
    return _subLabel;
}

- (UILabel *)subCountLabel {
    if (!_subCountLabel) {
        _subCountLabel = [[UILabel alloc] init];
        _subCountLabel.textColor = DEFAULT_TEXT_COLOR;
        _subCountLabel.textAlignment = NSTextAlignmentCenter;
        _subCountLabel.font = MKFont(13.f);
        _subCountLabel.text = @"0";
    }
    return _subCountLabel;
}

- (UIButton *)subClearButton {
    if (!_subClearButton) {
        _subClearButton = [MKCustomUIAdopter customButtonWithTitle:@"Clear"
                                                            target:self
                                                            action:@selector(subClearButtonPressed)];
    }
    return _subClearButton;
}

@end
