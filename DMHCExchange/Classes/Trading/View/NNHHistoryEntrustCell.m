//
//  NNHHistoryEntrustTableViewCell.m
//  SuperWallet
//
//  Created by 来旭磊 on 2018/3/20.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import "NNHHistoryEntrustCell.h"
#import "NNTradingEntrustModel.h"

@interface NNHHistoryEntrustCell ()

/** 委托状态 */
@property (nonatomic, strong) UIButton *entrustStatusButton;
/** 交易状态 */
@property (nonatomic, strong) UILabel *tradingStatusLabel;
/** 名称 */
@property (nonatomic, strong) UILabel *nameLabel;
/** 时间 */
@property (nonatomic, strong) UILabel *timeLabel;
/** 委托价格 */
@property (nonatomic, strong) UILabel *entrustPriceLabel;
@property (nonatomic, strong) UILabel *entrustPriceTitleLabel;
/** 成交价格 */
@property (nonatomic, strong) UILabel *tradingPriceLabel;
@property (nonatomic, strong) UILabel *tradingPriceTitleLabel;
/** 成交总额 */
@property (nonatomic, strong) UILabel *totalPriceLabel;
@property (nonatomic, strong) UILabel *totalPriceTitleLabel;
/** 数量 */
@property (nonatomic, strong) UILabel *entrustCountLabel;
@property (nonatomic, strong) UILabel *entrustCountTitleLabel;
/** 实际成交数量 */
@property (nonatomic, strong) UILabel *tradingCountLabel;
@property (nonatomic, strong) UILabel *tradingCountTitleLabel;

@end

@implementation NNHHistoryEntrustCell

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
    [self.contentView addSubview:self.entrustStatusButton];
    [self.entrustStatusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(NNHMargin_15);
        make.top.equalTo(self.contentView).offset(NNHMargin_15);
    }];
    
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.entrustStatusButton.mas_right).offset(NNHMargin_5);
        make.centerY.equalTo(self.entrustStatusButton);
    }];
    
    [self.contentView addSubview:self.tradingStatusLabel];
    [self.tradingStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-NNHMargin_15);
        make.baseline.equalTo(self.entrustStatusButton);
    }];
    
    UILabel *timeTitleLabel = [UILabel NNHWithTitle:@"时间" titleColor:[UIColor akext_colorWithHex:@"#c7d1d7"] font:[UIConfigManager fontThemeTextTip]];
    [self.contentView addSubview:timeTitleLabel];
    [timeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.entrustStatusButton);
        make.top.equalTo(self.entrustStatusButton.mas_bottom).offset(NNHMargin_20);
    }];
    
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.entrustStatusButton);
        make.top.equalTo(timeTitleLabel.mas_bottom).offset(NNHMargin_10);
    }];
    
    [self.contentView addSubview:self.entrustPriceTitleLabel];
    [self.entrustPriceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_centerX).offset(-35);
        make.centerY.equalTo(timeTitleLabel);
    }];
    
    [self.contentView addSubview:self.entrustPriceLabel];
    [self.entrustPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.entrustPriceTitleLabel);
        make.centerY.equalTo(self.timeLabel);
    }];
    
    [self.contentView addSubview:self.entrustCountTitleLabel];
    [self.entrustCountTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.tradingStatusLabel);
        make.centerY.equalTo(timeTitleLabel);
    }];
    
    [self.contentView addSubview:self.entrustCountLabel];
    [self.entrustCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.entrustCountTitleLabel);
        make.centerY.equalTo(self.timeLabel);
    }];
    
    [self.contentView addSubview:self.totalPriceTitleLabel];
    [self.totalPriceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.entrustStatusButton);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(NNHMargin_15);
    }];
    
    [self.contentView addSubview:self.totalPriceLabel];
    [self.totalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.entrustStatusButton);
        make.top.equalTo(self.totalPriceTitleLabel.mas_bottom).offset(NNHMargin_10);
    }];
    
    [self.contentView addSubview:self.tradingPriceTitleLabel];
    [self.tradingPriceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.entrustPriceTitleLabel);
        make.centerY.equalTo(self.totalPriceTitleLabel);
    }];
    
    [self.contentView addSubview:self.tradingPriceLabel];
    [self.tradingPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.entrustPriceTitleLabel);
        make.centerY.equalTo(self.totalPriceLabel);
    }];
    
    [self.contentView addSubview:self.tradingCountTitleLabel];
    [self.tradingCountTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.tradingStatusLabel);
        make.centerY.equalTo(self.totalPriceTitleLabel);
    }];
    
    [self.contentView addSubview:self.tradingCountLabel];
    [self.tradingCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.tradingStatusLabel);
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
    self.timeLabel.text = [tradingEntrustModel.addtime substringFromIndex:5];
    self.entrustPriceTitleLabel.text = [NSString stringWithFormat:@"委托价 (%@)",tradingEntrustModel.unitcoinname];
    self.entrustPriceLabel.text = tradingEntrustModel.price;
    self.entrustCountTitleLabel.text = [NSString stringWithFormat:@"委托量 (%@)",tradingEntrustModel.coinname];
    self.entrustCountLabel.text = tradingEntrustModel.totalnum;
    self.totalPriceTitleLabel.text = [NSString stringWithFormat:@"成交总额 (%@)",tradingEntrustModel.unitcoinname];
    self.totalPriceLabel.text = tradingEntrustModel.unitnum;
    self.tradingPriceTitleLabel.text = [NSString stringWithFormat:@"成交均价 (%@)",tradingEntrustModel.unitcoinname];
    self.tradingPriceLabel.text = tradingEntrustModel.averages;
    self.tradingCountTitleLabel.text = [NSString stringWithFormat:@"成交量 (%@)",tradingEntrustModel.coinname];
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

- (UILabel *)timeLabel
{
    if (_timeLabel == nil) {
        _timeLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorThemeDark] font:[UIConfigManager fontThemeTextDefault]];
        _timeLabel.backgroundColor = [UIColor whiteColor];
    }
    return _timeLabel;
}

- (UILabel *)tradingStatusLabel
{
    if (_tradingStatusLabel == nil) {
        _tradingStatusLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorThemeDark] font:[UIFont boldSystemFontOfSize:13]];
        _tradingStatusLabel.backgroundColor = [UIColor whiteColor];
    }
    return _tradingStatusLabel;
}

- (UILabel *)entrustPriceTitleLabel
{
    if (_entrustPriceTitleLabel == nil) {
        _entrustPriceTitleLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorTextLightGray] font:[UIConfigManager fontThemeTextTip]];
        _entrustPriceTitleLabel.backgroundColor = [UIColor whiteColor];
    }
    return _entrustPriceTitleLabel;
}

- (UILabel *)entrustPriceLabel
{
    if (_entrustPriceLabel == nil) {
        _entrustPriceLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorThemeDark] font:[UIConfigManager fontThemeTextDefault]];
        _entrustPriceLabel.backgroundColor = [UIColor whiteColor];
    }
    return _entrustPriceLabel;
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

- (UILabel *)entrustCountTitleLabel
{
    if (_entrustCountTitleLabel == nil) {
        _entrustCountTitleLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorTextLightGray] font:[UIConfigManager fontThemeTextTip]];
        _entrustCountTitleLabel.backgroundColor = [UIColor whiteColor];
    }
    return _entrustCountTitleLabel;
}

- (UILabel *)entrustCountLabel
{
    if (_entrustCountLabel == nil) {
        _entrustCountLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorThemeDark] font:[UIConfigManager fontThemeTextDefault]];
        _entrustCountLabel.backgroundColor = [UIColor whiteColor];
    }
    return _entrustCountLabel;
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
