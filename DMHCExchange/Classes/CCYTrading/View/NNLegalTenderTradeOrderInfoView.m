//
//  NNLegalTenderTradeOrderInfoView.m
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/29.
//  Copyright © 2018 超级钱包. All rights reserved.
//

#import "NNLegalTenderTradeOrderInfoView.h"
#import "NNLegalTenderTradeOrderItemView.h"

@interface NNLegalTenderTradeOrderInfoView ()

/** 订单编号 */
@property (nonatomic, strong) UILabel *orderNumLabel;
/** 订单状态 */
@property (nonatomic, strong) UILabel *orderStatusLabel;
/** 实名认证信息 */
@property (nonatomic, strong) NNLegalTenderTradeOrderItemView *nameItemView;
/** 订单总额 */
@property (nonatomic, strong) NNLegalTenderTradeOrderItemView *amountItemView;
/** 数量 */
@property (nonatomic, strong) NNLegalTenderTradeOrderItemView *countItemView;
/** 单价 */
@property (nonatomic, strong) NNLegalTenderTradeOrderItemView *priceItemView;
/** time */
@property (nonatomic, strong) NNLegalTenderTradeOrderItemView *timeItemView;
@end

@implementation NNLegalTenderTradeOrderInfoView

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
    //订单编号
    [self addSubview:self.orderNumLabel];
    [self.orderNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(NNHMargin_15);
        make.top.equalTo(self);
        make.height.equalTo(@(NNHNormalViewH));
    }];

    [self addSubview:self.orderStatusLabel];
    [self.orderStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-NNHMargin_15);
        make.centerY.equalTo(self.orderNumLabel);
    }];

    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIConfigManager colorThemeColorForVCBackground];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.bottom.equalTo(self.orderNumLabel);
        make.height.equalTo(@(NNHLineH));
    }];
    
    [self addSubview:self.nameItemView];
    [self.nameItemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.top.equalTo(self.orderNumLabel.mas_bottom).offset(NNHMargin_10);
        make.height.equalTo(@36);
    }];
    
    [self addSubview:self.amountItemView];
    [self.amountItemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.top.equalTo(self.nameItemView.mas_bottom);
        make.height.mas_equalTo(self.nameItemView);
    }];
    
    [self addSubview:self.countItemView];
    [self.countItemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.top.equalTo(self.amountItemView.mas_bottom);
        make.height.mas_equalTo(self.nameItemView);
    }];
    
    [self addSubview:self.priceItemView];
    [self.priceItemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.top.equalTo(self.countItemView.mas_bottom);
        make.height.mas_equalTo(self.nameItemView);
    }];
    
    [self addSubview:self.timeItemView];
    [self.timeItemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.top.equalTo(self.priceItemView.mas_bottom);
        make.height.mas_equalTo(self.nameItemView);
        make.bottom.equalTo(self).offset(-NNHMargin_10);
    }];
}

- (void)setOrderModel:(NNLegalTenderTradeOrderDetailModel *)orderModel
{
    _orderModel = orderModel;
    self.orderNumLabel.text = [NSString stringWithFormat:@"订单编号 %@",orderModel.orderno];
    self.orderStatusLabel.text = orderModel.statusstr;
    self.nameItemView.message = orderModel.username;
    self.amountItemView.message = orderModel.amount;
    self.countItemView.title = [NSString stringWithFormat:@"数量（%@）",orderModel.coinname];
    self.countItemView.message = orderModel.num;
    self.priceItemView.message = orderModel.price;
    self.timeItemView.message = orderModel.buytime;
}

- (void)contactButtonAction
{
    if (self.contactActionBlock) {
        self.contactActionBlock();
    }
}

#pragma mark - Lazy Loads

- (UILabel *)orderNumLabel
{
    if (_orderNumLabel == nil) {
        _orderNumLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorThemeBlack] font:[UIConfigManager fontThemeTextMain]];
    }
    return _orderNumLabel;
}

- (UILabel *)orderStatusLabel
{
    if (_orderStatusLabel == nil) {
        _orderStatusLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorThemeBlack] font:[UIConfigManager fontThemeTextDefault]];
    }
    return _orderStatusLabel;
}

- (NNLegalTenderTradeOrderItemView *)nameItemView
{
    if (_nameItemView == nil) {
        _nameItemView = [[NNLegalTenderTradeOrderItemView alloc] init];
        _nameItemView.title = @"实名信息";
        _nameItemView.message = @"";
        
        UILabel *authLabel = [UILabel NNHWithTitle:@"实名认证" titleColor:[UIColor akext_colorWithHex:@"#8a662b"] font:[UIConfigManager fontThemeTextTip]];
        authLabel.backgroundColor = [UIColor akext_colorWithHex:@"#f0d3b0"];
        authLabel.layer.borderColor = [UIColor akext_colorWithHex:@"#c0985d"].CGColor;
        authLabel.layer.borderWidth = NNHLineH;
        authLabel.textAlignment = NSTextAlignmentCenter;
        [_nameItemView addSubview:authLabel];
        [authLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_nameItemView.messageLabel.mas_right).offset(NNHMargin_10);
            make.centerY.equalTo(_nameItemView);
            make.size.mas_equalTo(CGSizeMake(60, NNHMargin_20));
        }];
        
        UIButton *contactButton = [UIButton NNHBtnTitle:@"联系对方" titileFont:[UIConfigManager fontThemeTextDefault] backGround:[UIConfigManager colorThemeWhite] titleColor:[UIColor akext_colorWithHex:@"#4e66b2"]];
        [contactButton addTarget:self action:@selector(contactButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_nameItemView addSubview:contactButton];
        [contactButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_nameItemView);
            make.width.equalTo(@80);
            make.height.equalTo(@(NNHNormalViewH));
            make.centerY.equalTo(_nameItemView);
        }];
    }
    return _nameItemView;
}

- (NNLegalTenderTradeOrderItemView *)amountItemView
{
    if (_amountItemView == nil) {
        _amountItemView = [[NNLegalTenderTradeOrderItemView alloc] init];
        _amountItemView.title = @"订单金额（CNY）";
        _amountItemView.message = @"";
    }
    return _amountItemView;
}

- (NNLegalTenderTradeOrderItemView *)countItemView
{
    if (_countItemView == nil) {
        _countItemView = [[NNLegalTenderTradeOrderItemView alloc] init];
        _countItemView.title = @"数量";
        _countItemView.message = @"";
    }
    return _countItemView;
}

- (NNLegalTenderTradeOrderItemView *)priceItemView
{
    if (_priceItemView == nil) {
        _priceItemView = [[NNLegalTenderTradeOrderItemView alloc] init];
        _priceItemView.title = @"单价（CNY）";
        _priceItemView.message = @"";
    }
    return _priceItemView;
}

- (NNLegalTenderTradeOrderItemView *)timeItemView
{
    if (_timeItemView == nil) {
        _timeItemView = [[NNLegalTenderTradeOrderItemView alloc] init];
        _timeItemView.title = @"下单时间";
        _timeItemView.message = @"";
    }
    return _timeItemView;
}


@end


