//
//  MKBXDAlarmV2EventCell.m
//  MKBeaconXDButton_Example
//
//  Created by aa on 2025/10/9.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import "MKBXDAlarmV2EventCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKCustomUIAdopter.h"

@implementation MKBXDAlarmV2EventCellModel
@end

@interface MKBXDAlarmV2EventCell ()

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UIButton *clearButton;

@property (nonatomic, strong)UILabel *mainBtnMsgLabel;

@property (nonatomic, strong)UILabel *mainCountLabel;

@property (nonatomic, strong)UILabel *mainClicksLabel;

@property (nonatomic, strong)UILabel *subBtnMsgLabel;

@property (nonatomic, strong)UILabel *subCountLabel;

@property (nonatomic, strong)UILabel *subClicksLabel;

@end

@implementation MKBXDAlarmV2EventCell

+ (MKBXDAlarmV2EventCell *)initCellWithTableView:(UITableView *)tableView {
    MKBXDAlarmV2EventCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKBXDAlarmV2EventCellIdenty"];
    if (!cell) {
        cell = [[MKBXDAlarmV2EventCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKBXDAlarmV2EventCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.clearButton];
        [self.contentView addSubview:self.mainBtnMsgLabel];
        [self.contentView addSubview:self.mainCountLabel];
        [self.contentView addSubview:self.mainClicksLabel];
        [self.contentView addSubview:self.subBtnMsgLabel];
        [self.contentView addSubview:self.subCountLabel];
        [self.contentView addSubview:self.subClicksLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.clearButton.mas_left).mas_offset(-10.f);
        make.centerY.mas_equalTo(self.clearButton.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.clearButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(45.f);
        make.top.mas_equalTo(10.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.mainBtnMsgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25.f);
        make.width.mas_equalTo(80.f);
        make.centerY.mas_equalTo(self.mainCountLabel.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.mainCountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mainBtnMsgLabel.mas_right).mas_offset(5.f);
        make.width.mas_equalTo(100.f);
        make.top.mas_equalTo(self.clearButton.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.mainClicksLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mainCountLabel.mas_right).mas_offset(5.f);
        make.right.mas_equalTo(-25.f);
        make.centerY.mas_equalTo(self.mainCountLabel.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.subBtnMsgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25.f);
        make.width.mas_equalTo(80.f);
        make.centerY.mas_equalTo(self.subCountLabel.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.subCountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mainBtnMsgLabel.mas_right).mas_offset(5.f);
        make.width.mas_equalTo(100.f);
        make.top.mas_equalTo(self.mainCountLabel.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.subClicksLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.subCountLabel.mas_right).mas_offset(5.f);
        make.right.mas_equalTo(-25.f);
        make.centerY.mas_equalTo(self.subCountLabel.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
}

#pragma mark - event method
- (void)clearButtonPressed {
    if ([self.delegate respondsToSelector:@selector(bxd_alarmV2EventCell_clearButtonPressed)]) {
        [self.delegate bxd_alarmV2EventCell_clearButtonPressed];
    }
}

#pragma mark - setter
- (void)setDataModel:(MKBXDAlarmV2EventCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKBXDAlarmV2EventCellModel.class]) {
        return;
    }
    self.mainCountLabel.text = SafeStr(_dataModel.mainCount);
    self.subCountLabel.text = SafeStr(_dataModel.subCount);
}

#pragma mark - getter
- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.font = MKFont(15.f);
        _msgLabel.text = @"Long Connection Mode";
    }
    return _msgLabel;
}

- (UILabel *)mainBtnMsgLabel {
    if (!_mainBtnMsgLabel) {
        _mainBtnMsgLabel = [[UILabel alloc] init];
        _mainBtnMsgLabel.textColor = DEFAULT_TEXT_COLOR;
        _mainBtnMsgLabel.textAlignment = NSTextAlignmentLeft;
        _mainBtnMsgLabel.font = MKFont(12.f);
        _mainBtnMsgLabel.text = @"Main button";
    }
    return _mainBtnMsgLabel;
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

- (UILabel *)mainClicksLabel {
    if (!_mainClicksLabel) {
        _mainClicksLabel = [[UILabel alloc] init];
        _mainClicksLabel.textColor = DEFAULT_TEXT_COLOR;
        _mainClicksLabel.textAlignment = NSTextAlignmentLeft;
        _mainClicksLabel.font = MKFont(12.f);
        _mainClicksLabel.text = @"Button Clicks";
    }
    return _mainClicksLabel;
}

- (UILabel *)subBtnMsgLabel {
    if (!_subBtnMsgLabel) {
        _subBtnMsgLabel = [[UILabel alloc] init];
        _subBtnMsgLabel.textColor = DEFAULT_TEXT_COLOR;
        _subBtnMsgLabel.textAlignment = NSTextAlignmentLeft;
        _subBtnMsgLabel.font = MKFont(12.f);
        _subBtnMsgLabel.text = @"Sub button";
    }
    return _subBtnMsgLabel;
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

- (UILabel *)subClicksLabel {
    if (!_subClicksLabel) {
        _subClicksLabel = [[UILabel alloc] init];
        _subClicksLabel.textColor = DEFAULT_TEXT_COLOR;
        _subClicksLabel.textAlignment = NSTextAlignmentLeft;
        _subClicksLabel.font = MKFont(12.f);
        _subClicksLabel.text = @"Button Clicks";
    }
    return _subClicksLabel;
}

- (UIButton *)clearButton {
    if (!_clearButton) {
        _clearButton = [MKCustomUIAdopter customButtonWithTitle:@"clear"
                                                         target:self
                                                         action:@selector(clearButtonPressed)];
    }
    return _clearButton;
}

@end
