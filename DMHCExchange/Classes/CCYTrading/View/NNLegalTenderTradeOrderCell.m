//
//  NNCCYTradingOrderCell.m
//  SuperWallet
//
//  Created by 牛牛 on 2018/9/13.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import "NNLegalTenderTradeOrderCell.h"
#import "NNLegalTenderTradeOrderListModel.h"

@interface NNLegalTenderTradeOrderCell ()
/** 订单类型 */
@property (nonatomic, strong) UIImageView *typeImageView;
/** 币种名称 */
@property (nonatomic, strong) UILabel *nameLabel;
/** 时间 */
@property (nonatomic, strong) UILabel *timeLabel;
/** 状态 */
@property (nonatomic, strong) UILabel *statusLabel;
/** 单价 */
@property (nonatomic, strong) UILabel *priceLabel;
/** 数量 */
@property (nonatomic, strong) UILabel *countLabel;
/** 总金额 */
@property (nonatomic, strong) UILabel *totalAmountLabel;
@end

@implementation NNLegalTenderTradeOrderCell

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
    [self.contentView addSubview:self.typeImageView];
    [self.typeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(NNHMargin_15);
        make.top.equalTo(self.contentView).offset(NNHMargin_15);
    }];
    
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.typeImageView.mas_right).offset(NNHMargin_10);
        make.centerY.equalTo(self.typeImageView);
    }];

    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).offset(NNHMargin_10);
        make.baseline.equalTo(self.nameLabel);
    }];

    [self.contentView addSubview:self.statusLabel];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-NNHMargin_15);
        make.baseline.equalTo(self.nameLabel);
    }];

    [self.contentView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(NNHMargin_15);
        make.bottom.equalTo(self.contentView).offset(-NNHMargin_10);
    }];

    [self.contentView addSubview:self.countLabel];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.priceLabel);
        make.centerX.equalTo(self.contentView.mas_centerX).offset(-NNHMargin_5);
    }];

    [self.contentView addSubview:self.totalAmountLabel];
    [self.totalAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-NNHMargin_15);
        make.centerY.equalTo(self.priceLabel);
    }];

    UILabel *priceLabel = [UILabel NNHWithTitle:@"CNY" titleColor:[UIConfigManager colorTextLightGray] font:[UIConfigManager fontThemeTextTip]];
    [self.contentView addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceLabel);
        make.bottom.equalTo(self.priceLabel.mas_top).offset(-NNHMargin_10);
    }];

    UILabel *countLabel = [UILabel NNHWithTitle:@"数量" titleColor:[UIConfigManager colorTextLightGray] font:[UIConfigManager fontThemeTextTip]];
    [self.contentView addSubview:countLabel];
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.countLabel);
        make.centerY.equalTo(priceLabel);
    }];

    UILabel *totalAmountLabel = [UILabel NNHWithTitle:@"总金额" titleColor:[UIConfigManager colorTextLightGray] font:[UIConfigManager fontThemeTextTip]];
    [self.contentView addSubview:totalAmountLabel];
    [totalAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.totalAmountLabel);
        make.centerY.equalTo(priceLabel);
    }];
}

- (void)setOrderListModel:(NNLegalTenderTradeOrderListModel *)orderListModel
{
    _orderListModel = orderListModel;
    
    if ([orderListModel.type isEqualToString:@"1"]) {
        self.typeImageView.image = [UIImage imageNamed:@"tag_buy"];
        
    }else {
        self.typeImageView.image = [UIImage imageNamed:@"tag_sale"];
    }
    
    self.nameLabel.text = orderListModel.coinname;
    self.timeLabel.text = orderListModel.buytime;
    self.priceLabel.text = orderListModel.price;
    self.countLabel.text = orderListModel.num;
    self.totalAmountLabel.text = orderListModel.mum;
    self.statusLabel.text = orderListModel.statusstr;
    
    if ([orderListModel.status isEqualToString:@"7"] || [orderListModel.status isEqualToString:@"8"]) {
        self.statusLabel.textColor = [UIConfigManager colorThemeRed];
    }else {
        self.statusLabel.textColor = [UIConfigManager colorThemeBlack];
    }
}

#pragma mark - Lazy Loads

- (UIImageView *)typeImageView
{
    if (_typeImageView == nil) {
        _typeImageView = [[UIImageView alloc] init];
        _typeImageView.image = [UIImage imageNamed:@"tag_buy"];
    }
    return _typeImageView;
}

- (UILabel *)nameLabel
{
    if (_nameLabel == nil) {
        _nameLabel = [UILabel NNHWithTitle:@"USDT" titleColor:[UIConfigManager colorThemeBlack] font:[UIFont boldSystemFontOfSize:15]];
    }
    return _nameLabel;
}

- (UILabel *)timeLabel
{
    if (_timeLabel == nil) {
        _timeLabel = [UILabel NNHWithTitle:@"10-16 20:50" titleColor:[UIConfigManager colorTextLightGray] font:[UIConfigManager fontThemeTextDefault]];
    }
    return _timeLabel;
}

- (UILabel *)statusLabel
{
    if (_statusLabel == nil) {
        _statusLabel = [UILabel NNHWithTitle:@"待成交" titleColor:[UIConfigManager colorTextLightGray] font:[UIConfigManager fontThemeTextDefault]];
    }
    return _statusLabel;
}

- (UILabel *)priceLabel
{
    if (_priceLabel == nil) {
        _priceLabel = [UILabel NNHWithTitle:@"6.88" titleColor:[UIConfigManager colorThemeBlack] font:[UIConfigManager fontThemeTextDefault]];
    }
    return _priceLabel;
}

- (UILabel *)countLabel
{
    if (_countLabel == nil) {
        _countLabel = [UILabel NNHWithTitle:@"100" titleColor:[UIConfigManager colorThemeBlack] font:[UIConfigManager fontThemeTextDefault]];
    }
    return _countLabel;
}

- (UILabel *)totalAmountLabel
{
    if (_totalAmountLabel == nil) {
        _totalAmountLabel = [UILabel NNHWithTitle:@"688" titleColor:[UIConfigManager colorThemeBlack] font:[UIConfigManager fontThemeTextDefault]];
    }
    return _totalAmountLabel;
}

@end
