//
//  NNHCurrentEntrustTableViewCell.m
//  SuperWallet
//
//  Created by 来旭磊 on 2018/3/20.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import "NNHCurrentEntrustCell.h"
#import "NNTradingEntrustModel.h"

@interface NNHCurrentEntrustCell ()

/** 委托状态 */
@property (nonatomic, strong) UIButton *entrustStatusButton;
/** 交易状态 */
@property (nonatomic, strong) UIButton *tradingStatusButton;
/** 名称 */
@property (nonatomic, strong) UILabel *nameLabel;
/** 时间 */
@property (nonatomic, strong) UILabel *timeLabel;
/** 价格 */
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *priceTitleLabel;
/** 数量 */
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UILabel *countTitleLabel;
/** 实际成交数量 */
@property (nonatomic, strong) UILabel *actualCountLabel;
@property (nonatomic, strong) UILabel *actualCountTitleLabel;

@end

@implementation NNHCurrentEntrustCell

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
    
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).offset(NNHMargin_5);
        make.baseline.equalTo(self.nameLabel);
    }];
    
    [self.contentView addSubview:self.tradingStatusButton];
    [self.tradingStatusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-NNHMargin_15);
        make.centerY.equalTo(self.entrustStatusButton);
        make.width.equalTo(@65);
        make.height.equalTo(@25);
    }];
    
    [self.contentView addSubview:self.priceTitleLabel];
    [self.priceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.entrustStatusButton);
        make.top.equalTo(self.entrustStatusButton.mas_bottom).offset(NNHMargin_20);
    }];
    
    [self.contentView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.entrustStatusButton);
        make.top.equalTo(self.priceTitleLabel.mas_bottom).offset(NNHMargin_10);
    }];
    
    [self.contentView addSubview:self.countTitleLabel];
    [self.countTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_centerX).offset(-35);
        make.centerY.equalTo(self.priceTitleLabel);
    }];
    
    [self.contentView addSubview:self.countLabel];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.countTitleLabel);
        make.centerY.equalTo(self.priceLabel);
    }];
    
    [self.contentView addSubview:self.actualCountTitleLabel];
    [self.actualCountTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.tradingStatusButton);
        make.centerY.equalTo(self.priceTitleLabel);
    }];
    
    [self.contentView addSubview:self.actualCountLabel];
    [self.actualCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.tradingStatusButton);
        make.centerY.equalTo(self.priceLabel);
    }];
}

- (void)setTradingEntrustModel:(NNTradingEntrustModel *)tradingEntrustModel
{
    _tradingEntrustModel = tradingEntrustModel;
    
    self.entrustStatusButton.selected = [tradingEntrustModel.type integerValue] != 1;
    
    NSString *toStr = [NSString stringWithFormat:@"/%@",tradingEntrustModel.unitcoinname];
    self.nameLabel.attributedText = [NSMutableAttributedString nn_changeFontAndColor:[UIConfigManager fontThemeTextTip] Color:[UIConfigManager colorTextLightGray] TotalString:tradingEntrustModel.name SubStringArray:@[toStr]];
    
    self.timeLabel.text = [tradingEntrustModel.addtime substringFromIndex:5];
    self.priceTitleLabel.text = [NSString stringWithFormat:@"价格 (%@)",tradingEntrustModel.unitcoinname];
    self.priceLabel.text = tradingEntrustModel.price;
    self.countTitleLabel.text = [NSString stringWithFormat:@"数量 (%@)",tradingEntrustModel.coinname];
    self.countLabel.text = tradingEntrustModel.totalnum;
    self.actualCountTitleLabel.text = [NSString stringWithFormat:@"实际成交 (%@)",tradingEntrustModel.coinname];
    self.actualCountLabel.text = tradingEntrustModel.num;
}

- (void)cancleButtonAction
{
    if (self.cancleBlock) {
        self.cancleBlock(self.tradingEntrustModel.ID);
    }
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
        _timeLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorTextLightGray] font:[UIConfigManager fontThemeTextMinTip]];
        _timeLabel.backgroundColor = [UIColor whiteColor];
    }
    return _timeLabel;
}

- (UIButton *)tradingStatusButton
{
    if (_tradingStatusButton == nil) {
        _tradingStatusButton = [UIButton NNHBtnTitle:@"撤单" titileFont:[UIConfigManager fontThemeTextDefault] backGround:[UIColor whiteColor] titleColor:[UIConfigManager colorThemeRed]];
        [_tradingStatusButton addTarget:self action:@selector(cancleButtonAction) forControlEvents:UIControlEventTouchUpInside];
        NNHViewBorderRadius(_tradingStatusButton, 0.00, 0.5, [UIConfigManager colorThemeRed]);
    }
    return _tradingStatusButton;
}

- (UILabel *)priceTitleLabel
{
    if (_priceTitleLabel == nil) {
        _priceTitleLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorTextLightGray] font:[UIConfigManager fontThemeTextTip]];
        _priceTitleLabel.backgroundColor = [UIColor whiteColor];
    }
    return _priceTitleLabel;
}

- (UILabel *)priceLabel
{
    if (_priceLabel == nil) {
        _priceLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorThemeDark] font:[UIConfigManager fontThemeTextDefault]];
        _priceLabel.backgroundColor = [UIColor whiteColor];
    }
    return _priceLabel;
}

- (UILabel *)countTitleLabel
{
    if (_countTitleLabel == nil) {
        _countTitleLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorTextLightGray] font:[UIConfigManager fontThemeTextTip]];
        _countTitleLabel.backgroundColor = [UIColor whiteColor];
    }
    return _countTitleLabel;
}

- (UILabel *)countLabel
{
    if (_countLabel == nil) {
        _countLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorThemeDark] font:[UIConfigManager fontThemeTextDefault]];
        _countLabel.backgroundColor = [UIColor whiteColor];
    }
    return _countLabel;
}

- (UILabel *)actualCountTitleLabel
{
    if (_actualCountTitleLabel == nil) {
        _actualCountTitleLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorTextLightGray] font:[UIConfigManager fontThemeTextTip]];
        _actualCountTitleLabel.backgroundColor = [UIColor whiteColor];
    }
    return _actualCountTitleLabel;
}

- (UILabel *)actualCountLabel
{
    if (_actualCountLabel == nil) {
        _actualCountLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorThemeDark] font:[UIConfigManager fontThemeTextDefault]];
        _actualCountLabel.backgroundColor = [UIColor whiteColor];
    }
    return _actualCountLabel;
}

@end
