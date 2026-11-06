//
//  MKBXDSlotHubbleCell.m
//  MKBeaconXDButton_Example
//
//  Created by aa on 2026/11/6.
//  Copyright © 2026 aadyx2007@163.com. All rights reserved.
//

#import "MKBXDSlotHubbleCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

#import "MKTextField.h"
#import "MKCustomUIAdopter.h"

@implementation MKBXDSlotHubbleCellModel
@end

@interface MKBXDSlotHubbleCell ()

@property (nonatomic, strong)UIView *backView;

@property (nonatomic, strong)UIImageView *leftIcon;

@property (nonatomic, strong)UILabel *typeLabel;

@property (nonatomic, strong)UILabel *keyLabel;

@property (nonatomic, strong)UILabel *hexKeyLabel;

@property (nonatomic, strong)MKTextField *keyTextField;

@property (nonatomic, strong)UILabel *idLabel;

@property (nonatomic, strong)UILabel *hexIDLabel;

@property (nonatomic, strong)MKTextField *idTextField;

@property (nonatomic, strong)UILabel *rawDataLabel;

@property (nonatomic, strong)UILabel *hexRawDataLabel;

@property (nonatomic, strong)MKTextField *rawDataTextField;

@end

@implementation MKBXDSlotHubbleCell

+ (MKBXDSlotHubbleCell *)initCellWithTableView:(UITableView *)tableView {
    MKBXDSlotHubbleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKBXDSlotHubbleCellIdenty"];
    if (!cell) {
        cell = [[MKBXDSlotHubbleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKBXDSlotHubbleCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.backView];
        
        [self.backView addSubview:self.leftIcon];
        [self.backView addSubview:self.typeLabel];
        
        [self.backView addSubview:self.keyLabel];
        [self.backView addSubview:self.keyTextField];
        [self.backView addSubview:self.hexKeyLabel];
        
        [self.backView addSubview:self.idLabel];
        [self.backView addSubview:self.idTextField];
        [self.backView addSubview:self.hexIDLabel];
        
        [self.backView addSubview:self.rawDataLabel];
        [self.backView addSubview:self.rawDataTextField];
        [self.backView addSubview:self.hexRawDataLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [self.leftIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(22.f);
        make.top.mas_equalTo(10.f);
        make.height.mas_equalTo(22.f);
    }];
    [self.typeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftIcon.mas_right).mas_offset(15.f);
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.leftIcon.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    
    [self.keyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(110.f);
        make.centerY.mas_equalTo(self.keyTextField.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.hexKeyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.keyLabel.mas_right).mas_offset(5.f);
        make.width.mas_equalTo(30.f);
        make.centerY.mas_equalTo(self.keyTextField.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.keyTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.hexKeyLabel.mas_right).mas_offset(5.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(self.leftIcon.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(30.f);
    }];
    
    [self.idLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(110.f);
        make.centerY.mas_equalTo(self.idTextField.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.hexIDLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.idLabel.mas_right).mas_offset(5.f);
        make.width.mas_equalTo(30.f);
        make.centerY.mas_equalTo(self.idTextField.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.idTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.hexIDLabel.mas_right).mas_offset(5.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(self.keyTextField.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(30.f);
    }];
    
    [self.rawDataLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(110.f);
        make.centerY.mas_equalTo(self.rawDataTextField.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.hexRawDataLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rawDataLabel.mas_right).mas_offset(5.f);
        make.width.mas_equalTo(30.f);
        make.centerY.mas_equalTo(self.rawDataTextField.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.rawDataTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.hexRawDataLabel.mas_right).mas_offset(5.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(self.idTextField.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(30.f);
    }];
}

#pragma mark - setter
- (void)setDataModel:(MKBXDSlotHubbleCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKBXDSlotHubbleCellModel.class]) {
        return;
    }
    self.keyTextField.text = SafeStr(_dataModel.deviceKey);
    self.idTextField.text = SafeStr(_dataModel.deviceID);
    self.rawDataTextField.text = SafeStr(_dataModel.rawData);
}

#pragma mark - getter
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = COLOR_WHITE_MACROS;
        
        _backView.layer.masksToBounds = YES;
        _backView.layer.cornerRadius = 8.f;
    }
    return _backView;
}

- (UIImageView *)leftIcon{
    if (!_leftIcon) {
        _leftIcon = [[UIImageView alloc] init];
        _leftIcon.image = LOADICON(@"MKBeaconXDButton", @"MKBXDSlotHubbleCell", @"bxd_slotAdvContent.png");
    }
    return _leftIcon;
}

- (UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.textColor = DEFAULT_TEXT_COLOR;
        _typeLabel.textAlignment = NSTextAlignmentLeft;
        _typeLabel.font = MKFont(15.f);
        _typeLabel.text = @"HN info";
    }
    return _typeLabel;
}

- (UILabel *)keyLabel {
    if (!_keyLabel) {
        _keyLabel = [[UILabel alloc] init];
        _keyLabel.textColor = DEFAULT_TEXT_COLOR;
        _keyLabel.textAlignment = NSTextAlignmentLeft;
        _keyLabel.font = MKFont(15.f);
        _keyLabel.text = @"Device Key";
    }
    return _keyLabel;
}

- (UILabel *)hexKeyLabel {
    if (!_hexKeyLabel) {
        _hexKeyLabel = [[UILabel alloc] init];
        _hexKeyLabel.textColor = DEFAULT_TEXT_COLOR;
        _hexKeyLabel.font = MKFont(12.f);
        _hexKeyLabel.textAlignment = NSTextAlignmentRight;
        _hexKeyLabel.text = @"0x";
    }
    return _hexKeyLabel;
}

- (MKTextField *)keyTextField {
    if (!_keyTextField) {
        _keyTextField = [MKCustomUIAdopter customNormalTextFieldWithText:@""
                                                             placeHolder:@"32bytes"
                                                                textType:mk_hexCharOnly];
        _keyTextField.maxLength = 64;
        @weakify(self);
        _keyTextField.textChangedBlock = ^(NSString * _Nonnull text) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(bxd_hubble_deviceKeyChanged:)]) {
                [self.delegate bxd_hubble_deviceKeyChanged:text];
            }
        };
    }
    return _keyTextField;
}

- (UILabel *)idLabel {
    if (!_idLabel) {
        _idLabel = [[UILabel alloc] init];
        _idLabel.textColor = DEFAULT_TEXT_COLOR;
        _idLabel.textAlignment = NSTextAlignmentLeft;
        _idLabel.font = MKFont(15.f);
        _idLabel.text = @"Device ID";
    }
    return _idLabel;
}

- (UILabel *)hexIDLabel {
    if (!_hexIDLabel) {
        _hexIDLabel = [[UILabel alloc] init];
        _hexIDLabel.textColor = DEFAULT_TEXT_COLOR;
        _hexIDLabel.font = MKFont(12.f);
        _hexIDLabel.textAlignment = NSTextAlignmentRight;
        _hexIDLabel.text = @"0x";
    }
    return _hexIDLabel;
}

- (MKTextField *)idTextField {
    if (!_idTextField) {
        _idTextField = [MKCustomUIAdopter customNormalTextFieldWithText:@""
                                                            placeHolder:@"16bytes"
                                                               textType:mk_hexCharOnly];
        _idTextField.maxLength = 32;
        @weakify(self);
        _idTextField.textChangedBlock = ^(NSString * _Nonnull text) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(bxd_hubble_deviceIDChanged:)]) {
                [self.delegate bxd_hubble_deviceIDChanged:text];
            }
        };
    }
    return _idTextField;
}

- (UILabel *)rawDataLabel {
    if (!_rawDataLabel) {
        _rawDataLabel = [[UILabel alloc] init];
        _rawDataLabel.textColor = DEFAULT_TEXT_COLOR;
        _rawDataLabel.textAlignment = NSTextAlignmentLeft;
        _rawDataLabel.font = MKFont(15.f);
        _rawDataLabel.text = @"Raw Data";
    }
    return _rawDataLabel;
}

- (UILabel *)hexRawDataLabel {
    if (!_hexRawDataLabel) {
        _hexRawDataLabel = [[UILabel alloc] init];
        _hexRawDataLabel.textColor = DEFAULT_TEXT_COLOR;
        _hexRawDataLabel.font = MKFont(12.f);
        _hexRawDataLabel.textAlignment = NSTextAlignmentRight;
        _hexRawDataLabel.text = @"0x";
    }
    return _hexRawDataLabel;
}

- (MKTextField *)rawDataTextField {
    if (!_rawDataTextField) {
        _rawDataTextField = [MKCustomUIAdopter customNormalTextFieldWithText:@""
                                                                 placeHolder:@"1bytes"
                                                                    textType:mk_hexCharOnly];
        _rawDataTextField.maxLength = 2;
        @weakify(self);
        _rawDataTextField.textChangedBlock = ^(NSString * _Nonnull text) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(bxd_hubble_rawDataChanged:)]) {
                [self.delegate bxd_hubble_rawDataChanged:text];
            }
        };
    }
    return _rawDataTextField;
}

@end
