//
//  MKBXDScanDeviceInfoCell.m
//  MKBeaconXDButton_Example
//
//  Created by aa on 2022/2/26.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXDScanDeviceInfoCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

@implementation MKBXDScanDeviceInfoCellModel
@end

@interface MKBXDScanDeviceInfoCell ()

@property (nonatomic, strong)UIImageView *leftIcon;

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UILabel *rangingLabel;

@property (nonatomic, strong)UILabel *rangingValueLabel;

@property (nonatomic, strong)UILabel *accelerationLabel;

@property (nonatomic, strong)UILabel *xDataLabel;

@property (nonatomic, strong)UILabel *yDataLabel;

@property (nonatomic, strong)UILabel *zDataLabel;

@end

@implementation MKBXDScanDeviceInfoCell

+ (MKBXDScanDeviceInfoCell *)initCellWithTableView:(UITableView *)tableView {
    MKBXDScanDeviceInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKBXDScanDeviceInfoCellIdenty"];
    if (!cell) {
        cell = [[MKBXDScanDeviceInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKBXDScanDeviceInfoCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.leftIcon];
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.rangingLabel];
        [self.contentView addSubview:self.rangingValueLabel];
        [self.contentView addSubview:self.accelerationLabel];
        [self.contentView addSubview:self.xDataLabel];
        [self.contentView addSubview:self.yDataLabel];
        [self.contentView addSubview:self.zDataLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.leftIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.width.mas_equalTo(7.f);
        make.top.mas_equalTo(10.f);
        make.height.mas_equalTo(7.f);
    }];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftIcon.mas_right).mas_offset(5.f);
        make.right.mas_equalTo(-10.f);
        make.centerY.mas_equalTo(self.leftIcon.mas_centerY);
        make.height.mas_equalTo(MKFont(15).lineHeight);
    }];
    [self.rangingLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.msgLabel.mas_left);
        make.right.mas_equalTo(self.contentView.mas_centerX).mas_offset(-5.f);
        make.top.mas_equalTo(self.msgLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.rangingValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_centerX).mas_offset(5.f);
        make.right.mas_equalTo(-10.f);
        make.centerY.mas_equalTo(self.rangingLabel.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.accelerationLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.msgLabel.mas_left);
        make.right.mas_equalTo(self.contentView.mas_centerX).mas_offset(-5.f);
        make.top.mas_equalTo(self.rangingValueLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.xDataLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_centerX).mas_offset(5.f);
        make.right.mas_equalTo(-10.f);
        make.centerY.mas_equalTo(self.accelerationLabel.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.yDataLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_centerX).mas_offset(5.f);
        make.right.mas_equalTo(-10.f);
        make.top.mas_equalTo(self.xDataLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.zDataLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_centerX).mas_offset(5.f);
        make.right.mas_equalTo(-10.f);
        make.top.mas_equalTo(self.yDataLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
}

#pragma mark - setter
- (void)setDataModel:(MKBXDScanDeviceInfoCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKBXDScanDeviceInfoCellModel.class]) {
        return;
    }
    self.rangingValueLabel.text = SafeStr(_dataModel.rangingData);
    BOOL hidden = NO;
    if ([_dataModel.xData isEqualToString:@"0mg"]
        && [_dataModel.yData isEqualToString:@"0mg"]
        && [_dataModel.zData isEqualToString:@"0mg"]) {
        hidden = YES;
    }
    self.xDataLabel.hidden = hidden;
    self.yDataLabel.hidden = hidden;
    self.zDataLabel.hidden = hidden;
    self.accelerationLabel.hidden = hidden;
    self.xDataLabel.text = [@"X: " stringByAppendingString:SafeStr(_dataModel.xData)];
    self.yDataLabel.text = [@"Y: " stringByAppendingString:SafeStr(_dataModel.yData)];
    self.zDataLabel.text = [@"Z: " stringByAppendingString:SafeStr(_dataModel.zData)];
}

#pragma mark - getter
- (UIImageView *)leftIcon{
    if (!_leftIcon) {
        _leftIcon = [[UIImageView alloc] init];
        _leftIcon.image = LOADICON(@"MKBeaconXDButton", @"MKBXDScanDeviceInfoCell", @"bxd_littleBluePoint.png");
    }
    return _leftIcon;
}

- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.font = MKFont(15.f);
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.text = @"Device info";
    }
    return _msgLabel;
}

- (UILabel *)rangingLabel {
    if (!_rangingLabel) {
        _rangingLabel = [self createLabel];
        _rangingLabel.text = @"Ranging data";
    }
    return _rangingLabel;
}

- (UILabel *)rangingValueLabel {
    if (!_rangingValueLabel) {
        _rangingValueLabel = [self createLabel];
    }
    return _rangingValueLabel;
}

- (UILabel *)accelerationLabel {
    if (!_accelerationLabel) {
        _accelerationLabel = [self createLabel];
        _accelerationLabel.text = @"Acceleration";
    }
    return _accelerationLabel;
}

- (UILabel *)xDataLabel {
    if (!_xDataLabel) {
        _xDataLabel = [self createLabel];
    }
    return _xDataLabel;
}

- (UILabel *)yDataLabel {
    if (!_yDataLabel) {
        _yDataLabel = [self createLabel];
    }
    return _yDataLabel;
}

- (UILabel *)zDataLabel {
    if (!_zDataLabel) {
        _zDataLabel = [self createLabel];
    }
    return _zDataLabel;
}

- (UILabel *)createLabel {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = RGBCOLOR(184, 184, 184);
    label.textAlignment = NSTextAlignmentLeft;
    label.font = MKFont(12.f);
    return label;
}

@end
