//
//  NNLegalTenderTradeOrderPaymentMessageView.m
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/29.
//  Copyright © 2018 超级钱包. All rights reserved.
//

#import "NNLegalTenderTradeOrderPaymentMessageView.h"
#import "NNLegalTenderTradeOrderItemView.h"
#import "NNLegalTenderTradeOrderDetailModel.h"

@interface NNLegalTenderTradeOrderPaymentMessageView ()

/** 头部view */
@property (nonatomic, strong) UIView *titleView;
/** 付款信息 */
@property (nonatomic, strong) UILabel *orderNumLabel;
/** 支付方式 */
@property (nonatomic, strong) NNLegalTenderTradeOrderItemView *payTypeItemView;
/** 付款金额 */
@property (nonatomic, strong) NNLegalTenderTradeOrderItemView *amountItemView;
/** 付款时间 */
@property (nonatomic, strong) NNLegalTenderTradeOrderItemView *payTimeItemView;
/** 放币时间 */
@property (nonatomic, strong) NNLegalTenderTradeOrderItemView *sendTimeItemView;
/** 付款凭证 */
@property (nonatomic, strong) NNLegalTenderTradeOrderItemView *proofItemView;
@end

@implementation NNLegalTenderTradeOrderPaymentMessageView

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
    [self addSubview:self.titleView];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@(NNHNormalViewH));
    }];

    [self addSubview:self.payTypeItemView];
    [self.payTypeItemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.top.equalTo(self.titleView.mas_bottom).offset(NNHMargin_10);
        make.height.equalTo(@36);
    }];
    
    [self addSubview:self.amountItemView];
    [self.amountItemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.top.equalTo(self.payTypeItemView.mas_bottom);
        make.height.mas_equalTo(self.payTypeItemView);
    }];
    
    [self addSubview:self.payTimeItemView];
    [self.payTimeItemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.top.equalTo(self.amountItemView.mas_bottom);
        make.height.mas_equalTo(self.payTypeItemView);
    }];
    
    [self addSubview:self.sendTimeItemView];
    [self.sendTimeItemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.top.equalTo(self.payTimeItemView.mas_bottom);
        make.height.mas_equalTo(self.payTypeItemView);
    }];
    
    [self addSubview:self.proofItemView];
    [self.proofItemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.top.equalTo(self.payTimeItemView.mas_bottom);
        make.height.mas_equalTo(self.payTypeItemView);
        make.bottom.equalTo(self).offset(-NNHMargin_10);
    }];
}

- (void)proofButtonAction
{
    if (self.proofActionBlock) {
        self.proofActionBlock();
    }
}

- (void)setOrderModel:(NNLegalTenderTradeOrderDetailModel *)orderModel
{
    _orderModel = orderModel;
    self.payTypeItemView.message = orderModel.paytypestr;
    self.amountItemView.message = orderModel.amount;
    self.payTimeItemView.message = orderModel.paytime;
    self.sendTimeItemView.message = orderModel.endtime;
//    订单状态说明 0 待交易（刚发布）,1 已买入未付款,2 已付款未确认,3 已确认付款（完结）,5 已撤销 6 买家取消 7买家违规 8卖家违规
    
    if (orderModel.endtime.length) {
        self.sendTimeItemView.hidden = NO;
        [self.proofItemView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.width.equalTo(@(SCREEN_WIDTH));
            make.top.equalTo(self.sendTimeItemView.mas_bottom);
            make.height.mas_equalTo(self.payTypeItemView);
            make.bottom.equalTo(self).offset(-NNHMargin_10);
        }];
    }else {
        // 没有放币
        self.sendTimeItemView.hidden = YES;
        [self.proofItemView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.width.equalTo(@(SCREEN_WIDTH));
            make.top.equalTo(self.payTimeItemView.mas_bottom);
            make.height.mas_equalTo(self.payTypeItemView);
            make.bottom.equalTo(self).offset(-NNHMargin_10);
        }];
    }
}

#pragma mark - Lazy Loads

- (UIView *)titleView
{
    if (_titleView == nil) {
        _titleView = [[UIView alloc] init];
        
        UILabel *titleLabel = [UILabel NNHWithTitle:@"付款信息" titleColor:[UIConfigManager colorThemeBlack] font:[UIConfigManager fontThemeTextMain]];
        [_titleView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleView).offset(NNHMargin_15);
            make.centerY.equalTo(_titleView);
        }];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIConfigManager colorThemeColorForVCBackground];
        [_titleView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleView);
            make.width.equalTo(@(SCREEN_WIDTH));
            make.bottom.equalTo(_titleView);
            make.height.equalTo(@(NNHLineH));
        }];
    }
    return _titleView;
}

- (UILabel *)orderNumLabel
{
    if (_orderNumLabel == nil) {
        _orderNumLabel = [UILabel NNHWithTitle:@"付款信息" titleColor:[UIConfigManager colorThemeBlack] font:[UIConfigManager fontThemeTextMain]];
    }
    return _orderNumLabel;
}

- (NNLegalTenderTradeOrderItemView *)payTypeItemView
{
    if (_payTypeItemView == nil) {
        _payTypeItemView = [[NNLegalTenderTradeOrderItemView alloc] init];
        _payTypeItemView.title = @"支付方式";
        _payTypeItemView.message = @"";
    }
    return _payTypeItemView;
}

- (NNLegalTenderTradeOrderItemView *)amountItemView
{
    if (_amountItemView == nil) {
        _amountItemView = [[NNLegalTenderTradeOrderItemView alloc] init];
        _amountItemView.title = @"付款金额（CNY）";
        _amountItemView.message = @"";
    }
    return _amountItemView;
}

- (NNLegalTenderTradeOrderItemView *)payTimeItemView
{
    if (_payTimeItemView == nil) {
        _payTimeItemView = [[NNLegalTenderTradeOrderItemView alloc] init];
        _payTimeItemView.title = @"付款时间";
        _payTimeItemView.message = @"";
    }
    return _payTimeItemView;
}

- (NNLegalTenderTradeOrderItemView *)sendTimeItemView
{
    if (_sendTimeItemView == nil) {
        _sendTimeItemView = [[NNLegalTenderTradeOrderItemView alloc] init];
        _sendTimeItemView.title = @"放币时间";
        _sendTimeItemView.message = @"";
    }
    return _sendTimeItemView;
}

- (NNLegalTenderTradeOrderItemView *)proofItemView
{
    if (_proofItemView == nil) {
        _proofItemView = [[NNLegalTenderTradeOrderItemView alloc] init];
        _proofItemView.title = @"付款凭证";
        _proofItemView.message = @"";
        
        UIButton *proofButton = [UIButton NNHBtnTitle:@"查看凭证" titileFont:[UIConfigManager fontThemeTextDefault] backGround:[UIConfigManager colorThemeWhite] titleColor:[UIConfigManager colorThemeRed]];
        [proofButton addTarget:self action:@selector(proofButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_proofItemView addSubview:proofButton];
        [proofButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_proofItemView).offset(115);
            make.width.equalTo(@80);
            make.top.bottom.equalTo(_proofItemView);
        }];
    }
    return _proofItemView;
}


@end


