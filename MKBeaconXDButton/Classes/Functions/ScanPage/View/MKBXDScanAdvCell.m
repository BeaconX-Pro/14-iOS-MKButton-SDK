//
//  MKBXDScanAdvCell.m
//  MKBeaconXDButton_Example
//
//  Created by aa on 2022/2/24.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXDScanAdvCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

@implementation MKBXDScanAdvCellModel
@end

@interface MKBXDScanAdvCell ()

@property (nonatomic, strong)UIImageView *leftIcon;

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UILabel *triggerStatusLabel;

@property (nonatomic, strong)UILabel *triggerStatusValueLabel;

@property (nonatomic, strong)UILabel *triggerCountLabel;

@property (nonatomic, strong)UILabel *triggerCountValueLabel;

@end

@implementation MKBXDScanAdvCell

+ (MKBXDScanAdvCell *)initCellWithTableView:(UITableView *)tableView {
    MKBXDScanAdvCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKBXDScanAdvCellIdenty"];
    if (!cell) {
        cell = [[MKBXDScanAdvCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKBXDScanAdvCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.leftIcon];
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.triggerStatusLabel];
        [self.contentView addSubview:self.triggerStatusValueLabel];
        [self.contentView addSubview:self.triggerCountLabel];
        [self.contentView addSubview:self.triggerCountValueLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.leftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.width.mas_equalTo(7.f);
        make.top.mas_equalTo(10.f);
        make.height.mas_equalTo(7.f);
    }];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftIcon.mas_right).mas_offset(5.f);
        make.right.mas_equalTo(-10.f);
        make.centerY.mas_equalTo(self.leftIcon.mas_centerY);
        make.height.mas_equalTo(MKFont(15).lineHeight);
    }];
    [self.triggerStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.msgLabel.mas_left);
        make.right.mas_equalTo(self.contentView.mas_centerX).mas_offset(-5.f);
        make.top.mas_equalTo(self.msgLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.triggerStatusValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_centerX).mas_offset(5.f);
        make.right.mas_equalTo(-10.f);
        make.centerY.mas_equalTo(self.triggerStatusLabel.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.triggerCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.msgLabel.mas_left);
        make.right.mas_equalTo(self.contentView.mas_centerX).mas_offset(-5.f);
        make.top.mas_equalTo(self.triggerStatusLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.triggerCountValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_centerX).mas_offset(5.f);
        make.right.mas_equalTo(-10.f);
        make.centerY.mas_equalTo(self.triggerCountLabel.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
}

#pragma mark - setter
- (void)setDataModel:(MKBXDScanAdvCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKBXDScanAdvCellModel.class]) {
        return;
    }
    if (_dataModel.alarmMode == 0) {
        self.msgLabel.text = @"Single press alarm mode";
    }else if (_dataModel.alarmMode == 1) {
        self.msgLabel.text = @"Double press alarm mode";
    }else if (_dataModel.alarmMode == 2) {
        self.msgLabel.text = @"Long press alarm mode";
    }else if (_dataModel.alarmMode == 3) {
        self.msgLabel.text = @"Abnormal inactivity mode";
    }
    self.triggerStatusValueLabel.text = (_dataModel.triggerStatus ? @"Triggered" : @"Standby");
    self.triggerCountValueLabel.text = SafeStr(_dataModel.triggerCount);
    self.triggerCountValueLabel.hidden = (_dataModel.alarmMode == 3);
    self.triggerCountLabel.hidden = (_dataModel.alarmMode == 3);
}

#pragma mark - getter
- (UIImageView *)leftIcon{
    if (!_leftIcon) {
        _leftIcon = [[UIImageView alloc] init];
        _leftIcon.image = LOADICON(@"MKBeaconXDButton", @"MKBXDScanAdvCell", @"bxd_littleBluePoint.png");
    }
    return _leftIcon;
}

- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.font = MKFont(15.f);
        _msgLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _msgLabel;
}

- (UILabel *)triggerStatusLabel {
    if (!_triggerStatusLabel) {
        _triggerStatusLabel = [self createLabel];
        _triggerStatusLabel.text = @"Trigger status";
    }
    return _triggerStatusLabel;
}

- (UILabel *)triggerStatusValueLabel {
    if (!_triggerStatusValueLabel) {
        _triggerStatusValueLabel = [self createLabel];
    }
    return _triggerStatusValueLabel;
}

- (UILabel *)triggerCountLabel {
    if (!_triggerCountLabel) {
        _triggerCountLabel = [self createLabel];
        _triggerCountLabel.text = @"Trigger count";
    }
    return _triggerCountLabel;
}

- (UILabel *)triggerCountValueLabel {
    if (!_triggerCountValueLabel) {
        _triggerCountValueLabel = [self createLabel];
    }
    return _triggerCountValueLabel;
}

- (UILabel *)createLabel {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = RGBCOLOR(184, 184, 184);
    label.textAlignment = NSTextAlignmentLeft;
    label.font = MKFont(12.f);
    return label;
}

@end
