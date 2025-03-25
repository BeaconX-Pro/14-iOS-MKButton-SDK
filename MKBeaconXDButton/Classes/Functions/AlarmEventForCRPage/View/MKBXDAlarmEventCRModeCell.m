//
//  MKBXDAlarmEventCRModeCell.m
//  MKBeaconXDButton_Example
//
//  Created by aa on 2025/3/19.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import "MKBXDAlarmEventCRModeCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKCustomUIAdopter.h"

@implementation MKBXDAlarmEventCRModeCellModel
@end

@interface MKBXDAlarmEventCRModeCell ()

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UILabel *eventCountLabel;

@property (nonatomic, strong)UIButton *clearButton;

@property (nonatomic, strong)UIButton *exportButton;

@end

@implementation MKBXDAlarmEventCRModeCell

+ (MKBXDAlarmEventCRModeCell *)initCellWithTableView:(UITableView *)tableView {
    MKBXDAlarmEventCRModeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKBXDAlarmEventCRModeCellIdenty"];
    if (!cell) {
        cell = [[MKBXDAlarmEventCRModeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKBXDAlarmEventCRModeCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.eventCountLabel];
        [self.contentView addSubview:self.clearButton];
        [self.contentView addSubview:self.exportButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.eventCountLabel.mas_left).mas_offset(-5.f);
        make.top.mas_equalTo(10.f);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.eventCountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(80.f);
        make.centerY.mas_equalTo(self.msgLabel.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.exportButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(60.f);
        make.top.mas_equalTo(self.msgLabel.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.clearButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.exportButton.mas_left).mas_offset(-15.f);
        make.width.mas_equalTo(45.f);
        make.centerY.mas_equalTo(self.exportButton.mas_centerY);
        make.height.mas_equalTo(30.f);
    }];
}

#pragma mark - event method
- (void)clearButtonPressed {
    if ([self.delegate respondsToSelector:@selector(bxd_alarmEventCRModeCell_clearBtnPressed:)]) {
        [self.delegate bxd_alarmEventCRModeCell_clearBtnPressed:self.dataModel.index];
    }
}

- (void)exportButtonPressed {
    if ([self.delegate respondsToSelector:@selector(bxd_alarmEventCRModeCell_exportBtnPressed:)]) {
        [self.delegate bxd_alarmEventCRModeCell_exportBtnPressed:self.dataModel.index];
    }
}

#pragma mark - setter
- (void)setDataModel:(MKBXDAlarmEventCRModeCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKBXDAlarmEventCRModeCellModel.class]) {
        return;
    }
    self.msgLabel.text = SafeStr(_dataModel.msg);
    self.eventCountLabel.text = SafeStr(_dataModel.count);
}

#pragma mark - getter
- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.font = MKFont(15.f);
    }
    return _msgLabel;
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

- (UIButton *)clearButton {
    if (!_clearButton) {
        _clearButton = [MKCustomUIAdopter customButtonWithTitle:@"clear"
                                                         target:self
                                                         action:@selector(clearButtonPressed)];
        _clearButton.titleLabel.font = MKFont(13.f);
    }
    return _clearButton;
}

- (UIButton *)exportButton {
    if (!_exportButton) {
        _exportButton = [MKCustomUIAdopter customButtonWithTitle:@"Export"
                                                          target:self
                                                          action:@selector(exportButtonPressed)];
        _exportButton.titleLabel.font = MKFont(13.f);
    }
    return _exportButton;
}

@end
