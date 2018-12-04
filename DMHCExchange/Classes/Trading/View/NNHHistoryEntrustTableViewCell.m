//
//  NNHHistoryEntrustTableViewCell.m
//  SuperWallet
//
//  Created by 来旭磊 on 2018/3/20.
//  Copyright © 2018年 超级钱包. All rights reserved.
//

#import "NNHHistoryEntrustTableViewCell.h"
#import "NNTradingEntrustModel.h"

@interface NNHHistoryEntrustTableViewCell ()

/** 状态图片 */
@property (nonatomic, strong) UIImageView *statusImageView;
/** 名称 */
@property (nonatomic, strong) UILabel *nameLabel;
/** 成交数量 */
@property (nonatomic, strong) UILabel *countLabel;
/** 总数量 */
@property (nonatomic, strong) UILabel *totalCountLabel;
/** 成交价格 */
@property (nonatomic, strong) UILabel *priceLabel;
/** 设定价格 */
@property (nonatomic, strong) UILabel *setupPriceLabel;
/** 时间 */
@property (nonatomic, strong) UILabel *timeLabel;



@end

@implementation NNHHistoryEntrustTableViewCell

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
    [self.contentView addSubview:self.statusImageView];
    [self.statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(NNHMargin_15);
        make.bottom.equalTo(self.contentView.mas_centerY).offset(-NNHMargin_5);
        make.size.mas_equalTo(CGSizeMake(NNHMargin_15, NNHMargin_15));
    }];
    
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.statusImageView.mas_right).offset(NNHMargin_5);
        make.centerY.equalTo(self.statusImageView);
    }];
    
    [self.contentView addSubview:self.countLabel];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-NNHMargin_15);
        make.centerY.equalTo(self.statusImageView);
    }];
    
    [self.contentView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_centerX).offset(NNHMargin_15);
        make.centerY.equalTo(self.statusImageView);
    }];
    
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.statusImageView);
        make.top.equalTo(self.contentView.mas_centerY).offset(NNHMargin_5);
    }];

    [self.contentView addSubview:self.setupPriceLabel];
    [self.setupPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.priceLabel);
        make.centerY.equalTo(self.timeLabel);
    }];

    [self.contentView addSubview:self.totalCountLabel];
    [self.totalCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.countLabel);
        make.centerY.equalTo(self.timeLabel);
    }];
}

- (void)setTradingEntrustModel:(NNTradingEntrustModel *)tradingEntrustModel
{
    _tradingEntrustModel = tradingEntrustModel;
    
    self.statusImageView.image = [tradingEntrustModel.type integerValue] == 1 ? ImageName(@"icon_trade_buy") : ImageName(@"icon_trade_sell");
    self.nameLabel.text = tradingEntrustModel.coin_type;
    self.timeLabel.text = [NSString dateStringWithTimeStamp:tradingEntrustModel.addtime];
    self.countLabel.text = tradingEntrustModel.complete_amount;
    self.totalCountLabel.text = tradingEntrustModel.amount;
    self.priceLabel.text = tradingEntrustModel.average_price;
    self.setupPriceLabel.text = tradingEntrustModel.price;
    
}

#pragma mark - Lazy Loads

- (UIImageView *)statusImageView
{
    if (_statusImageView == nil) {
        _statusImageView = [[UIImageView alloc] init];
    }
    return _statusImageView;
}

- (UILabel *)nameLabel
{
    if (_nameLabel == nil) {
        _nameLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorThemeBlack] font:[UIConfigManager fontThemeTextMain]];
    }
    return _nameLabel;
}

- (UILabel *)timeLabel
{
    if (_timeLabel == nil) {
        _timeLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorThemeDarkGray] font:[UIConfigManager fontThemeTextTip]];
    }
    return _timeLabel;
}

- (UILabel *)countLabel
{
    if (_countLabel == nil) {
        _countLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorThemeBlack] font:[UIConfigManager fontThemeTextMain]];
    }
    return _countLabel;
}

- (UILabel *)totalCountLabel
{
    if (_totalCountLabel == nil) {
        _totalCountLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorThemeDarkGray] font:[UIConfigManager fontThemeTextMain]];
    }
    return _totalCountLabel;
}

- (UILabel *)priceLabel
{
    if (_priceLabel == nil) {
        _priceLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorThemeBlack] font:[UIConfigManager fontThemeTextMain]];
    }
    return _priceLabel;
}

- (UILabel *)setupPriceLabel
{
    if (_setupPriceLabel == nil) {
        _setupPriceLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorThemeDarkGray] font:[UIConfigManager fontThemeTextMain]];
    }
    return _setupPriceLabel;
}



@end
