//
//  MKBXDNotificationTypePickerView.m
//  MKBeaconXDButton_Example
//
//  Created by aa on 2022/2/21.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXDNotificationTypePickerView.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKCustomUIAdopter.h"

static CGFloat const pickerViewWidth = 110.f;

@implementation MKBXDNotificationTypePickerViewModel
@end

@interface MKBXDNotificationTypePickerView ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UIButton *dismissButton;

@property (nonatomic, strong)UIView *lineView;

@property (nonatomic, strong)UILabel *typeLabel;

@property (nonatomic, strong)UIPickerView *pickerView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, assign)NSInteger alarmType;

@end

@implementation MKBXDNotificationTypePickerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_WHITE_MACROS;
        [self addSubview:self.msgLabel];
        [self addSubview:self.dismissButton];
        [self addSubview:self.lineView];
        [self addSubview:self.typeLabel];
        [self addSubview:self.pickerView];
    }
    return self;
}

#pragma mark - super method
- (void)layoutSubviews{
    [super layoutSubviews];
    CGSize typeMsgSize = [NSString sizeWithText:self.typeLabel.text
                                        andFont:self.typeLabel.font
                                     andMaxSize:CGSizeMake(kViewWidth - 3 * 15.f - pickerViewWidth, MAXFLOAT)];
    if (self.dataModel.needButton) {
        [self.dismissButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15.f);
            make.width.mas_equalTo(80.f);
            make.top.mas_equalTo(10.f);
            make.height.mas_equalTo(40.f);
        }];
        [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15.f);
            make.right.mas_equalTo(self.dismissButton.mas_left).mas_offset(-15.f);
            make.centerY.mas_equalTo(self.dismissButton.mas_centerY);
            make.height.mas_equalTo(MKFont(15.f).lineHeight);
        }];
        [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(self.dismissButton.mas_bottom).mas_offset(11.f);
            make.height.mas_equalTo(10.f);
        }];
        [self.pickerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15.f);
            make.width.mas_equalTo(pickerViewWidth);
            make.top.mas_equalTo(self.lineView.mas_bottom).mas_offset(10.f);
            make.bottom.mas_equalTo(-10.f);
        }];
        [self.typeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15.f);
            make.right.mas_equalTo(self.pickerView.mas_left).mas_offset(-15.f);
            make.centerY.mas_equalTo(self.pickerView.mas_centerY);
            make.height.mas_equalTo(typeMsgSize.height);
        }];
        return;
    }
    [self.typeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.pickerView.mas_left).mas_offset(-15.f);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(typeMsgSize.height);
    }];
    [self.pickerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(pickerViewWidth);
        make.top.mas_equalTo(10.f);
        make.bottom.mas_equalTo(-10.f);
    }];
}

#pragma mark - UIPickerViewDelegate

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30.f;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.dataList.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view{
    UILabel *titleLabel = (UILabel *)view;
    if (!titleLabel) {
        titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = DEFAULT_TEXT_COLOR;
        titleLabel.adjustsFontSizeToFitWidth = YES;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = MKFont(12.f);
    }
    if(self.alarmType == row){
        /*选中后的row的字体颜色*/
        /*重写- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component NS_AVAILABLE_IOS(6_0) __TVOS_PROHIBITED; 方法加载 attributedText*/
        
        titleLabel.attributedText
        = [self pickerView:pickerView attributedTitleForRow:row forComponent:component];
        
    }else{
        
        titleLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    }
    return titleLabel;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.dataList[row];
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSAttributedString *attString = [MKCustomUIAdopter attributedString:@[self.dataList[row]]
                                                                  fonts:@[MKFont(13.f)]
                                                                 colors:@[NAVBAR_COLOR_MACROS]];
    return attString;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.alarmType = row;
    [self.pickerView reloadAllComponents];
    if ([self.delegate respondsToSelector:@selector(bxd_notiTypePickerViewTypeChanged:)]) {
        [self.delegate bxd_notiTypePickerViewTypeChanged:row];
    }
}

#pragma mark - event method
- (void)dismissButtonPressed {
    if ([self.delegate respondsToSelector:@selector(bxd_notiTypePickerViewButtonPressed)]) {
        [self.delegate bxd_notiTypePickerViewButtonPressed];
    }
}

#pragma mark - setter
- (void)setDataModel:(MKBXDNotificationTypePickerViewModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKBXDNotificationTypePickerViewModel.class]) {
        return;
    }
    self.msgLabel.text = SafeStr(_dataModel.msg);
    [self.dismissButton setTitle:SafeStr(_dataModel.buttonTitle) forState:UIControlStateNormal];
    self.msgLabel.hidden = !_dataModel.needButton;
    self.dismissButton.hidden = !_dataModel.needButton;
    self.lineView.hidden = !_dataModel.needButton;
    self.typeLabel.text = SafeStr(_dataModel.typeLabelMsg);
    [self setNeedsLayout];
}

#pragma mark - public method
- (void)updateNotificationType:(NSInteger)notiType {
    [self.pickerView reloadAllComponents];
    self.alarmType = notiType;
    [self.pickerView selectRow:notiType inComponent:0 animated:YES];
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

- (UIButton *)dismissButton {
    if (!_dismissButton) {
        _dismissButton = [MKCustomUIAdopter customButtonWithTitle:@""
                                                           target:self
                                                           action:@selector(dismissButtonPressed)];
    }
    return _dismissButton;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = RGBCOLOR(242, 242, 242);
    }
    return _lineView;
}

- (UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.textColor = DEFAULT_TEXT_COLOR;
        _typeLabel.textAlignment = NSTextAlignmentLeft;
        _typeLabel.font = MKFont(15.f);
        _typeLabel.numberOfLines = 0;
    }
    return _typeLabel;
}

- (UIPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        // 显示选中框,iOS10以后分割线默认的是透明的，并且默认是显示的，设置该属性没有意义了，
        _pickerView.showsSelectionIndicator = YES;
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        
        _pickerView.layer.masksToBounds = YES;
        _pickerView.layer.borderColor = NAVBAR_COLOR_MACROS.CGColor;
        _pickerView.layer.borderWidth = 0.5f;
        _pickerView.layer.cornerRadius = 4.f;
    }
    return _pickerView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray arrayWithObjects:@"Silent",@"LED",@"Vibration",@"Buzzer",@"LED+Vibration",@"LED+Buzzer", nil];
    }
    return _dataList;
}

@end
