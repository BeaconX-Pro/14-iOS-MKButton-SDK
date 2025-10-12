//
//  MKBXDAlarmMsgCell.m
//  MKBeaconXDButton_Example
//
//  Created by aa on 2025/10/9.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import "MKBXDAlarmMsgCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

@implementation MKBXDAlarmMsgCellModel

- (CGFloat)fetchCellHeight {
    CGSize msgSize = [NSString sizeWithText:self.msg
                                    andFont:MKFont(13.f)
                                 andMaxSize:CGSizeMake(kViewWidth - 2 * 15.f, MAXFLOAT)];
    return (msgSize.height + 20.f);
}

@end

@interface MKBXDAlarmMsgCell ()

@property (nonatomic, strong)UILabel *msgLabel;

@end

@implementation MKBXDAlarmMsgCell

+ (MKBXDAlarmMsgCell *)initCellWithTableView:(UITableView *)tableView {
    MKBXDAlarmMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKBXDAlarmMsgCellIdenty"];
    if (!cell) {
        cell = [[MKBXDAlarmMsgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKBXDAlarmMsgCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.msgLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize msgSize = [NSString sizeWithText:self.msgLabel.text
                                    andFont:self.msgLabel.font
                                 andMaxSize:CGSizeMake(kViewWidth - 2 * 15.f, MAXFLOAT)];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(msgSize.height);
    }];
}

#pragma mark - setter
- (void)setDataModel:(MKBXDAlarmMsgCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKBXDAlarmMsgCellModel.class]) {
        return;
    }
    self.msgLabel.text = SafeStr(_dataModel.msg);
    [self setNeedsLayout];
}

#pragma mark - getter
- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = RGBCOLOR(118, 118, 118);
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.font = MKFont(13.f);
        _msgLabel.numberOfLines = 0;
    }
    return _msgLabel;
}

@end
