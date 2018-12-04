//
//  NNLegalTenderTradeActionTitleView.m
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/26.
//  Copyright © 2018 超级钱包. All rights reserved.
//

#import "NNLegalTenderTradeActionTitleView.h"
#import "NNLegalTenderTradeOrderActionModel.h"

@interface NNLegalTenderTradeActionTitleView ()
/** 状态 */
@property (nonatomic, strong) UIView  *statusView;
/** 名称 */
@property (nonatomic, strong) UILabel *nameLabel;
/** 认证标识 */
@property (nonatomic, strong) UIImageView *authImageView;
/** 成交订单数量 */
@property (nonatomic, strong) UILabel *completeCountLabel;
/** 成交完成率 */
@property (nonatomic, copy) UILabel *completeRatioLabel;
/** 订单币种可成交数量 */
@property (nonatomic, strong) UILabel *coinCountLabel;
/** 备注view */
@property (nonatomic, strong) UIView *remarkView;
/** 备注 */
@property (nonatomic, strong) UILabel *remarkLabel;
/** 支付方式 */
@property (nonatomic, strong) NSMutableArray *iconArray;


@end

@implementation NNLegalTenderTradeActionTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIConfigManager colorThemeWhite];
        [self setupChildView];
    }
    return self;
}

- (void)setupChildView
{
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(NNHMargin_15);
        make.top.equalTo(self).offset(NNHMargin_20);
    }];
    
    [self addSubview:self.authImageView];
    [self.authImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel);
        make.left.equalTo(self.nameLabel.mas_right).offset(NNHMargin_5);
    }];
    
    [self addSubview:self.statusView];
    [self.statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.centerY.equalTo(self.nameLabel);
        make.height.equalTo(@20);
        make.width.equalTo(@5);
    }];
    
    [self addSubview:self.completeCountLabel];
    [self.completeCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(NNHMargin_15);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(NNHMargin_15);
        make.bottom.equalTo(self).offset(-NNHMargin_15);
    }];
    
    [self addSubview:self.completeRatioLabel];
    [self.completeRatioLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self.completeCountLabel);
    }];
    
    [self addSubview:self.coinCountLabel];
    [self.coinCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-NNHMargin_15);
        make.centerY.equalTo(self.completeCountLabel);
    }];
    
    UIImageView *rightIcon = [[UIImageView alloc] init];
    [self addSubview:rightIcon];
    [self.iconArray addObject:rightIcon];
    
    UIImageView *middleIcon = [[UIImageView alloc] init];
    [self addSubview:middleIcon];
    [self.iconArray addObject:middleIcon];
    
    UIImageView *leftIcon = [[UIImageView alloc] init];
    [self addSubview:leftIcon];
    [self.iconArray addObject:leftIcon];

    [rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(NNHMargin_20, NNHMargin_20));
        make.right.equalTo(self).offset(-NNHMargin_15);
        make.centerY.equalTo(self.nameLabel);
    }];

    [middleIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(NNHMargin_20, NNHMargin_20));
        make.centerY.equalTo(rightIcon);
        make.right.equalTo(rightIcon.mas_left).offset(-5);
    }];

    [leftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(NNHMargin_20, NNHMargin_20));
        make.right.equalTo(middleIcon.mas_left).offset(-NNHMargin_5);
        make.centerY.equalTo(rightIcon);
    }];
}

- (void)setOrderModel:(NNLegalTenderTradeOrderActionModel *)orderModel
{
    _orderModel = orderModel;
    
    self.nameLabel.text = orderModel.realname;
    
    if ([orderModel.type isEqualToString:@"1"]) {
        // 买单
        self.statusView.backgroundColor = [UIColor akext_colorWithHex:@"#3fbe72"];
    }else {
        self.statusView.backgroundColor = [UIConfigManager colorThemeRed];
    }
    
    self.completeCountLabel.text = [NSString stringWithFormat:@"已成交 %@",orderModel.dealnum];
    self.completeRatioLabel.text = [NSString stringWithFormat:@"成交率 %@",orderModel.deal];
    self.coinCountLabel.text = [NSString stringWithFormat:@"数量 %@",orderModel.num];
    
    
    for (UIImageView *imageView in self.iconArray) {
        imageView.hidden = YES;
    }
    
    for (int i = 0; i < orderModel.iconNameArray.count; i ++) {
        UIImageView *imageView = self.iconArray[i];
        imageView.image = [UIImage imageNamed:orderModel.iconNameArray[i]];
        imageView.hidden = NO;
    }
    
    if (orderModel.remarks.length) {
        
        [self.completeCountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(NNHMargin_15);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(NNHMargin_15);
        }];
        
        self.remarkLabel.text = orderModel.remarks;
        [self addSubview:self.remarkView];
        [self.remarkView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.width.equalTo(@(SCREEN_WIDTH));
            make.top.equalTo(self.completeCountLabel.mas_bottom).offset(NNHMargin_15);
            make.bottom.equalTo(self);
        }];
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
        _nameLabel = [UILabel NNHWithTitle:@"用户名称" titleColor:[UIColor akext_colorWithHex:@"#1a3b55"] font:[UIFont boldSystemFontOfSize:14]];
        _nameLabel.backgroundColor = [UIColor whiteColor];
    }
    return _nameLabel;
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

- (UILabel *)completeCountLabel
{
    if (_completeCountLabel == nil) {
        _completeCountLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorThemeDarkGray] font:[UIConfigManager fontThemeTextDefault]];
    }
    return _completeCountLabel;
}

- (UILabel *)completeRatioLabel
{
    if (_completeRatioLabel == nil) {
        _completeRatioLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorThemeDarkGray] font:[UIConfigManager fontThemeTextDefault]];
    }
    return _completeRatioLabel;
}

- (UILabel *)coinCountLabel
{
    if (_coinCountLabel== nil) {
        _coinCountLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorThemeDarkGray] font:[UIConfigManager fontThemeTextDefault]];
    }
    return _coinCountLabel;
}

- (UIView *)remarkView
{
    if (_remarkView == nil) {
        _remarkView = [[UIView alloc] init];
        _remarkView.backgroundColor = [UIConfigManager colorThemeWhite];
        
        UIView *lineView = [UIView lineView];
        [_remarkView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_remarkView).offset(NNHMargin_15);
            make.width.equalTo(@(SCREEN_WIDTH - 30));
            make.top.equalTo(_remarkView);
            make.height.equalTo(@(NNHLineH));
        }];
        
        UILabel *titleLabel = [UILabel NNHWithTitle:@"备注" titleColor:[UIConfigManager colorThemeBlack] font:[UIConfigManager fontThemeTextDefault]];
        [_remarkView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_remarkView).offset(NNHMargin_15);
            make.top.equalTo(_remarkView).offset(NNHMargin_15);
        }];
        
        [_remarkView addSubview:self.remarkLabel];
        [self.remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel.mas_right).offset(NNHMargin_15);
            make.top.equalTo(titleLabel);
            make.right.equalTo(_remarkView).offset(-NNHMargin_15);
            make.bottom.equalTo(_remarkView).offset(-NNHMargin_10);
        }];
    }
    return _remarkView;
}

- (UILabel *)remarkLabel
{
    if (_remarkLabel == nil) {
        _remarkLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorThemeBlack] font:[UIConfigManager fontThemeTextDefault]];
        _remarkLabel.numberOfLines = 0;
    }
    return _remarkLabel;
}
@end

