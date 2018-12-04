 //
//  NNLegalTenderTradeOrderDetailViewController.m
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/25.
//  Copyright © 2018 超级钱包. All rights reserved.
//

#import "NNLegalTenderTradeOrderDetailViewController.h"
#import "UIButton+NNImagePosition.h"
#import "NNHAlertTool.h"
#import "NNAPILegalTenderTool.h"
#import "NNLegalTenderTradeOrderInfoView.h"
#import "NNLegalTenderTradeOrderPaymentMessageView.h"
#import "NNLegalTenderTradeOrderSelectedPaymentTypeView.h"
#import "NNLegalTenderTradeOrderEnterPasswordView.h"
#import "NNLegalTenderTradeOrderDetailHelper.h"
#import "NNLegalTenderTradeOrderOperationView.h"
#import "NNLegalTenderTradeOrderReasonView.h"

@interface NNLegalTenderTradeOrderDetailViewController ()
/** 订单id */
@property (nonatomic, copy) NSString *orderID;
/** scrollView */
@property (nonatomic, weak) UIScrollView *scrollView;
/** 订单信息 */
@property (nonatomic, strong) NNLegalTenderTradeOrderInfoView *infoView;
/** 选择付款方式 */
@property (nonatomic, strong) NNLegalTenderTradeOrderSelectedPaymentTypeView *paymentTypeView;
/** 选中的支付方式 */
@property (nonatomic, strong) NNLegalTenderTradeOrderDetailPaymentModel *selectedPayment;
/** 付款信息 */
@property (nonatomic, strong) NNLegalTenderTradeOrderPaymentMessageView *paymentMessageView;
/** 资金密码 */
@property (nonatomic, strong) NNLegalTenderTradeOrderEnterPasswordView *passwordView;
/** 违规原因view */
@property (nonatomic, strong) NNLegalTenderTradeOrderReasonView *reasonView;
/** 订单模型 */
@property (nonatomic, strong) NNLegalTenderTradeOrderDetailModel *orderModel;
/** 操作帮助类 */
@property (nonatomic, strong) NNLegalTenderTradeOrderDetailHelper *orderHelper;
/** 底部操作view */
@property (nonatomic, strong) NNLegalTenderTradeOrderOperationView *operationView;
/** 显示上传凭证 */
@property (nonatomic, strong) UIImageView *scanImageView;
/** 导航栏右侧操作按钮 */
@property (nonatomic, strong) UIButton *rightItemButton;
@end

@implementation NNLegalTenderTradeOrderDetailViewController

#pragma mark -
#pragma mark ---------Life Cycle

- (void)dealloc
{

}

- (instancetype)initWithOrderID:(NSString *)orderID
{
    if (self = [super init]) {
        _orderID = orderID;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIConfigManager colorThemeColorForVCBackground];
    UIImage *backImage = [[UIImage imageNamed:@"ic_nav_back"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backImage style:UIBarButtonItemStyleDone target:self action:@selector(leftItemClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightItemButton];
    [self setupChildView];
    
    [self requestOrderDetailData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.operationView cancleCountDown];
}

- (void)setupChildView
{
    [self.view addSubview:self.operationView];
    [self.operationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(NNHNormalViewH));
        make.bottom.equalTo(self.view).offset(-(NNHBottomSafeHeight) - NNHMargin_20);
    }];
    
    UIScrollView *contentView = [[UIScrollView alloc] init];
    [self.view addSubview:contentView];
    self.scrollView = contentView;
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [contentView addSubview:self.infoView];
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(NNHMargin_10);
        make.left.equalTo(contentView);
        make.width.equalTo(@(SCREEN_WIDTH));
    }];
    
    [contentView addSubview:self.paymentTypeView];
    [self.paymentTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infoView.mas_bottom).offset(NNHMargin_10);
        make.left.equalTo(contentView);
        make.width.equalTo(@(SCREEN_WIDTH));
    }];
    
    [contentView addSubview:self.paymentMessageView];
    [self.paymentMessageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infoView.mas_bottom).offset(NNHMargin_10);
        make.left.equalTo(contentView);
        make.width.equalTo(@(SCREEN_WIDTH));
    }];
    
    [contentView addSubview:self.passwordView];
    [self.passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.top.equalTo(self.paymentMessageView.mas_bottom).offset(NNHMargin_10);
        make.height.equalTo(@(NNHNormalViewH));
        make.width.equalTo(@(SCREEN_WIDTH));
    }];
}

#pragma mark - Network Methods

- (void)requestOrderDetailData
{
    NNHWeakSelf(self)
    NNAPILegalTenderTool *tradeTool = [[NNAPILegalTenderTool alloc] initWithMatchOrderDetailWithOrderID:self.orderID];
    [tradeTool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
        [weakself handleOrderDetailData:responseDic];
    } failBlock:^(NNHRequestError *error) {
        
    } isCached:NO];
}

- (void)handleOrderDetailData:(NSDictionary *)responseDic
{
    self.orderModel = [NNLegalTenderTradeOrderDetailModel mj_objectWithKeyValues:responseDic[@"data"]];
    
    if (self.selectedPayment) {
        self.orderModel.selectedPayment = self.selectedPayment;
    }
    
    self.orderHelper.orderModel = self.orderModel;
    
    self.infoView.orderModel = self.orderModel;
    self.paymentMessageView.orderModel = self.orderModel;
    self.paymentTypeView.orderModel = self.orderModel;
    self.operationView.orderModel = self.orderModel;
    
    self.passwordView.hidden = YES;
    self.reasonView.hidden = YES;
    // 订单状态说明 0 待交易（刚发布）,1 已买入未付款,2 已付款未确认,3 已确认付款（完结）,5 已撤销 6 买家取消 7买家违规 8卖家违规
    
    if ([self.orderModel.type isEqualToString:@"1"]) {
        self.navigationItem.title = [NSString stringWithFormat:@"购买%@",self.orderModel.coinname];
        // 买家
        if ([self.orderModel.status isEqualToString:@"1"]) {
            [self buyerShouldPayOrderLayout];
        }else if ([self.orderModel.status isEqualToString:@"2"]) {
            [self buyerHadPaymentOrderLayout];
        }else if ([self.orderModel.status isEqualToString:@"3"]) {
            [self buyerFinishOrderLayout];
        }else if ([self.orderModel.status isEqualToString:@"6"]) {
            [self buyerCancleOrderLayout];
        }else if ([self.orderModel.status isEqualToString:@"7"]) {
            [self buyerAbnormalOrderLayout];
        }else if ([self.orderModel.status isEqualToString:@"8"]) {
            [self sellerAbnormalOrderLayout];
        }else {
            [self buyerCancleOrderLayout];
        }
    }else {
        self.navigationItem.title = [NSString stringWithFormat:@"出售%@",self.orderModel.coinname];
        // 卖家
        if ([self.orderModel.status isEqualToString:@"1"]) {
            [self sellerStartOrderLayout];
        }else if ([self.orderModel.status isEqualToString:@"2"]) {
            [self sellerShouldConfirmReceiveMoneyLayout];
        }else if ([self.orderModel.status isEqualToString:@"3"]) {
            [self sellererFinishOrderLayout];
        }else if ([self.orderModel.status isEqualToString:@"6"]) {
            [self buyerCancleOrderLayout];
        }else if ([self.orderModel.status isEqualToString:@"7"]) {
            [self buyerAbnormalOrderLayout];
        }else if ([self.orderModel.status isEqualToString:@"8"]) {
            [self sellerAbnormalOrderLayout];
        }else {
            [self buyerCancleOrderLayout];
        }
    }
    
    [self.rightItemButton setTitle:self.orderModel.rightItemTitle forState:UIControlStateNormal];
    self.rightItemButton.hidden = self.orderModel.rightItemTitle.length == 0;
}

#pragma mark - 更新布局

/** 买家买入 未付款  */
- (void)buyerShouldPayOrderLayout
{
    self.infoView.hidden = self.paymentTypeView.hidden  = self.operationView.hidden = NO;
    self.paymentMessageView.hidden = YES;
    
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.operationView.mas_top).offset(-NNHMargin_10);
    }];
    
    [self.paymentTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infoView.mas_bottom).offset(NNHMargin_10);
        make.left.equalTo(self.scrollView);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.bottom.equalTo(self.scrollView);
    }];
}

/** 买家已付款 等待卖家确认收款 */
- (void)buyerHadPaymentOrderLayout
{
    self.infoView.hidden = self.paymentMessageView.hidden = NO;
    self.paymentTypeView.hidden = self.operationView.hidden = YES;
    
    [self.paymentMessageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infoView.mas_bottom).offset(NNHMargin_10);
        make.left.equalTo(self.scrollView);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.bottom.equalTo(self.scrollView);
    }];
}

/** 买家 取消订单 */
- (void)buyerCancleOrderLayout
{
    [self sellerStartOrderLayout];
}

/** 买家 订单正常完结 */
- (void)buyerFinishOrderLayout
{
    [self buyerHadPaymentOrderLayout];
}

/** 买家 违规 订单已完结 */
- (void)buyerAbnormalOrderLayout
{
    self.infoView.hidden = NO;
    self.paymentTypeView.hidden = self.operationView.hidden = self.paymentMessageView.hidden = YES;

    self.reasonView.hidden = NO;
    [self.scrollView addSubview:self.reasonView];
    [self.reasonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
        make.top.equalTo(self.infoView.mas_bottom).offset(NNHMargin_10);
        make.height.equalTo(@(NNHNormalViewH));
        make.width.equalTo(@(SCREEN_WIDTH));
        make.bottom.equalTo(self.scrollView);
    }];
    
    self.reasonView.message = self.orderModel.reason;
}

/** 卖家 等待买家付款 */
- (void)sellerStartOrderLayout
{
    self.infoView.hidden = NO;
    self.paymentTypeView.hidden = self.paymentMessageView.hidden = self.operationView.hidden = YES;
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

/** 买家已付款 等待卖家确认收款 */
- (void)sellerShouldConfirmReceiveMoneyLayout
{
    self.infoView.hidden = self.paymentMessageView.hidden = self.operationView.hidden = NO;
    self.paymentTypeView.hidden = YES;
    self.passwordView.hidden = NO;
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.operationView.mas_top).offset(-NNHMargin_10);
    }];
    
    [self.paymentMessageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infoView.mas_bottom).offset(NNHMargin_10);
        make.left.equalTo(self.scrollView);
        make.width.equalTo(@(SCREEN_WIDTH));
    }];
    
    [self.passwordView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
        make.top.equalTo(self.paymentMessageView.mas_bottom).offset(NNHMargin_10);
        make.height.equalTo(@(NNHNormalViewH));
        make.width.equalTo(@(SCREEN_WIDTH));
        make.bottom.equalTo(self.scrollView);
    }];
}

/** 卖家 订单已正常完结 */
- (void)sellererFinishOrderLayout
{
    [self buyerHadPaymentOrderLayout];
}

/** 卖家 订单已完结 */
- (void)sellerAbnormalOrderLayout
{
    self.infoView.hidden = self.paymentMessageView.hidden = NO;
    self.paymentTypeView.hidden = self.operationView.hidden = YES;
    [self.paymentMessageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infoView.mas_bottom).offset(NNHMargin_10);
        make.left.equalTo(self.scrollView);
        make.width.equalTo(@(SCREEN_WIDTH));
    }];
    
    self.reasonView.hidden = NO;
    [self.scrollView addSubview:self.reasonView];
    [self.reasonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
        make.top.equalTo(self.paymentMessageView.mas_bottom).offset(NNHMargin_10);
        make.height.equalTo(@(NNHNormalViewH));
        make.width.equalTo(@(SCREEN_WIDTH));
        make.bottom.equalTo(self.scrollView);
    }];
    
    self.reasonView.message = self.orderModel.reason;
}

#pragma mark - UserAction

- (void)leftItemClick
{
    if (self.fromActionVC) {
        UIViewController *VC = self.navigationController.childViewControllers[self.navigationController.childViewControllers.count - 3];
        [self.navigationController popToViewController:VC animated:YES];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)rightItemAction
{
    [self.orderHelper rightItemAction];
}

#pragma mark -
#pragma mark ---------Getters & Setters

- (NNLegalTenderTradeOrderInfoView *)infoView
{
    if (_infoView == nil) {
        _infoView = [[NNLegalTenderTradeOrderInfoView alloc] init];
        NNHWeakSelf(self)
        _infoView.contactActionBlock = ^{
            [weakself.orderHelper contactTheCuonsumer];
        };
    }
    return _infoView;
}

- (NNLegalTenderTradeOrderSelectedPaymentTypeView *)paymentTypeView
{
    if (_paymentTypeView == nil) {
        _paymentTypeView = [[NNLegalTenderTradeOrderSelectedPaymentTypeView alloc] init];
        _paymentTypeView.hidden = YES;
        NNHWeakSelf(self)
        _paymentTypeView.uploadCertificateBlock = ^{
            [weakself.orderHelper uploadOrderCertificateWithImageView:weakself.scanImageView];
        };
        _paymentTypeView.scanCertificateBlock = ^{
            [weakself.orderHelper scanOrderCertificateWithImageView:weakself.scanImageView];
        };
        _paymentTypeView.scanPaymentCodePictureBlock = ^{
            [weakself.orderHelper scanPictureWithUrl:weakself.orderModel.selectedPayment.img fromImageView:weakself.scanImageView];
        };
        _paymentTypeView.changedPaymentTypeBlock = ^(NNLegalTenderTradeOrderDetailPaymentModel * _Nonnull selectedPaymentModel) {
            weakself.selectedPayment = selectedPaymentModel;
        };
    }
    return _paymentTypeView;
}

- (NNLegalTenderTradeOrderPaymentMessageView *)paymentMessageView
{
    if (_paymentMessageView == nil) {
        _paymentMessageView = [[NNLegalTenderTradeOrderPaymentMessageView alloc] init];
        _paymentMessageView.hidden = YES;
        NNHWeakSelf(self)
        _paymentMessageView.proofActionBlock = ^{
            [weakself.orderHelper scanOrderCertificateWithImageView:weakself.scanImageView];
        };
    }
    return _paymentMessageView;
}

- (NNLegalTenderTradeOrderEnterPasswordView *)passwordView
{
    if (_passwordView == nil) {
        _passwordView = [[NNLegalTenderTradeOrderEnterPasswordView alloc] init];
        _passwordView.hidden = YES;
        NNHWeakSelf(self)
        _passwordView.passwordActionBlock = ^(NSString * _Nonnull password) {
            weakself.orderModel.password = password;
        };
    }
    return _passwordView;
}

- (NNLegalTenderTradeOrderReasonView *)reasonView
{
    if (_reasonView == nil) {
        _reasonView = [[NNLegalTenderTradeOrderReasonView alloc] init];
    }
    return _reasonView;
}

- (NNLegalTenderTradeOrderOperationView *)operationView
{
    if (_operationView == nil) {
        _operationView = [[NNLegalTenderTradeOrderOperationView alloc] init];
        _operationView.hidden = YES;
        NNHWeakSelf(self)
        _operationView.orderOperationBlock = ^{
            [weakself.orderHelper operationViewAction];
        };
        _operationView.endCountdownBlock = ^{
            [weakself requestOrderDetailData];
        };
    }
    return _operationView;
}

- (NNLegalTenderTradeOrderDetailHelper *)orderHelper
{
    if (_orderHelper == nil) {
        _orderHelper = [[NNLegalTenderTradeOrderDetailHelper alloc] init];
        _orderHelper.currentViewController = self;
        NNHWeakSelf(self)
        _orderHelper.reloadDataBlock = ^{
            [weakself requestOrderDetailData];
        };
    }
    return _orderHelper;
}

- (UIImageView *)scanImageView
{
    if (_scanImageView == nil) {
        _scanImageView = [[UIImageView alloc] init];
        [self.view addSubview:_scanImageView];
        [_scanImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(0, 0));
        }];
    }
    return _scanImageView;
}

- (UIButton *)rightItemButton
{
    if (_rightItemButton == nil) {
        _rightItemButton = [UIButton NNHBtnTitle:@"" titileFont:[UIConfigManager fontThemeTextMain] backGround:[UIConfigManager colorThemeWhite] titleColor:[UIConfigManager colorThemeDarkGray]];
        _rightItemButton.adjustsImageWhenHighlighted = NO;
        [_rightItemButton addTarget:self action:@selector(rightItemAction) forControlEvents:UIControlEventTouchUpInside];
        _rightItemButton.frame = CGRectMake(0, 0, 60, NNHNormalViewH);
    }
    return _rightItemButton;
}


@end

