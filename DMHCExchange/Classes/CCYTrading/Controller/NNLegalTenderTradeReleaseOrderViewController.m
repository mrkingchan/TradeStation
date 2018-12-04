//
//  NNLegalTenderTradeReleaseOrderViewController.m
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/25.
//  Copyright © 2018 超级钱包. All rights reserved.
//

#import "NNLegalTenderTradeReleaseOrderViewController.h"
#import "NNHTopToolbar.h"
#import "NNAPILegalTenderTool.h"
#import "NNLegalTenderTradeReleaseOrderResultViewController.h"
#import "NNLegalTenderTradeReleaseCoinModel.h"
#import "NNLegalTenderTradeReleaseOrderResultViewController.h"
#import "NNHDecimalsTextField.h"
#import "NSString+NNHCalculte.h"

@interface NNLegalTenderTradeReleaseOrderViewController () <NNHTopToolbarDelegate>

/** 价格 */
@property (nonatomic, strong) NNHDecimalsTextField *priceTextField;
/** 数量 */
@property (nonatomic, strong) NNHDecimalsTextField *numTextField;
/** 交易总额 */
@property (nonatomic, strong) NNHDecimalsTextField *amountTextField;
/** 最小交易额 */
@property (nonatomic, strong) NNHDecimalsTextField *minTextField;
/** 交易说明 */
@property (nonatomic, strong) UITextField *remarkTextField;
/** 资金密码 */
@property (nonatomic, strong) UITextField *paycodeTextField;
/** 顶部工具栏 */
@property (nonatomic, strong) NNHTopToolbar *toolbar;
/** scrollView */
@property (nonatomic, weak) UIScrollView *scrollView;
/** 手续费 */
@property (nonatomic, strong) UILabel *feeLabel;
/** 保证金 */
@property (nonatomic, strong) UILabel *marginLabel;
/** 提示 */
@property (nonatomic, strong) UILabel *messageLabel;
/** 当前价 */
@property (nonatomic, strong) UILabel *currentPriceLabel;
/** 币种id */
@property (nonatomic, copy) NSString *coinID;
/** 币种名称 */
@property (nonatomic, copy) NSString *coinName;
/** 币种id */
@property (nonatomic, strong) NNLegalTenderTradeReleaseCoinModel *coinModel;
/** 发布类型 */
@property (nonatomic, assign) NNLegalTenderTradeType releaseType;
/** 全部按钮 */
@property (nonatomic, weak) UIButton *allCountButton;
/** 确认按钮 */
@property (nonatomic, weak) UIButton *ensureButton;
@end

@implementation NNLegalTenderTradeReleaseOrderViewController

- (instancetype)initWithCoinID:(NSString *)coinID coinName:(NSString *)coinName
{
    if (self = [super init]) {
        _coinID = coinID;
        _coinName = coinName;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = [NSString stringWithFormat:@"发布交易单(%@)",self.coinName];
    self.view.backgroundColor = [UIConfigManager colorThemeColorForVCBackground];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.currentPriceLabel];
    
    self.releaseType = NNLegalTenderTradeType_buy;
    
    [self setupChildView];
    
    [self requestIndexData];
}

- (void)setupChildView {
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces = NO;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // 工具栏
    [self.scrollView addSubview:self.toolbar];
    
    // 交易价格
    UIView *priceView = [[UIView alloc] init];
    priceView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:priceView];
    [priceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.toolbar.mas_bottom).offset(NNHMargin_10);
        make.left.equalTo(self.scrollView);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@(NNHNormalViewH));
    }];
    
    UILabel *priceTitleLabel = [UILabel NNHWithTitle:@"交易价格" titleColor:[UIConfigManager colorThemeDark] font:[UIConfigManager fontThemeTextDefault]];
    [priceView addSubview:priceTitleLabel];
    [priceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(priceView);
        make.left.equalTo(priceView).offset(NNHMargin_15);
    }];

    [priceView addSubview:self.priceTextField];
    [self.priceTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(priceView);
        make.left.equalTo(priceView).offset(130);
        make.right.equalTo(priceView).offset(-NNHMargin_15);
        make.height.equalTo(priceView);
    }];
    
    // 数量
    UIView *numView = [[UIView alloc] init];
    numView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:numView];
    [numView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(priceView.mas_bottom).offset(NNHLineH);
        make.left.right.equalTo(priceView);
        make.height.equalTo(priceView);
    }];
    
    UILabel *numTitleLabel = [UILabel NNHWithTitle:@"数量（USDT）" titleColor:[UIConfigManager colorThemeDark] font:[UIConfigManager fontThemeTextDefault]];
    [numView addSubview:numTitleLabel];
    [numTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(numView);
        make.left.equalTo(numView).offset(15);
    }];

    UIButton *allButton = [UIButton NNHBtnTitle:@"全部" titileFont:[UIConfigManager fontThemeTextDefault] backGround:[UIConfigManager colorThemeWhite] titleColor:[UIColor akext_colorWithHex:@"#4e66b2"]];
    self.allCountButton = allButton;
    [allButton addTarget:self action:@selector(allButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [numView addSubview:allButton];
    [allButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(numView);
        make.width.equalTo(@60);
    }];
    
    [numView addSubview:self.numTextField];
    [self.numTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(numView);
        make.left.equalTo(numView).offset(130);
        make.right.equalTo(allButton.mas_left).offset(-NNHMargin_5);
        make.height.equalTo(numView);
    }];
    
    // 金额
    UIView *amountView = [[UIView alloc] init];
    amountView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:amountView];
    [amountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(numView.mas_bottom).offset(NNHLineH);
        make.left.right.equalTo(priceView);
        make.height.equalTo(@44);
    }];
    
    UILabel *amountTitleLabel = [UILabel NNHWithTitle:@"金额（CNY）" titleColor:[UIConfigManager colorThemeDark] font:[UIConfigManager fontThemeTextDefault]];
    [amountView addSubview:amountTitleLabel];
    [amountTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(amountView);
        make.left.equalTo(amountView).offset(NNHMargin_15);
    }];

    [amountView addSubview:self.amountTextField];
    [self.amountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(amountView);
        make.left.equalTo(amountView).offset(130);
        make.right.equalTo(amountView).offset(-NNHMargin_15);
        make.height.equalTo(amountView);
    }];
    
    // 单笔限制
    UIView *limitView = [[UIView alloc] init];
    limitView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:limitView];
    [limitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(amountView.mas_bottom).offset(NNHMargin_10);
        make.left.right.equalTo(priceView);
        make.height.equalTo(@44);
    }];
    
    UILabel *limitTitleLabel = [UILabel NNHWithTitle:@"单笔限额（CNY）" titleColor:[UIConfigManager colorThemeDark] font:[UIConfigManager fontThemeTextDefault]];
    [limitView addSubview:limitTitleLabel];
    [limitTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(limitView);
        make.left.equalTo(limitView).offset(NNHMargin_15);
    }];

    [limitView addSubview:self.minTextField];
    [self.minTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(limitView);
        make.left.equalTo(limitView).offset(130);
        make.right.equalTo(limitView).offset(NNHMargin_15);
        make.height.equalTo(limitView);
    }];
    
    // 交易说明
    UIView *remarkView = [[UIView alloc] init];
    remarkView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:remarkView];
    [remarkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(limitView.mas_bottom).offset(NNHLineH);
        make.left.right.equalTo(priceView);
        make.height.equalTo(@(NNHNormalViewH));
    }];
    
    UILabel *remarkTitleLabel = [UILabel NNHWithTitle:@"交易说明" titleColor:[UIConfigManager colorThemeDark] font:[UIConfigManager fontThemeTextDefault]];
    [remarkView addSubview:remarkTitleLabel];
    [remarkTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(remarkView);
        make.left.equalTo(remarkView).offset(15);
        make.height.equalTo(@44);
    }];

    [remarkView addSubview:self.remarkTextField];
    [self.remarkTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(remarkView);
        make.left.equalTo(remarkView).offset(130);
        make.right.equalTo(remarkView).offset(-NNHMargin_15);
        make.height.equalTo(remarkView);
    }];
    
    // 资金密码
    UIView *codeView = [[UIView alloc] init];
    codeView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:codeView];
    [codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(remarkView.mas_bottom).offset(NNHMargin_10);
        make.left.right.equalTo(priceView);
        make.height.equalTo(@(NNHNormalViewH));
    }];
    
    UILabel *codeTitleLabel = [UILabel NNHWithTitle:@"资金密码" titleColor:[UIConfigManager colorThemeDark] font:[UIConfigManager fontThemeTextDefault]];
    [codeView addSubview:codeTitleLabel];
    [codeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(codeView);
        make.left.equalTo(codeView).offset(NNHMargin_15);
    }];

    [codeView addSubview:self.paycodeTextField];
    [self.paycodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(codeView);
        make.left.equalTo(codeView).offset(130);
        make.right.equalTo(codeView).offset(-NNHMargin_15);
        make.height.equalTo(codeView);
    }];
    
    [self.scrollView addSubview:self.feeLabel];
    [self.scrollView addSubview:self.marginLabel];
    [self.scrollView addSubview:self.messageLabel];
    
    [self.feeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView).offset(NNHMargin_15);
        make.top.equalTo(codeView.mas_bottom).offset(NNHMargin_15);
    }];
    
    [self.marginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(priceView).offset(-NNHMargin_15);
        make.centerY.equalTo(self.feeLabel);
    }];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView).offset(NNHMargin_15);
        make.width.equalTo(@(SCREEN_WIDTH - 30));
        make.top.equalTo(self.feeLabel.mas_bottom).offset(NNHMargin_15);
    }];
    
    // 交易按钮
    UIButton *tradingButton = [UIButton NNHOperationBtnWithTitle:@"发布交易单" target:self action:@selector(publishTradinAction) operationButtonType:NNHOperationButtonTypeRed isAddCornerRadius:YES];
    tradingButton.enabled = NO;
    self.ensureButton = tradingButton;
    [self.view addSubview:tradingButton];
    [tradingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.messageLabel.mas_bottom).offset(80);
        make.left.equalTo(self.scrollView).offset(NNHMargin_15);
        make.width.equalTo(@(SCREEN_WIDTH - 30));
        make.height.equalTo(@44);
    }];
    
    [scrollView setNeedsLayout];
    [scrollView layoutIfNeeded];
    
    CGFloat height = CGRectGetMaxY(tradingButton.frame) + NNHNormalViewH * 2;
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, height);
}


#pragma mark - Network Methods

/** 获取界面展示信息 */
- (void)requestIndexData
{
    NNHWeakSelf(self)
    NNAPILegalTenderTool *tradeTool = [[NNAPILegalTenderTool alloc] initReleaseOrderIndexDataWithCoinID:self.coinID];
    [tradeTool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
        [weakself handleCoinData:responseDic];
    } failBlock:^(NNHRequestError *error) {
        
    } isCached:NO];
    
}

- (void)handleCoinData:(NSDictionary *)responseDic
{
    self.coinModel = [NNLegalTenderTradeReleaseCoinModel mj_objectWithKeyValues:responseDic[@"data"]];
    [self resetReleaseOrderType];
}

/** 充值发布类型 */
- (void)resetReleaseOrderType
{
    self.currentPriceLabel.text = [NSString stringWithFormat:@"￥%@",self.coinModel.currentPrice];
    [self.currentPriceLabel sizeToFit];
    if (self.releaseType == NNLegalTenderTradeType_buy) {
        self.feeLabel.text = [NSString stringWithFormat:@"手续费：%@",self.coinModel.fee_buy];
        self.marginLabel.text = self.coinModel.buy_bail;
        self.messageLabel.text = self.coinModel.fee_buy_str;
        self.numTextField.placeholder = @"请输入购买数量";
        self.allCountButton.hidden = YES;
    }else {
        self.feeLabel.text = [NSString stringWithFormat:@"手续费：%@",self.coinModel.fee_sell];
        self.marginLabel.text = self.coinModel.sell_bail;
        self.messageLabel.text = self.coinModel.fee_sell_str;
        self.numTextField.placeholder = @"请输入出售数量";
        self.allCountButton.hidden = NO;
    }
    
    if (self.coinModel.minmum.length) {
        self.minTextField.placeholder = [NSString stringWithFormat:@"最小额%@",self.coinModel.minmum];
    }else {
        self.minTextField.placeholder = @"最小额";
    }
    
    self.priceTextField.afterPlacesCount = 2;
    self.numTextField.afterPlacesCount = [self.coinModel.round integerValue];
    
    [self.messageLabel nnh_addLineSpaceWithLineSpace:5];
}

/** 点击全部售出 */
- (void)allButtonAction
{
    self.numTextField.text = [self.coinModel.amount calculateByRounding:[self.coinModel.round integerValue]];
    
    [self calculateOrderAmount];
}

/** 计算订单价格 */
- (void)calculateOrderAmount
{
    if (self.numTextField.hasText && [self.numTextField.text floatValue] > 0 && self.priceTextField.hasText && [self.priceTextField.text floatValue] > 0) {
        NSString *amount = [self.numTextField.text calculateByMultiplying:self.priceTextField.text];
        self.amountTextField.text = [amount calculateByRounding:2];
    }else {
        self.amountTextField.text = @"";
    }
}

- (void)publishTradinAction
{
    if (self.priceTextField.text.floatValue == 0) {
        [SVProgressHUD showMessage:@"请输入交易价格"];
        return;
    }
    
    if (self.numTextField.text.floatValue == 0) {
        [SVProgressHUD showMessage:@"请输入交易数量"];
        return;
    }
    
    NNHWeakSelf(self)
    [SVProgressHUD show];
    NNAPILegalTenderTool *tradeTool = [[NNAPILegalTenderTool alloc] initReleaseOrderWithCoinID:self.coinID
                                                                                   paypassword:self.paycodeTextField.text
                                                                                         price:self.priceTextField.text
                                                                                         count:self.numTextField.text
                                                                                   limitAmount:self.minTextField.text
                                                                                        remark:self.remarkTextField.text
                                                                                     tradeType:self.releaseType];
    [tradeTool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
        [SVProgressHUD dismiss];
        NNLegalTenderTradeReleaseOrderResultViewController *resultVC = [[NNLegalTenderTradeReleaseOrderResultViewController alloc] init];
        [weakself.navigationController pushViewController:resultVC animated:YES];
    } failBlock:^(NNHRequestError *error) {
        
    } isCached:NO];
}


- (void)textFieldDidChange:(UITextField *)textField
{
    self.ensureButton.enabled = self.priceTextField.hasText && self.numTextField.hasText && self.paycodeTextField.hasText;
    
    [self calculateOrderAmount];
}

#pragma mark --
#pragma mark -- NNHTopToolbarDelegate
- (void)topToolbar:(NNHTopToolbar *)toolbar didSelectedButton:(UIButton *)button
{
    self.releaseType = button.tag;
    [self resetReleaseOrderType];
    
    [self calculateOrderAmount];
}

- (NNHDecimalsTextField *)priceTextField
{
    if (_priceTextField == nil) {
        _priceTextField = [[NNHDecimalsTextField alloc] init];
        _priceTextField.placeholder = @"请输入交易价格";
        _priceTextField.font = [UIConfigManager fontThemeTextDefault];
        _priceTextField.textColor = [UIConfigManager colorThemeDark];
        _priceTextField.keyboardType = UIKeyboardTypeDecimalPad;
        [_priceTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _priceTextField.afterPlacesCount = 2;
    }
    return _priceTextField;
}

- (NNHDecimalsTextField *)numTextField
{
    if (_numTextField == nil) {
        _numTextField = [[NNHDecimalsTextField alloc] init];
        _numTextField.placeholder = @"请输入购买数量";
        _numTextField.font = [UIConfigManager fontThemeTextDefault];
        _numTextField.textColor = [UIConfigManager colorThemeDark];
        _numTextField.keyboardType = UIKeyboardTypeDecimalPad;
        [_numTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _numTextField.afterPlacesCount = 8;
    }
    return _numTextField;
}

- (NNHDecimalsTextField *)amountTextField
{
    if (_amountTextField == nil) {
        _amountTextField = [[NNHDecimalsTextField alloc] init];
        _amountTextField.placeholder = @"交易总额";
        _amountTextField.font = [UIConfigManager fontThemeTextDefault];
        _amountTextField.textColor = [UIConfigManager colorThemeDark];
        _amountTextField.enabled = NO;
        _amountTextField.afterPlacesCount = 2;
    }
    return _amountTextField;
}

- (NNHDecimalsTextField *)minTextField
{
    if (_minTextField == nil) {
        _minTextField = [[NNHDecimalsTextField alloc] init];
        _minTextField.placeholder = @"最小额";
        _minTextField.font = [UIConfigManager fontThemeTextDefault];
        _minTextField.textColor = [UIConfigManager colorThemeDark];
        _minTextField.keyboardType = UIKeyboardTypeDecimalPad;
        _minTextField.afterPlacesCount = 2;
    }
    return _minTextField;
}

- (UITextField *)remarkTextField
{
    if (_remarkTextField == nil) {
        _remarkTextField = [[UITextField alloc] init];
        _remarkTextField.font = [UIConfigManager fontThemeTextDefault];
        _remarkTextField.textColor = [UIConfigManager colorThemeDark];
        _remarkTextField.placeholder = @"最多输入50个字";
    }
    return _remarkTextField;
}

- (NNHTopToolbar *)toolbar
{
    if (_toolbar == nil) {
        _toolbar = [[NNHTopToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44) titles:@[@"我要购买",@"我要出售"]];
        _toolbar.delegate = self;
    }
    return _toolbar;
}

- (UITextField *)paycodeTextField
{
    if (_paycodeTextField == nil) {
        _paycodeTextField = [[UITextField alloc] init];
        _paycodeTextField.placeholder = @"请输入资金密码";
        _paycodeTextField.font = [UIConfigManager fontThemeTextDefault];
        _paycodeTextField.textColor = [UIConfigManager colorThemeDark];
        _paycodeTextField.keyboardType = UIKeyboardTypeNumberPad;
        [_paycodeTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _paycodeTextField.secureTextEntry = YES;
    }
    return _paycodeTextField;
}

- (UILabel *)feeLabel
{
    if (_feeLabel == nil) {
        _feeLabel = [UILabel NNHWithTitle:@"手续费：" titleColor:[UIConfigManager colorThemeRed] font:[UIConfigManager fontThemeTextTip]];
    }
    return _feeLabel;
}

- (UILabel *)marginLabel
{
    if (_marginLabel == nil) {
        _marginLabel = [UILabel NNHWithTitle:@"交易保证金：" titleColor:[UIConfigManager colorThemeRed] font:[UIConfigManager fontThemeTextTip]];
    }
    return _marginLabel;
}

- (UILabel *)messageLabel
{
    if (_messageLabel == nil) {
        _messageLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorTextLightGray] font:[UIConfigManager fontThemeTextTip]];
        _messageLabel.numberOfLines = 0;
    }
    return _messageLabel;
}

- (UILabel *)currentPriceLabel
{
    if (_currentPriceLabel == nil) {
        _currentPriceLabel = [UILabel NNHWithTitle:@"" titleColor:[UIColor akext_colorWithHex:@"#4e66b2"] font:[UIFont boldSystemFontOfSize:14]];
//        _currentPriceLabel.frame = CGRectMake(0, 0, 80, 40);
    }
    return _currentPriceLabel;
}

@end
