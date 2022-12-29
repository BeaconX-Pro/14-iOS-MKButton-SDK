//
//  MKBXDAlarmEventCountCell.m
//  MKBeaconXDButton_Example
//
//  Created by aa on 2022/2/22.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXDAlarmEventCountCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKCustomUIAdopter.h"

static CGFloat const buttonWidth = 55.f;
static CGFloat const buttonHeight = 30.f;

@implementation MKBXDAlarmEventCountCellModel
@end

@interface MKBXDAlarmEventCountCell ()

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UIButton *checkButton;

@property (nonatomic, strong)UILabel *countLabel;

@property (nonatomic, strong)UIButton *clearButton;

@property (nonatomic, strong)UIButton *exportButton;

@end

@implementation MKBXDAlarmEventCountCell

+ (MKBXDAlarmEventCountCell *)initCellWithTableView:(UITableView *)tableView {
    MKBXDAlarmEventCountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKBXDAlarmEventCountCellIdenty"];
    if (!cell) {
        cell = [[MKBXDAlarmEventCountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKBXDAlarmEventCountCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.msgLabel];
//        [self.contentView addSubview:self.checkButton];
        [self.contentView addSubview:self.countLabel];
        [self.contentView addSubview:self.clearButton];
        [self.contentView addSubview:self.exportButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.countLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.clearButton.mas_left);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(10.f);
        make.height.mas_equalTo(buttonHeight);
    }];
//    [self.checkButton mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(self.countLabel.mas_left).mas_offset(-10.f);
//        make.width.mas_equalTo(buttonWidth);
//        make.top.mas_equalTo(10.f);
//        make.height.mas_equalTo(buttonHeight);
//    }];
    [self.exportButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(buttonWidth);
        make.centerY.mas_equalTo(self.clearButton.mas_centerY);
        make.height.mas_equalTo(buttonHeight);
    }];
    [self.clearButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.exportButton.mas_left).mas_offset(-10.f);
        make.width.mas_equalTo(buttonWidth);
        make.bottom.mas_equalTo(-10.f);
        make.height.mas_equalTo(buttonHeight);
    }];
    CGSize msgSize = [NSString sizeWithText:self.msgLabel.text
                                    andFont:self.msgLabel.font
                                 andMaxSize:CGSizeMake(kViewWidth - 3 * 15.f - 10.f - 2 * buttonWidth, MAXFLOAT)];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.countLabel.mas_left).mas_offset(-15.f);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(msgSize.height);
    }];
}

#pragma mark - event method
- (void)checkButtonPressed {
    if ([self.delegate respondsToSelector:@selector(bxd_alarmEvent_checkButtonPressed:)]) {
        [self.delegate bxd_alarmEvent_checkButtonPressed:self.dataModel.index];
    }
}

- (void)clearButtonPressed {
    if ([self.delegate respondsToSelector:@selector(bxd_alarmEvent_clearButtonPressed:)]) {
        [self.delegate bxd_alarmEvent_clearButtonPressed:self.dataModel.index];
    }
}

- (void)exportButtonPressed {
    if ([self.delegate respondsToSelector:@selector(bxd_alarmEvent_exportButtonPressed:)]) {
        [self.delegate bxd_alarmEvent_exportButtonPressed:self.dataModel.index];
    }
}

#pragma mark - setter
- (void)setDataModel:(MKBXDAlarmEventCountCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKBXDAlarmEventCountCellModel.class]) {
        return;
    }
    self.msgLabel.text = SafeStr(_dataModel.msg);
    self.countLabel.text = SafeStr(_dataModel.count);
    [self setNeedsLayout];
}

#pragma mark - getter
- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.font = MKFont(13.f);
        _msgLabel.numberOfLines = 0;
    }
    return _msgLabel;
}

- (UIButton *)checkButton {
    if (!_checkButton) {
        _checkButton = [MKCustomUIAdopter customButtonWithTitle:@"Check"
                                                         target:self
                                                         action:@selector(checkButtonPressed)];
    }
    return _checkButton;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.textColor = DEFAULT_TEXT_COLOR;
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.font = MKFont(13.f);
        _countLabel.text = @"0";
    }
    return _countLabel;
}

- (UIButton *)clearButton {
    if (!_clearButton) {
        _clearButton = [MKCustomUIAdopter customButtonWithTitle:@"Clear"
                                                         target:self
                                                         action:@selector(clearButtonPressed)];
    }
    return _clearButton;
}

- (UIButton *)exportButton {
    if (!_exportButton) {
        _exportButton = [MKCustomUIAdopter customButtonWithTitle:@"Export"
                                                          target:self
                                                          action:@selector(exportButtonPressed)];
    }
    return _exportButton;
}

@end
