//
//  MKBXDTriggerTypeClickCell.m
//  MKBeaconXDButton_Example
//
//  Created by aa on 2024/11/26.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "MKBXDTriggerTypeClickCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

#import "MKCustomUIAdopter.h"

@implementation MKBXDTriggerTypeClickCellModel
@end

@interface MKBXDTriggerTypeClickCell ()

@property (nonatomic, strong)UIControl *backButton;

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UIImageView *rightIcon;

@end

@implementation MKBXDTriggerTypeClickCell

+ (MKBXDTriggerTypeClickCell *)initCellWithTableView:(UITableView *)tableView {
    MKBXDTriggerTypeClickCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKBXDTriggerTypeClickCellIdenty"];
    if (!cell) {
        cell = [[MKBXDTriggerTypeClickCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKBXDTriggerTypeClickCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.backButton];
        [self.backButton addSubview:self.msgLabel];
        [self.backButton addSubview:self.rightIcon];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.rightIcon.mas_right).mas_offset(-5.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(8.f);
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(14.f);
    }];
}

#pragma mark - event method
- (void)backButtonPressed {
    self.backButton.selected = !self.backButton.selected;
    
    self.rightIcon.transform = (self.backButton.isSelected ? CGAffineTransformMakeRotation(M_PI_2) : CGAffineTransformIdentity);
    if ([self.delegate respondsToSelector:@selector(bxd_triggerTypeClickCell_pressed:)]) {
        [self.delegate bxd_triggerTypeClickCell_pressed:self.backButton.selected];
    }
}

#pragma mark - setter
- (void)setDataModel:(MKBXDTriggerTypeClickCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKBXDTriggerTypeClickCellModel.class]) {
        return;
    }
    self.backButton.selected = _dataModel.selected;
    self.rightIcon.transform = (self.backButton.isSelected ? CGAffineTransformMakeRotation(M_PI_2) : CGAffineTransformIdentity);
}

#pragma mark - getter
- (UIControl *)backButton {
    if (!_backButton) {
        _backButton = [[UIControl alloc] init];
        [_backButton addTarget:self
                        action:@selector(backButtonPressed)
              forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.font = MKFont(15.f);
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.text = @"Trigger notification type";
    }
    return _msgLabel;
}

- (UIImageView *)rightIcon {
    if (!_rightIcon) {
        _rightIcon = [[UIImageView alloc] init];
        _rightIcon.image = LOADICON(@"MKBeaconXDButton", @"MKBXDTriggerTypeClickCell", @"bxd_goNextButton");
    }
    return _rightIcon;
}

@end
