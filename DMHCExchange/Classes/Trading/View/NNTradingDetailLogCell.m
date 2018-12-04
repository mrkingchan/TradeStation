//
//  NNTradingDetailLogCell.m
//  SuperWallet
//
//  Created by 牛牛 on 2018/8/15.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import "NNTradingDetailLogCell.h"
#import "NNTradingEntrustModel.h"

@interface NNTradingDetailLogCell ()

/** 时间 */
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *timeTitleLabel;
/** 成交价格 */
@property (nonatomic, strong) UILabel *tradingPriceLabel;
@property (nonatomic, strong) UILabel *tradingPriceTitleLabel;
/** 实际成交数量 */
@property (nonatomic, strong) UILabel *tradingCountLabel;
@property (nonatomic, strong) UILabel *tradingCountTitleLabel;
/** 手续费 */
@property (nonatomic, strong) UILabel *feeLabel;
@property (nonatomic, strong) UILabel *feeTitleLabel;

@end

@implementation NNTradingDetailLogCell

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
    [self.contentView addSubview:self.timeTitleLabel];
    [self.timeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(NNHMargin_15);
        make.left.equalTo(self.contentView).offset(NNHMargin_15);
    }];
    
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-NNHMargin_15);
        make.centerY.equalTo(self.timeTitleLabel);
    }];
    
    [self.contentView addSubview:self.tradingPriceTitleLabel];
    [self.tradingPriceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeTitleLabel.mas_bottom).offset(NNHMargin_15);
        make.left.equalTo(self.timeTitleLabel);
    }];
    
    [self.contentView addSubview:self.tradingPriceLabel];
    [self.tradingPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.timeLabel);
        make.centerY.equalTo(self.tradingPriceTitleLabel);
    }];
    
    [self.contentView addSubview:self.tradingCountTitleLabel];
    [self.tradingCountTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tradingPriceLabel.mas_bottom).offset(NNHMargin_15);
        make.left.equalTo(self.timeTitleLabel);
    }];
    
    [self.contentView addSubview:self.tradingCountLabel];
    [self.tradingCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.timeLabel);
        make.centerY.equalTo(self.tradingCountTitleLabel);
    }];
    
    [self.contentView addSubview:self.feeTitleLabel];
    [self.feeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tradingCountLabel.mas_bottom).offset(NNHMargin_15);
        make.left.equalTo(self.timeTitleLabel);
    }];
    
    [self.contentView addSubview:self.feeLabel];
    [self.feeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.timeLabel);
        make.centerY.equalTo(self.feeTitleLabel);
    }];
}

- (void)setTradingLogModel:(NNTradingLogModel *)tradingLogModel
{
    _tradingLogModel = tradingLogModel;

    self.timeLabel.text = tradingLogModel.matchtime;
    
    NSString *priceStr = [NSString stringWithFormat:@"%@ %@",tradingLogModel.price,tradingLogModel.unitcoinname];
    self.tradingPriceLabel.attributedText = [NSMutableAttributedString nn_changeFontAndColor:[UIConfigManager fontThemeTextMinTip] Color:[UIConfigManager colorTextLightGray] TotalString:priceStr SubStringArray:@[tradingLogModel.unitcoinname]];
    
    NSString *countStr = [NSString stringWithFormat:@"%@ %@",tradingLogModel.num,tradingLogModel.coinname];
    self.tradingCountLabel.attributedText = [NSMutableAttributedString nn_changeFontAndColor:[UIConfigManager fontThemeTextMinTip] Color:[UIConfigManager colorTextLightGray] TotalString:countStr SubStringArray:@[tradingLogModel.coinname]];
    
    NSString *feeStr = [NSString stringWithFormat:@"%@ %@",tradingLogModel.fee,tradingLogModel.coinname];
    NSString *toFeeStr = tradingLogModel.coinname;
    if ([tradingLogModel.type integerValue] != 1) {
        feeStr = [NSString stringWithFormat:@"%@ %@",tradingLogModel.fee,tradingLogModel.unitcoinname];
        toFeeStr = tradingLogModel.unitcoinname;
    }
    self.feeLabel.attributedText = [NSMutableAttributedString nn_changeFontAndColor:[UIConfigManager fontThemeTextMinTip] Color:[UIConfigManager colorTextLightGray] TotalString:feeStr SubStringArray:@[toFeeStr]];
    
}

- (UILabel *)timeTitleLabel
{
    if (_timeTitleLabel == nil) {
        _timeTitleLabel = [UILabel NNHWithTitle:@"时间" titleColor:[UIConfigManager colorTextLightGray] font:[UIConfigManager fontThemeTextDefault]];
        _timeTitleLabel.backgroundColor = [UIColor whiteColor];
    }
    return _timeTitleLabel;
}

- (UILabel *)timeLabel
{
    if (_timeLabel == nil) {
        _timeLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorTextLightGray] font:[UIConfigManager fontThemeTextDefault]];
        _timeLabel.backgroundColor = [UIColor whiteColor];
    }
    return _timeLabel;
}

- (UILabel *)tradingPriceTitleLabel
{
    if (_tradingPriceTitleLabel == nil) {
        _tradingPriceTitleLabel = [UILabel NNHWithTitle:@"成交价" titleColor:[UIConfigManager colorTextLightGray] font:[UIConfigManager fontThemeTextDefault]];
        _tradingPriceTitleLabel.backgroundColor = [UIColor whiteColor];
    }
    return _tradingPriceTitleLabel;
}

- (UILabel *)tradingPriceLabel
{
    if (_tradingPriceLabel == nil) {
        _tradingPriceLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorTextLightGray] font:[UIConfigManager fontThemeTextDefault]];
        _tradingPriceLabel.backgroundColor = [UIColor whiteColor];
    }
    return _tradingPriceLabel;
}


- (UILabel *)tradingCountTitleLabel
{
    if (_tradingCountTitleLabel == nil) {
        _tradingCountTitleLabel = [UILabel NNHWithTitle:@"成交量" titleColor:[UIConfigManager colorTextLightGray] font:[UIConfigManager fontThemeTextDefault]];
        _tradingCountTitleLabel.backgroundColor = [UIColor whiteColor];
    }
    return _tradingCountTitleLabel;
}

- (UILabel *)tradingCountLabel
{
    if (_tradingCountLabel == nil) {
        _tradingCountLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorTextLightGray] font:[UIConfigManager fontThemeTextDefault]];
        _tradingCountLabel.backgroundColor = [UIColor whiteColor];
    }
    return _tradingCountLabel;
}

- (UILabel *)feeTitleLabel
{
    if (_feeTitleLabel == nil) {
        _feeTitleLabel = [UILabel NNHWithTitle:@"手续费" titleColor:[UIConfigManager colorTextLightGray] font:[UIConfigManager fontThemeTextDefault]];
        _feeTitleLabel.backgroundColor = [UIColor whiteColor];
    }
    return _feeTitleLabel;
}

- (UILabel *)feeLabel
{
    if (_feeLabel == nil) {
        _feeLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorTextLightGray] font:[UIConfigManager fontThemeTextDefault]];
        _feeLabel.backgroundColor = [UIColor whiteColor];
    }
    return _feeLabel;
}

@end
