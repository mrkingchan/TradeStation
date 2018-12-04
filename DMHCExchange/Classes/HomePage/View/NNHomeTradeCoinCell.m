//
//  NNHomeTradeCoinCell.m
//  DMHCExchange
//
//  Created by 云笈 on 2018/10/31.
//  Copyright © 2018年 超级钱包. All rights reserved.
//

#import "NNHomeTradeCoinCell.h"


@interface NNHomeTradeCoinCell ()

/** 币名称 */
@property (nonatomic, strong) UILabel *coinNameLabel;
/** 交易对 */
@property (nonatomic, strong) UILabel *ccyLabel;
/** 美元价格 */
@property (nonatomic, strong) UILabel *coinUSDPriceLabel;
/** 展示百分比 */
@property (nonatomic, strong) UILabel *percentageLabel;
/** 最高价 */
@property (nonatomic, strong) UILabel *maxPriceLabel;
/** 最低价 */
@property (nonatomic, strong) UILabel *minPriceLabel;
/** 成交量 */
@property (nonatomic, strong) UILabel *volumeLabel;

@end

@implementation NNHomeTradeCoinCell

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
    [self.contentView addSubview:self.coinNameLabel];
    [self.coinNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(15);
        make.left.equalTo(self.contentView).offset(15);
    }];
    
    [self.contentView addSubview:self.ccyLabel];
    [self.ccyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.baseline.equalTo(self.coinNameLabel);
        make.left.equalTo(self.coinNameLabel.mas_right);
    }];
    
    CGFloat percentageLabelW = 70;
    CGFloat otherLabelW = (SCREEN_WIDTH - 30) / 3;
    [self.contentView addSubview:self.percentageLabel];
    [self.percentageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.coinNameLabel);
        make.width.equalTo(@(percentageLabelW));
        make.height.equalTo(@(25));
    }];
    
    UILabel *maxTitleLabel = [UILabel NNHWithTitle:@"最高价" titleColor:[UIConfigManager colorTextLightGray] font:[UIConfigManager fontThemeTextTip]];
    maxTitleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:maxTitleLabel];
    [maxTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coinNameLabel.mas_bottom).offset(10);
        make.left.equalTo(self.coinNameLabel);
        make.width.equalTo(@(otherLabelW + 15));
    }];
    
    [self.contentView addSubview:self.maxPriceLabel];
    [self.maxPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(maxTitleLabel.mas_bottom).offset(3);
        make.left.equalTo(self.coinNameLabel);
        make.width.equalTo(maxTitleLabel);
    }];
    
    UILabel *minxTitleLabel = [UILabel NNHWithTitle:@"最低价" titleColor:[UIConfigManager colorTextLightGray] font:[UIConfigManager fontThemeTextTip]];
    minxTitleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:minxTitleLabel];
    [minxTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(maxTitleLabel);
        make.left.equalTo(maxTitleLabel.mas_right);
        make.width.equalTo(maxTitleLabel);
    }];
    
    [self.contentView addSubview:self.minPriceLabel];
    [self.minPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.maxPriceLabel);
        make.left.equalTo(minxTitleLabel);
        make.width.equalTo(maxTitleLabel);
    }];
    
    UILabel *volumeTitleLabel = [UILabel NNHWithTitle:@"日成交量" titleColor:[UIConfigManager colorTextLightGray] font:[UIConfigManager fontThemeTextTip]];
    volumeTitleLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:volumeTitleLabel];
    [volumeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(maxTitleLabel);
        make.left.equalTo(minxTitleLabel.mas_right);
        make.right.equalTo(self.percentageLabel);
    }];
    
    [self.contentView addSubview:self.volumeLabel];
    [self.volumeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.maxPriceLabel);
        make.left.right.equalTo(volumeTitleLabel);
    }];
    
    [self.contentView addSubview:self.coinUSDPriceLabel];
    [self.coinUSDPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coinNameLabel);
        make.left.right.equalTo(minxTitleLabel);
    }];
}

#pragma mark - Lazy Loads
- (UILabel *)coinNameLabel
{
    if (_coinNameLabel == nil) {
        _coinNameLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorThemeDark] font:[UIFont boldSystemFontOfSize:15]];
        _coinNameLabel.backgroundColor = [UIColor whiteColor];
    }
    return _coinNameLabel;
}

- (UILabel *)ccyLabel
{
    if (_ccyLabel == nil) {
        _ccyLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorTextLightGray] font:[UIConfigManager fontThemeTextMinTip]];
        _ccyLabel.backgroundColor = [UIColor whiteColor];
    }
    return _ccyLabel;
}

- (UILabel *)coinUSDPriceLabel
{
    if (_coinUSDPriceLabel == nil) {
        _coinUSDPriceLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorThemeDark] font:[UIFont boldSystemFontOfSize:15]];
        _coinUSDPriceLabel.backgroundColor = [UIColor whiteColor];
        _coinUSDPriceLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _coinUSDPriceLabel;
}

- (UILabel *)percentageLabel
{
    if (_percentageLabel == nil) {
        _percentageLabel = [UILabel NNHWithTitle:@"-0.00%" titleColor:[UIConfigManager colorThemeWhite] font:[UIConfigManager fontThemeTextTip]];
        _percentageLabel.textAlignment = NSTextAlignmentCenter;
        _percentageLabel.backgroundColor = NNHRGBColor(32, 191, 136);
    }
    return _percentageLabel;
}

- (UILabel *)maxPriceLabel
{
    if (_maxPriceLabel == nil) {
        _maxPriceLabel = [UILabel NNHWithTitle:@"0.000000000" titleColor:[UIConfigManager colorTextLightGray] font:[UIConfigManager fontThemeTextTip]];
        _maxPriceLabel.textAlignment = NSTextAlignmentLeft;
        _maxPriceLabel.backgroundColor = [UIColor whiteColor];
    }
    return _maxPriceLabel;
}

- (UILabel *)minPriceLabel
{
    if (_minPriceLabel == nil) {
        _minPriceLabel = [UILabel NNHWithTitle:@"0.000000000" titleColor:[UIConfigManager colorTextLightGray] font:[UIConfigManager fontThemeTextTip]];
        _minPriceLabel.backgroundColor = [UIColor whiteColor];
        _minPriceLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _minPriceLabel;
}

- (UILabel *)volumeLabel
{
    if (_volumeLabel == nil) {
        _volumeLabel = [UILabel NNHWithTitle:@"0.000000000" titleColor:[UIConfigManager colorTextLightGray] font:[UIConfigManager fontThemeTextTip]];
        _volumeLabel.backgroundColor = [UIColor whiteColor];
        _volumeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _volumeLabel;
}

#pragma mark - private Method
- (void)setModel:(NNCoinTradingMarketModel *)model {
    NSParameterAssert(model);
    _model = model;
    self.coinNameLabel.text = model.coinname;
    self.ccyLabel.text = [NSString stringWithFormat:@"/%@",model.unitcoinname];
    self.coinUSDPriceLabel.text = model.close_price;
    self.percentageLabel.text = [NSString stringWithFormat:@"%@",model.changestr];
    if ([model.change containsString:@"-"]) { // 下跌
        self.percentageLabel.backgroundColor = [UIConfigManager colorThemeRed];
    }else { // 上涨
        self.percentageLabel.backgroundColor = [UIColor akext_colorWithHex:@"#3fbe27"];
    }
    self.minPriceLabel.text = model.min_price;
    self.maxPriceLabel.text = model.max_price;
    self.volumeLabel.text = model.volume;
}

@end
