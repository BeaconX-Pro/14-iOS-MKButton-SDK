//
//  MKBXDAlarmV2EventCell.m
//  MKBeaconXDButton_Example
//
//  Created by aa on 2024/11/25.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
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

@property (nonatomic, strong)UILabel *alarmEventLabel;

@property (nonatomic, strong)UILabel *eventCountLabel;

@property (nonatomic, strong)UILabel *clicksLabel;

@property (nonatomic, strong)UIButton *clearButton;

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
        [self.contentView addSubview:self.alarmEventLabel];
        [self.contentView addSubview:self.eventCountLabel];
        [self.contentView addSubview:self.clicksLabel];
        [self.contentView addSubview:self.clearButton];
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
    [self.alarmEventLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(80.f);
        make.centerY.mas_equalTo(self.clearButton.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.eventCountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.alarmEventLabel.mas_right).mas_offset(5.f);
        make.width.mas_equalTo(100.f);
        make.centerY.mas_equalTo(self.clearButton.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.clicksLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.eventCountLabel.mas_right).mas_offset(5.f);
        make.right.mas_equalTo(self.clearButton.mas_left).mas_offset(-5.f);
        make.centerY.mas_equalTo(self.clearButton.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.clearButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(45.f);
        make.top.mas_equalTo(self.msgLabel.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(30.f);
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
    self.eventCountLabel.text = SafeStr(_dataModel.count);
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

- (UILabel *)alarmEventLabel {
    if (!_alarmEventLabel) {
        _alarmEventLabel = [[UILabel alloc] init];
        _alarmEventLabel.textColor = DEFAULT_TEXT_COLOR;
        _alarmEventLabel.textAlignment = NSTextAlignmentLeft;
        _alarmEventLabel.font = MKFont(12.f);
        _alarmEventLabel.text = @"Alarm Events";
    }
    return _alarmEventLabel;
}

- (UILabel *)eventCountLabel {
    if (!_eventCountLabel) {
        _eventCountLabel = [[UILabel alloc] init];
        _eventCountLabel.textColor = DEFAULT_TEXT_COLOR;
        _eventCountLabel.textAlignment = NSTextAlignmentCenter;
        _eventCountLabel.font = MKFont(13.f);
        _eventCountLabel.text = @"0";
    }
    return _eventCountLabel;
}

- (UILabel *)clicksLabel {
    if (!_clicksLabel) {
        _clicksLabel = [[UILabel alloc] init];
        _clicksLabel.textColor = DEFAULT_TEXT_COLOR;
        _clicksLabel.textAlignment = NSTextAlignmentLeft;
        _clicksLabel.font = MKFont(12.f);
        _clicksLabel.text = @"Button Clicks";
    }
    return _clicksLabel;
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
