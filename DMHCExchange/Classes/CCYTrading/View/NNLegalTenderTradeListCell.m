//
//  NNCCYTradingListCell.m
//  SuperWallet
//
//  Created by 牛牛 on 2018/9/12.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import "NNLegalTenderTradeListCell.h"
#import "NNTradingEntrustModel.h"

@interface NNLegalTenderTradeListCell ()

/** 状态 */
@property (nonatomic, strong) UIView  *statusView;
/** 名称 */
@property (nonatomic, strong) UILabel *nameLabel;
/** 价格 */
@property (nonatomic, strong) UILabel *priceLabel;
/** 成交数量 */
@property (nonatomic, strong) UILabel *actualCountLabel;
/** 成交完成率 */
@property (nonatomic, copy) UILabel *completeLabel;
/** 限额 */
@property (nonatomic, strong) UILabel *limitPriceLabel;
/** 数量 */
@property (nonatomic, strong) UILabel *countLabel;
/** 间隔横线 */
@property (nonatomic, strong) UIView *lineView;
/** 支付方式 */
@property (nonatomic, strong) NSMutableArray *iconArray;
/** 认证标识 */
@property (nonatomic, strong) UIImageView *authImageView;

@end

@implementation NNLegalTenderTradeListCell

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
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(NNHMargin_15);
        make.top.equalTo(self.contentView).offset(NNHMargin_10);
    }];
    
    [self.contentView addSubview:self.authImageView];
    [self.authImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel);
        make.left.equalTo(self.nameLabel.mas_right).offset(NNHMargin_5);
    }];
    
    [self.contentView addSubview:self.statusView];
    [self.statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.centerY.equalTo(self.nameLabel);
        make.height.equalTo(self.nameLabel);
        make.width.equalTo(@5);
    }];
    
    [self.contentView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_centerX).offset(NNHMargin_20);
        make.centerY.equalTo(self.nameLabel);
    }];
    
    [self.contentView addSubview:self.actualCountLabel];
    [self.actualCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(NNHMargin_10);
        make.left.equalTo(self.nameLabel);
    }];
    
    [self.contentView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.actualCountLabel.mas_right).offset(NNHMargin_5);
        make.centerY.equalTo(self.actualCountLabel);
        make.height.equalTo(@10);
        make.width.equalTo(@(NNHLineH));
    }];
    
    [self.contentView addSubview:self.completeLabel];
    [self.completeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.actualCountLabel.mas_right).offset(NNHMargin_10);
        make.centerY.equalTo(self.actualCountLabel);
    }];
    
    [self.contentView addSubview:self.limitPriceLabel];
    [self.limitPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceLabel);
        make.top.equalTo(self.actualCountLabel);
    }];
    
    [self.contentView addSubview:self.countLabel];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.limitPriceLabel.mas_bottom).offset(NNHMargin_10);
        make.left.equalTo(self.limitPriceLabel);
    }];

    UIImageView *leftIcon = [[UIImageView alloc] init];
    leftIcon.contentMode = UIViewContentModeCenter;
    [self.contentView addSubview:leftIcon];
    [self.iconArray addObject:leftIcon];
    
    UIImageView *middleIcon = [[UIImageView alloc] init];
    middleIcon.contentMode = UIViewContentModeCenter;
    [self.contentView addSubview:middleIcon];
    [self.iconArray addObject:middleIcon];
    
    UIImageView *rightIcon = [[UIImageView alloc] init];
    rightIcon.contentMode = UIViewContentModeCenter;
    [self.contentView addSubview:rightIcon];
    [self.iconArray addObject:rightIcon];
    
    [leftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(NNHMargin_20, NNHMargin_20));
        make.left.equalTo(self.actualCountLabel);
        make.bottom.equalTo(self.contentView).offset(-NNHMargin_10);
    }];
    
    [middleIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(NNHMargin_20, NNHMargin_20));
        make.centerY.equalTo(leftIcon);
        make.left.equalTo(leftIcon.mas_right).offset(5);
    }];
    
    [rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(NNHMargin_20, NNHMargin_20));
        make.centerY.equalTo(leftIcon);
        make.left.equalTo(middleIcon.mas_right).offset(5);
    }];
    
}

- (void)setTradeModel:(NNLegalTenderTradeModel *)tradeModel
{
    _tradeModel = tradeModel;
    self.nameLabel.text = tradeModel.nickname;
    self.priceLabel.text = [NSString stringWithFormat:@"%@ CNY",tradeModel.price];
    [self.priceLabel nnh_addAttringTextWithText:@"CNY" font:[UIConfigManager fontThemeTextTip] color:[UIConfigManager colorThemeDarkGray]];
    self.actualCountLabel.text = [NSString stringWithFormat:@"已成交 %@",tradeModel.clinch_num];
    self.completeLabel.text = [NSString stringWithFormat:@"成交率 %@",tradeModel.UserRules];
    self.limitPriceLabel.text = [NSString stringWithFormat:@"限额%@-%@",tradeModel.minmum, tradeModel.amount];
    self.countLabel.text = [NSString stringWithFormat:@"数量 %@",tradeModel.num];
    
    for (UIImageView *imageView in self.iconArray) {
        imageView.hidden = YES;
    }
    
    for (int i = 0; i < tradeModel.iconNameArray.count; i ++) {
        UIImageView *imageView = self.iconArray[i];
        imageView.image = [UIImage imageNamed:tradeModel.iconNameArray[i]];
        imageView.hidden = NO;
    }
    
    if ([tradeModel.type isEqualToString:@"1"]) {
        self.statusView.backgroundColor = [UIColor akext_colorWithHex:@"#3fbe72"];
    }else {
        self.statusView.backgroundColor = [UIConfigManager colorThemeRed];
    }
}

#pragma mark - Lazy Loads
- (UIView *)statusView
{
    if (_statusView == nil) {
        _statusView = [[UIView alloc] init];
        _statusView.backgroundColor = [UIConfigManager colorThemeRed];
    }
    return _statusView;
}

- (UILabel *)nameLabel
{
    if (_nameLabel == nil) {
        _nameLabel = [UILabel NNHWithTitle:@"" titleColor:[UIColor akext_colorWithHex:@"#1a3b55"] font:[UIFont boldSystemFontOfSize:14]];
        _nameLabel.backgroundColor = [UIColor whiteColor];
    }
    return _nameLabel;
}

- (UILabel *)priceLabel
{
    if (_priceLabel == nil) {
        _priceLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorThemeBlack] font:[UIFont boldSystemFontOfSize:16]];
        _priceLabel.backgroundColor = [UIColor whiteColor];
    }
    return _priceLabel;
}

- (UILabel *)limitPriceLabel
{
    if (_limitPriceLabel == nil) {
        _limitPriceLabel = [UILabel NNHWithTitle:@"" titleColor:[UIColor akext_colorWithHex:@"#899cab"] font:[UIConfigManager fontThemeTextTip]];
        _limitPriceLabel.backgroundColor = [UIColor whiteColor];
    }
    return _limitPriceLabel;
}

- (UILabel *)countLabel
{
    if (_countLabel == nil) {
        _countLabel = [UILabel NNHWithTitle:@"" titleColor:[UIColor akext_colorWithHex:@"#899cab"] font:[UIConfigManager fontThemeTextTip]];
        _countLabel.backgroundColor = [UIColor whiteColor];
    }
    return _countLabel;
}

- (UILabel *)actualCountLabel
{
    if (_actualCountLabel == nil) {
        _actualCountLabel = [UILabel NNHWithTitle:@"" titleColor:[UIColor akext_colorWithHex:@"#899cab"] font:[UIConfigManager fontThemeTextTip]];
        _actualCountLabel.backgroundColor = [UIColor whiteColor];
    }
    return _actualCountLabel;
}

- (UILabel *)completeLabel
{
    if (_completeLabel == nil) {
        _completeLabel = [UILabel NNHWithTitle:@"" titleColor:[UIColor akext_colorWithHex:@"#899cab"] font:[UIConfigManager fontThemeTextTip]];
    }
    return _completeLabel;
}

- (UIView *)lineView
{
    if (_lineView == nil) {
        _lineView = [UIView lineView];
        _lineView.backgroundColor = [UIColor whiteColor];
    }
    return _lineView;
}

- (NSMutableArray *)iconArray
{
    if (_iconArray == nil) {
        _iconArray = [NSMutableArray array];
    }
    return _iconArray;
}

- (UIImageView *)authImageView
{
    if (_authImageView == nil) {
        _authImageView = [[UIImageView alloc] init];
        _authImageView.image = [UIImage imageNamed:@"tag_vip"];
    }
    return _authImageView;
}

@end
