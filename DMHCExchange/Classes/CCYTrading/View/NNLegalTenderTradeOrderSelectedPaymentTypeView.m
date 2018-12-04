//
//  NNLegalTenderTradeOrderSelectedPaymentTypeView.m
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/31.
//  Copyright © 2018 超级钱包. All rights reserved.
//

#import "NNLegalTenderTradeOrderSelectedPaymentTypeView.h"
#import "NNLegalTenderTradeOrderDetailModel.h"
#import "UIViewController+NNHExtension.h"
#import "NNHAlertTool.h"

@interface NNLegalTenderTradeOrderSelectedPaymentTypeView ()

/** 头部view */
@property (nonatomic, strong) UIView *titleView;
/** 付款账户类型 */
@property (nonatomic, strong) UILabel *accountTypeLabel;
/** 付款账户标题显示 银行名称 支行 及手机号、用户名等 */
@property (nonatomic, strong) UILabel *accountTitleLabel;
/** 银行卡 用户名称 */
@property (nonatomic, strong) UILabel *userNameLabel;
/** 银行卡名称 */
@property (nonatomic, strong) UILabel *cardNumLabel;
/** 上传凭证 */
@property (nonatomic, strong) UILabel *certificateLabel;
/** 上传凭证按钮 */
@property (nonatomic, strong) UIButton *certificateButton;
/** 查看凭证按钮 */
@property (nonatomic, strong) UIButton *scanButton;
/** 收款码按钮按钮 */
@property (nonatomic, strong) UIButton *codeButton;

@end

@implementation NNLegalTenderTradeOrderSelectedPaymentTypeView

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
    // 头部选择 支付方式
    [self addSubview:self.titleView];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@(NNHNormalViewH));
    }];
    
    [self addSubview:self.accountTypeLabel];
    [self addSubview:self.accountTitleLabel];
    [self addSubview:self.userNameLabel];
    [self addSubview:self.cardNumLabel];
    [self addSubview:self.certificateLabel];
    [self addSubview:self.codeButton];
    [self addSubview:self.certificateButton];
    [self addSubview:self.scanButton];
    
    [self.accountTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(NNHMargin_15);
        make.top.equalTo(self.titleView.mas_bottom).offset(NNHMargin_15);
    }];
    
    [self.accountTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(90);
        make.centerY.equalTo(self.accountTypeLabel);
    }];
}

- (void)setOrderModel:(NNLegalTenderTradeOrderDetailModel *)orderModel
{
    _orderModel = orderModel;
    if (self.orderModel.paymentArray.count) {
        if (self.orderModel.selectedPayment) {
            [self changePaymentTypeWithPaymentModel:self.orderModel.selectedPayment];
        }else {
            [self changePaymentTypeWithPaymentModel:orderModel.paymentArray.firstObject];
        }
        self.hidden = NO;
    }else {
        self.hidden = YES;
    }
}

/** 弹出支付方式选择框 */
- (void)selectedPaymentTypeAction
{
    UIViewController *controller = [UIViewController currentViewController];
   
    NSArray *titleArray = [self.orderModel.paymentArray valueForKeyPath:@"paymentName"];
    
    NNHWeakSelf(self)
    [[NNHAlertTool shareAlertTool] showActionSheet:controller title:nil message:nil acttionTitleArray:titleArray confirm:^(NSInteger index) {
        [weakself changePaymentTypeWithPaymentModel:weakself.orderModel.paymentArray[index]];
    } cancle:^{
        
    }];
}

/** 修改支付方式 */
- (void)changePaymentTypeWithPaymentModel:(NNLegalTenderTradeOrderDetailPaymentModel *)paymentModel
{
    self.orderModel.selectedPayment = paymentModel;
    
    if (self.changedPaymentTypeBlock) {
        self.changedPaymentTypeBlock(paymentModel);
    }
    
    self.accountTypeLabel.text = paymentModel.paymentName;
    
    if (paymentModel.paymentType == NNLegalTenderTradePaymentType_bank) {
        // 银行卡支付
        self.accountTitleLabel.text = [NSString stringWithFormat:@"%@  %@",paymentModel.bank_type_name, paymentModel.branch];
        
        [self.userNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.accountTitleLabel);
            make.top.equalTo(self.accountTitleLabel.mas_bottom).offset(NNHMargin_15);
        }];
        
        [self.cardNumLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.accountTitleLabel);
            make.top.equalTo(self.userNameLabel.mas_bottom).offset(NNHMargin_15);
        }];
        
        [self.certificateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(NNHMargin_15);
            make.top.equalTo(self.cardNumLabel.mas_bottom).offset(NNHMargin_15);
        }];
        
        self.userNameLabel.text = paymentModel.name;
        self.cardNumLabel.text = paymentModel.account_number;
        
        self.userNameLabel.hidden = NO;
        self.cardNumLabel.hidden = NO;
        self.codeButton.hidden = YES;
        
    }else {
        // 非银行卡支付
        
        self.userNameLabel.hidden = YES;
        self.cardNumLabel.hidden = YES;
        self.codeButton.hidden = NO;
        
        self.accountTitleLabel.text = [NSString stringWithFormat:@"%@  %@",paymentModel.name, paymentModel.account_number];
        
        self.userNameLabel.text = paymentModel.name;
        self.cardNumLabel.text = paymentModel.account_number;
        
        [self.codeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.accountTitleLabel.mas_bottom).offset(NNHMargin_15);
            make.height.equalTo(@30);
            make.left.equalTo(self.accountTitleLabel);
        }];
        
        [self.certificateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(NNHMargin_15);
            make.top.equalTo(self.codeButton.mas_bottom).offset(NNHMargin_15);
        }];
    }
    
    [self.certificateButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.certificateLabel);
        make.left.equalTo(self.accountTitleLabel);
        make.height.equalTo(@(NNHNormalViewH));
        make.bottom.equalTo(self).offset(-NNHMargin_10);
    }];
    
    [self.scanButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.certificateLabel);
        make.left.equalTo(self.certificateButton.mas_right).offset(NNHMargin_10);
        make.height.equalTo(@(NNHNormalViewH));
        make.bottom.equalTo(self).offset(-NNHMargin_10);
    }];
    
    self.scanButton.hidden = self.orderModel.payimg.length == 0;
}

/** 上传凭证 */
- (void)uploadImageCertificateAction
{
    if (self.uploadCertificateBlock) {
        self.uploadCertificateBlock();
    }
}

- (void)scanCertificateAction
{
    if (self.scanCertificateBlock) {
        self.scanCertificateBlock();
    }
}

/** 查看收款码 */
- (void)scanPayPictureAction
{
    if (self.scanPaymentCodePictureBlock) {
        self.scanPaymentCodePictureBlock();
    }
}

#pragma mark - Lazy Loads

- (UIView *)titleView
{
    if (_titleView == nil) {
        _titleView = [[UIView alloc] init];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedPaymentTypeAction)];
        [_titleView addGestureRecognizer:tap];
        
        UILabel *titleLabel = [UILabel NNHWithTitle:@"付款方式" titleColor:[UIConfigManager colorThemeBlack] font:[UIConfigManager fontThemeTextMain]];
        [_titleView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleView).offset(NNHMargin_15);
            make.centerY.equalTo(_titleView);
        }];
        
        UIImageView *arrowImageView = [[UIImageView alloc] init];
        [_titleView addSubview:arrowImageView];
        arrowImageView.image = [UIImage imageNamed:@"mine_right_arrow"];
        [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_titleView);
            make.right.equalTo(_titleView).offset(-NNHMargin_15);
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

- (UILabel *)accountTypeLabel
{
    if (_accountTypeLabel == nil) {
        _accountTypeLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorThemeBlack] font:[UIConfigManager fontThemeTextDefault]];
    }
    return _accountTypeLabel;
}

- (UILabel *)accountTitleLabel
{
    if (_accountTitleLabel == nil) {
        _accountTitleLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorThemeBlack] font:[UIConfigManager fontThemeTextDefault]];
    }
    return _accountTitleLabel;
}

- (UILabel *)userNameLabel
{
    if (_userNameLabel == nil) {
        _userNameLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorThemeBlack] font:[UIConfigManager fontThemeTextDefault]];
    }
    return _userNameLabel;
}

- (UILabel *)cardNumLabel
{
    if (_cardNumLabel == nil) {
        _cardNumLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorThemeBlack] font:[UIConfigManager fontThemeTextDefault]];
    }
    return _cardNumLabel;
}

- (UILabel *)certificateLabel
{
    if (_certificateLabel == nil) {
        _certificateLabel = [UILabel NNHWithTitle:@"付款凭证" titleColor:[UIConfigManager colorThemeBlack] font:[UIConfigManager fontThemeTextDefault]];
    }
    return _certificateLabel;
}

- (UIButton *)codeButton
{
    if (_codeButton == nil) {
        _codeButton = [UIButton NNHBtnTitle:@"查看收款码" titileFont:[UIConfigManager fontThemeTextDefault] backGround:[UIConfigManager colorThemeWhite] titleColor:[UIConfigManager colorThemeRed]];
        [_codeButton addTarget:self action:@selector(scanPayPictureAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _codeButton;
}

- (UIButton *)certificateButton
{
    if (_certificateButton == nil) {
        _certificateButton = [UIButton NNHBtnTitle:@"去上传凭证" titileFont:[UIConfigManager fontThemeTextDefault] backGround:[UIConfigManager colorThemeWhite] titleColor:[UIConfigManager colorThemeRed]];
        [_certificateButton addTarget:self action:@selector(uploadImageCertificateAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _certificateButton;
}

- (UIButton *)scanButton
{
    if (_scanButton == nil) {
        _scanButton = [UIButton NNHBtnTitle:@"查看凭证" titileFont:[UIConfigManager fontThemeTextDefault] backGround:[UIConfigManager colorThemeWhite] titleColor:[UIConfigManager colorThemeRed]];
        [_scanButton addTarget:self action:@selector(scanCertificateAction) forControlEvents:UIControlEventTouchUpInside];
        _scanButton.hidden = YES;
    }
    return _scanButton;
}




@end

