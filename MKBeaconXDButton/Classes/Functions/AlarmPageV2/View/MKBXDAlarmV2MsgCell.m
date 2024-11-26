//
//  MKBXDAlarmV2MsgCell.m
//  MKBeaconXDButton_Example
//
//  Created by aa on 2024/11/25.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "MKBXDAlarmV2MsgCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

@implementation MKBXDAlarmV2MsgCellModel

- (CGFloat)fetchCellHeight {
    CGSize msgSize = [NSString sizeWithText:self.msg
                                    andFont:MKFont(13.f)
                                 andMaxSize:CGSizeMake(kViewWidth - 2 * 15.f, MAXFLOAT)];
    return (msgSize.height + 20.f);
}

@end

@interface MKBXDAlarmV2MsgCell ()

@property (nonatomic, strong)UILabel *msgLabel;

@end

@implementation MKBXDAlarmV2MsgCell

+ (MKBXDAlarmV2MsgCell *)initCellWithTableView:(UITableView *)tableView {
    MKBXDAlarmV2MsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKBXDAlarmV2MsgCellIdenty"];
    if (!cell) {
        cell = [[MKBXDAlarmV2MsgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKBXDAlarmV2MsgCellIdenty"];
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
- (void)setDataModel:(MKBXDAlarmV2MsgCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKBXDAlarmV2MsgCellModel.class]) {
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
