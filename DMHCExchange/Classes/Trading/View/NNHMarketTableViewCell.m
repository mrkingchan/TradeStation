//
//  NNHMarketTableViewCell.m
//  SuperWallet
//
//  Created by 来旭磊 on 2018/3/5.
//  Copyright © 2018年 超级钱包. All rights reserved.
//

#import "NNHMarketTableViewCell.h"
#import "NNHCoinPriceModel.h"

@interface NNHMarketTableViewCell ()


/** 币展示图片 */
@property (nonatomic, strong) UIImageView *coinImageView;
/** 币名称 */
@property (nonatomic, strong) UILabel *coinNameLabel;
/** 兑换比例 */
@property (nonatomic, strong) UILabel *coinRatioLabel;
/** 人民币价格 */
@property (nonatomic, strong) UILabel *coinRMBPriceLabel;
/** 展示百分比 */
@property (nonatomic, strong) UILabel *percentageLabel;
@end

@implementation NNHMarketTableViewCell

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
    [self.contentView addSubview:self.coinImageView];
    [self.contentView addSubview:self.coinNameLabel];
    [self.contentView addSubview:self.coinRatioLabel];
    [self.contentView addSubview:self.coinRMBPriceLabel];
    [self.contentView addSubview:self.percentageLabel];
    
    [self.coinImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(NNHMargin_10);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
    
    [self.coinNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.coinImageView.mas_right).offset(10);
    }];
    
    [self.coinRatioLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_centerY).offset(-3);
        make.left.equalTo(self.contentView.mas_centerX).offset(-NNHMargin_20);
    }];
    
    [self.coinRMBPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_centerY).offset(3);
        make.left.equalTo(self.coinRatioLabel);
    }];
    
    [self.percentageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(@(75));
        make.height.equalTo(@(30));
        make.right.equalTo(self.contentView).offset(-NNHMargin_20);
    }];
}

- (void)setPriceModel:(NNHCoinPriceModel *)priceModel
{
    _priceModel = priceModel;
    
    self.coinNameLabel.text = priceModel.title;

    [self.coinImageView sd_setImageWithURL:[NSURL URLWithString:priceModel.img] placeholderImage:ImageName(@"Hcoin-icon")];
    
    if (priceModel.riseFlag) { //上涨
        
        self.percentageLabel.text = [NSString stringWithFormat:@"+%.2f%%",priceModel.changeRate];
        self.percentageLabel.backgroundColor = [UIColor akext_colorWithHex:@"#009759"];
        self.coinRatioLabel.textColor = [UIColor akext_colorWithHex:@"#009759"];
        
    }else { //下跌
        
        self.percentageLabel.text = [NSString stringWithFormat:@"%.2f%%",priceModel.changeRate];
        self.percentageLabel.backgroundColor = [UIConfigManager colorTabBarTitleHeight];
        self.coinRatioLabel.textColor = [UIConfigManager colorTabBarTitleHeight];
    }

    NNHCoinPriceSubModel *lastPriceModel = priceModel.last;
    
    self.coinRatioLabel.text = lastPriceModel.cny;
    self.coinRMBPriceLabel.text = [NSString stringWithFormat:@"≈ $ %@",lastPriceModel.usd];
    
}


#pragma mark - Lazy Loads

- (UIImageView *)coinImageView
{
    if (_coinImageView == nil) {
        _coinImageView = [[UIImageView alloc] init];
        _coinImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _coinImageView;
}

- (UILabel *)coinNameLabel
{
    if (_coinNameLabel == nil) {
        _coinNameLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorThemeBlack] font:[UIFont boldSystemFontOfSize:16]];

    }
    return _coinNameLabel;
}

- (UILabel *)coinRatioLabel
{
    if (_coinRatioLabel == nil) {
        _coinRatioLabel = [UILabel NNHWithTitle:@"" titleColor:[UIColor akext_colorWithHex:@"#da251c"] font:[UIConfigManager fontThemeTextMain]];
    }
    return _coinRatioLabel;
}

- (UILabel *)coinRMBPriceLabel
{
    if (_coinRMBPriceLabel == nil) {
        _coinRMBPriceLabel = [UILabel NNHWithTitle:@"≈ $73000" titleColor:[UIColor akext_colorWithHex:@"#808080"] font:[UIConfigManager fontThemeTextTip]];
    }
    return _coinRMBPriceLabel;
}

- (UILabel *)percentageLabel
{
    if (_percentageLabel == nil) {
        _percentageLabel = [UILabel NNHWithTitle:@"-0.00%" titleColor:[UIConfigManager colorThemeWhite] font:[UIConfigManager fontThemeTextTip]];
        _percentageLabel.textAlignment = NSTextAlignmentCenter;
        _percentageLabel.layer.cornerRadius = 2.5;
        _percentageLabel.layer.masksToBounds = YES;
        _percentageLabel.backgroundColor = [UIColor akext_colorWithHex:@"#da251c"];
    }
    return _percentageLabel;
}



@end
