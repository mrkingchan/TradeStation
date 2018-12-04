//
//  NNTradingDetailLogHeaderView.m
//  SuperWallet
//
//  Created by 牛牛 on 2018/8/15.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import "NNTradingDetailLogHeaderView.h"
#import "NNTradingEntrustModel.h"

@interface NNTradingDetailLogHeaderView ()

/** 委托状态 */
@property (nonatomic, strong) UIButton *entrustStatusButton;
/** 名称 */
@property (nonatomic, strong) UILabel *nameLabel;
/** 交易状态 */
@property (nonatomic, strong) UILabel *tradingStatusLabel;
/** 成交价格 */
@property (nonatomic, strong) UILabel *tradingPriceLabel;
@property (nonatomic, strong) UILabel *tradingPriceTitleLabel;
/** 成交总额 */
@property (nonatomic, strong) UILabel *totalPriceLabel;
@property (nonatomic, strong) UILabel *totalPriceTitleLabel;
/** 成交数量 */
@property (nonatomic, strong) UILabel *tradingCountLabel;
@property (nonatomic, strong) UILabel *tradingCountTitleLabel;

@end

@implementation NNTradingDetailLogHeaderView

- (instancetype)init
{
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self setupChildView];
        
    }
    return self;
}

- (void)setupChildView
{
    [self addSubview:self.entrustStatusButton];
    [self.entrustStatusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(NNHMargin_15);
        make.top.equalTo(self).offset(NNHMargin_15);
    }];
    
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.entrustStatusButton.mas_right).offset(NNHMargin_5);
        make.centerY.equalTo(self.entrustStatusButton);
    }];
    
    [self addSubview:self.tradingStatusLabel];
    [self.tradingStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-NNHMargin_15);
        make.baseline.equalTo(self.entrustStatusButton);
    }];
    
    [self addSubview:self.totalPriceTitleLabel];
    [self.totalPriceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.entrustStatusButton);
        make.top.equalTo(self.entrustStatusButton.mas_bottom).offset(NNHMargin_20);
    }];
    
    [self addSubview:self.totalPriceLabel];
    [self.totalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.entrustStatusButton);
        make.top.equalTo(self.totalPriceTitleLabel.mas_bottom).offset(NNHMargin_10);
    }];
    
    [self addSubview:self.tradingPriceTitleLabel];
    [self.tradingPriceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_centerX).offset(-35);
        make.centerY.equalTo(self.totalPriceTitleLabel);
    }];
    
    [self addSubview:self.tradingPriceLabel];
    [self.tradingPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tradingPriceTitleLabel);
        make.centerY.equalTo(self.totalPriceLabel);
    }];
    
    [self addSubview:self.tradingCountTitleLabel];
    [self.tradingCountTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-NNHMargin_15);
        make.centerY.equalTo(self.totalPriceTitleLabel);
    }];
    
    [self addSubview:self.tradingCountLabel];
    [self.tradingCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.tradingCountTitleLabel);
        make.centerY.equalTo(self.totalPriceLabel);
    }];
}

- (void)setTradingEntrustModel:(NNTradingEntrustModel *)tradingEntrustModel
{
    _tradingEntrustModel = tradingEntrustModel;
    
    self.entrustStatusButton.selected = [tradingEntrustModel.type integerValue] != 1;
    
    NSString *toStr = [NSString stringWithFormat:@"/%@",tradingEntrustModel.unitcoinname];
    self.nameLabel.attributedText = [NSMutableAttributedString nn_changeFontAndColor:[UIConfigManager fontThemeTextTip] Color:[UIConfigManager colorTextLightGray] TotalString:tradingEntrustModel.name SubStringArray:@[toStr]];
    self.tradingStatusLabel.text = tradingEntrustModel.statusText;
    self.totalPriceTitleLabel.text = [NSString stringWithFormat:@"成交总额(%@)",tradingEntrustModel.unitcoinname];
    self.totalPriceLabel.text = tradingEntrustModel.unitnum;
    self.tradingPriceTitleLabel.text = [NSString stringWithFormat:@"成交均价(%@)",tradingEntrustModel.unitcoinname];
    self.tradingPriceLabel.text = tradingEntrustModel.averages;
    self.tradingCountTitleLabel.text = [NSString stringWithFormat:@"成交量(%@)",tradingEntrustModel.coinname];
    self.tradingCountLabel.text = tradingEntrustModel.num;
}

#pragma mark - Lazy Loads
- (UIButton *)entrustStatusButton
{
    if (_entrustStatusButton == nil) {
        _entrustStatusButton = [UIButton NNHBtnImage:@"tag_buy" target:self action:nil];
        [_entrustStatusButton setImage:ImageName(@"tag_sale") forState:UIControlStateSelected];
    }
    return _entrustStatusButton;
}

- (UILabel *)nameLabel
{
    if (_nameLabel == nil) {
        _nameLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorThemeDark] font:[UIFont boldSystemFontOfSize:15]];
        _nameLabel.backgroundColor = [UIColor whiteColor];
    }
    return _nameLabel;
}

- (UILabel *)tradingStatusLabel
{
    if (_tradingStatusLabel == nil) {
        _tradingStatusLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorThemeDark] font:[UIFont boldSystemFontOfSize:13]];
        _tradingStatusLabel.backgroundColor = [UIColor whiteColor];
    }
    return _tradingStatusLabel;
}

- (UILabel *)tradingPriceTitleLabel
{
    if (_tradingPriceTitleLabel == nil) {
        _tradingPriceTitleLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorTextLightGray] font:[UIConfigManager fontThemeTextTip]];
        _tradingPriceTitleLabel.backgroundColor = [UIColor whiteColor];
    }
    return _tradingPriceTitleLabel;
}

- (UILabel *)tradingPriceLabel
{
    if (_tradingPriceLabel == nil) {
        _tradingPriceLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorThemeDark] font:[UIConfigManager fontThemeTextDefault]];
        _tradingPriceLabel.backgroundColor = [UIColor whiteColor];
    }
    return _tradingPriceLabel;
}

- (UILabel *)tradingCountTitleLabel
{
    if (_tradingCountTitleLabel == nil) {
        _tradingCountTitleLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorTextLightGray] font:[UIConfigManager fontThemeTextTip]];
        _tradingCountTitleLabel.backgroundColor = [UIColor whiteColor];
    }
    return _tradingCountTitleLabel;
}

- (UILabel *)tradingCountLabel
{
    if (_tradingCountLabel == nil) {
        _tradingCountLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorThemeDark] font:[UIConfigManager fontThemeTextDefault]];
        _tradingCountLabel.backgroundColor = [UIColor whiteColor];
    }
    return _tradingCountLabel;
}

- (UILabel *)totalPriceTitleLabel
{
    if (_totalPriceTitleLabel == nil) {
        _totalPriceTitleLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorTextLightGray] font:[UIConfigManager fontThemeTextTip]];
        _totalPriceTitleLabel.backgroundColor = [UIColor whiteColor];
    }
    return _totalPriceTitleLabel;
}

- (UILabel *)totalPriceLabel
{
    if (_totalPriceLabel == nil) {
        _totalPriceLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorThemeDark] font:[UIConfigManager fontThemeTextDefault]];
        _totalPriceLabel.backgroundColor = [UIColor whiteColor];
    }
    return _totalPriceLabel;
}

@end
