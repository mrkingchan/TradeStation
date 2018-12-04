//
//  NNHCurrentEntrustTableViewCell.m
//  SuperWallet
//
//  Created by 来旭磊 on 2018/3/20.
//  Copyright © 2018年 超级钱包. All rights reserved.
//

#import "NNHCurrentEntrustTableViewCell.h"
#import "NNTradingEntrustModel.h"

@interface NNHCurrentEntrustTableViewCell ()

/** 标题label */
@property (nonatomic, strong) UILabel *messageLabel;
/** 交易状态 */
@property (nonatomic, strong) UILabel *statusLabel;

/** <#注释#> */
@property (nonatomic, strong) UIView *bottomView;
/** 名称 */
@property (nonatomic, strong) UILabel *nameLabel;
/** 数量 */
@property (nonatomic, strong) UILabel *countLabel;
/** 价格 */
@property (nonatomic, strong) UILabel *priceLabel;
/** 时间 */
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation NNHCurrentEntrustTableViewCell

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
    [self.contentView addSubview:self.messageLabel];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(NNHMargin_15);
        make.top.equalTo(self.contentView);
        make.height.equalTo(@(40));
    }];
    
    [self.contentView addSubview:self.statusLabel];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-NNHMargin_15);
        make.centerY.equalTo(self.messageLabel);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIConfigManager colorThemeColorForVCBackground];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@(NNHLineH));
        make.top.equalTo(self.messageLabel.mas_bottom);
    }];
    
    [self.contentView addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.top.equalTo(self.messageLabel.mas_bottom).offset(NNHLineH);
    }];
    
    [self.bottomView addSubview:self.timeLabel];
    [self.bottomView addSubview:self.nameLabel];
    [self.bottomView addSubview:self.countLabel];
    [self.bottomView addSubview:self.priceLabel];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).offset(NNHMargin_15);
        make.centerY.equalTo(self.bottomView);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.countLabel);
        make.bottom.equalTo(self.countLabel.mas_top).offset(-NNHMargin_10);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.countLabel);
        make.top.equalTo(self.countLabel.mas_bottom).offset(NNHMargin_10);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomView).offset(-NNHMargin_15);
        make.centerY.equalTo(self.nameLabel);
    }];
    
    UIButton *cancleButton = [self buttonWithTitle:@"撤销" action:@selector(cancleButtonAction)];
    [self.bottomView addSubview:cancleButton];
    [cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(72, 28));
        make.right.equalTo(self.bottomView).offset(-NNHMargin_15);
        make.top.equalTo(self.bottomView.mas_centerY);
    }];
}

- (void)setTradingEntrustModel:(NNTradingEntrustModel *)tradingEntrustModel
{
    _tradingEntrustModel = tradingEntrustModel;
    
    self.messageLabel.text = [tradingEntrustModel.type integerValue] == 1 ? @"限价买入" : @"限价卖出";
    self.statusLabel.text = tradingEntrustModel.state;
    self.nameLabel.text = tradingEntrustModel.coin_type;
    self.timeLabel.text = [NSString dateStringWithTimeStamp:tradingEntrustModel.addtime] ;
    self.countLabel.text = [NSString stringWithFormat:@"数量 %@ / %@",tradingEntrustModel.complete_amount,tradingEntrustModel.amount];
    self.priceLabel.text = [NSString stringWithFormat:@"价格 %@",tradingEntrustModel.price];
    
    if ([tradingEntrustModel.type isEqualToString:@"1"]) {
        self.messageLabel.textColor = [UIConfigManager colorTabBarTitleHeight];
    }else {
        self.messageLabel.textColor = [UIColor akext_colorWithHex:@"#009759"];
    }
}

- (void)cancleButtonAction
{
    if (self.cancleBlock) {
        self.cancleBlock();
    }
}

#pragma mark - Lazy Loads

- (UILabel *)messageLabel
{
    if (_messageLabel == nil) {
        _messageLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorThemeBlack] font:[UIConfigManager fontThemeTextMain]];
    }
    return _messageLabel;
}

- (UILabel *)statusLabel
{
    if (_statusLabel == nil) {
        _statusLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorThemeDarkGray] font:[UIConfigManager fontThemeTextMain]];
    }
    return _statusLabel;
}

- (UIView *)bottomView
{
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc] init];
    }
    return _bottomView;
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
        _timeLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorTextLightGray] font:[UIConfigManager fontThemeTextTip]];
    }
    return _timeLabel;
}

- (UILabel *)priceLabel
{
    if (_priceLabel == nil) {
        _priceLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorThemeDarkGray] font:[UIConfigManager fontThemeTextMain]];
    }
    return _priceLabel;
}

- (UILabel *)countLabel
{
    if (_countLabel == nil) {
        _countLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorThemeDarkGray] font:[UIConfigManager fontThemeTextMain]];
    }
    return _countLabel;
}

- (UIButton *)buttonWithTitle:(NSString *)title action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIConfigManager colorThemeRed] forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIConfigManager fontThemeTextTip]];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 2.f;
    btn.layer.borderColor = [UIColor akext_colorWithHex:@"#da251c"].CGColor;
    btn.layer.borderWidth = 0.5;
    return btn;
}



@end
