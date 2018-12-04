//
//  NNWalletPropertyRecordCell.m
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/24.
//  Copyright © 2018 超级钱包. All rights reserved.
//

#import "NNWalletPropertyRecordCell.h"
#import "NNWalletPropertyRecordModel.h"

@interface NNWalletPropertyRecordCell ()

/** 币种名称 */
@property (nonatomic, strong) UILabel *nameLabel;
/** 币种操作类型 */
@property (nonatomic, strong) UILabel *typeLabel;
/** 金额 */
@property (nonatomic, strong) UILabel *amountLabel;
/** 币种状态 */
@property (nonatomic, strong) UILabel *statusLabel;
/** 时间 */
@property (nonatomic, strong) UILabel *timeLabel;
/** 手续费 */
@property (nonatomic, strong) UILabel *feeLabel;

@end

@implementation NNWalletPropertyRecordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIConfigManager colorThemeWhite];
        [self setupChildView];
    }
    return self;
}

- (void)setupChildView
{
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.typeLabel];
    [self.contentView addSubview:self.amountLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.statusLabel];
    [self.contentView addSubview:self.feeLabel];

    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(NNHMargin_15);
    }];
    
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-NNHMargin_15);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(NNHMargin_15);
        make.baseline.equalTo(self.statusLabel.mas_top).offset(-NNHMargin_15);
    }];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel);
        make.left.equalTo(self.nameLabel.mas_right).offset(NNHMargin_10);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.statusLabel.mas_baseline).offset(NNHMargin_15);
        make.left.equalTo(self.contentView).offset(NNHMargin_15);
    }];
    
    [self.feeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeLabel);
        make.right.equalTo(self.contentView).offset(-NNHMargin_15);
    }];
    
    [self.amountLabel nnh_addAttringTextWithText:@"" font:nil color:[UIColor akext_colorWithHex:@"#4e66b2"]];
}

- (void)setRecordModel:(NNWalletPropertyRecordModel *)recordModel
{
    _recordModel = recordModel;
    self.nameLabel.text = recordModel.flowname;
    self.statusLabel.text = recordModel.statustext;
    self.timeLabel.text = recordModel.flowtime;
    self.feeLabel.text = recordModel.feetext;
    if ([recordModel.directionType isEqualToString:@"1"] ) {
        self.amountLabel.text = [NSString stringWithFormat:@"%@ +%@",recordModel.coinname,recordModel.amount];
        self.amountLabel.textColor = [UIColor akext_colorWithHex:@"#2ba246"];
    }else {
        self.amountLabel.text = [NSString stringWithFormat:@"%@ -%@",recordModel.coinname,recordModel.amount];
        self.amountLabel.textColor = [UIConfigManager colorThemeRed];
    }
    [self.amountLabel nnh_addAttringTextWithText:recordModel.coinname font:nil color:[UIColor akext_colorWithHex:@"#4e66b2"]];
}

#pragma mark - Lazy Loads

- (UILabel *)nameLabel
{
    if (_nameLabel == nil) {
        _nameLabel = [UILabel NNHWithTitle:@"BTC" titleColor:[UIConfigManager colorThemeBlack] font:[UIConfigManager fontThemeTextMain]];
    }
    return _nameLabel;
}

- (UILabel *)typeLabel
{
    if (_typeLabel == nil) {
        _typeLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorThemeBlack] font:[UIConfigManager fontThemeTextMain]];
    }
    return _typeLabel;
}

- (UILabel *)amountLabel
{
    if (_amountLabel == nil) {
        _amountLabel = [UILabel NNHWithTitle:@"" titleColor:[UIColor akext_colorWithHex:@"#009759"] font:[UIFont boldSystemFontOfSize:14]];
    }
    return _amountLabel;
}

- (UILabel *)timeLabel
{
    if (_timeLabel == nil) {
        _timeLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorTextLightGray] font:[UIConfigManager fontThemeTextDefault]];
    }
    return _timeLabel;
}

- (UILabel *)statusLabel
{
    if (_statusLabel == nil) {
        _statusLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorTextLightGray] font:[UIConfigManager fontThemeTextTip]];
    }
    return _statusLabel;
}

- (UILabel *)feeLabel
{
    if (_feeLabel == nil) {
        _feeLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorTextLightGray] font:[UIConfigManager fontThemeTextTip]];
    }
    return _feeLabel;
}

@end
