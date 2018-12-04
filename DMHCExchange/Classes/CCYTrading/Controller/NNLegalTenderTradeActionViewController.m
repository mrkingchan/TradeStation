//
//  NNLegalTenderTradeActionViewController.m
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/25.
//  Copyright © 2018 超级钱包. All rights reserved.
//

#import "NNLegalTenderTradeActionViewController.h"
#import "NNLegalTenderTradeActionTitleView.h"
#import "NNAPILegalTenderTool.h"
#import "NNLegalTenderTradeOrderActionModel.h"
#import "NNLegalTenderTradeOrderDetailViewController.h"
#import "NNHDecimalsTextField.h"
#import "NSString+NNHCalculte.h"

@interface NNLegalTenderTradeActionViewController ()

/** 头部订单信息 */
@property (nonatomic, strong) NNLegalTenderTradeActionTitleView *titleView;
/** 价格 */
@property (nonatomic, strong) UITextField *priceTextField;
/** 数量 */
@property (nonatomic, strong) NNHDecimalsTextField *numTextField;
/** 交易额 */
@property (nonatomic, strong) NNHDecimalsTextField *amountTextField;
/** 可用 */
@property (nonatomic, strong) UILabel *availableLabel;
/** 冻结 */
@property (nonatomic, strong) UILabel *freezeLabel;
/** 提交按钮 */
@property (nonatomic, weak) UIButton *submitButton;
/** 交易id */
@property (nonatomic, copy) NSString *tradeID;
/** 订单数据 */
@property (nonatomic, strong) NNLegalTenderTradeOrderActionModel *orderModel;
/** <#注释#> */
@property (nonatomic, weak) UILabel *numTitleLabel;
@end

@implementation NNLegalTenderTradeActionViewController

- (instancetype)initWithTradeID:(NSString *)tradeID
{
    if (self = [super init]) {
        _tradeID = tradeID;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIConfigManager colorThemeColorForVCBackground];
    
    [self setupChildView];
    
    [self requestOrderData];
}

- (void)setupChildView
{
    // 基本信息
    [self.view addSubview:self.titleView];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.view);
        make.width.equalTo(@(SCREEN_WIDTH));
    }];

    // 买卖
    CGFloat leftPadding = 120;
    
    // 交易价格
    UIView *priceView = [[UIView alloc] init];
    priceView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:priceView];
    [priceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.mas_bottom).offset(10);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@44);
    }];
    
    UILabel *priceTitleLabel = [UILabel NNHWithTitle:@"价格（CNY）" titleColor:[UIConfigManager colorThemeDark] font:[UIConfigManager fontThemeTextDefault]];
    [priceView addSubview:priceTitleLabel];
    [priceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(priceView);
        make.left.equalTo(priceView).offset(15);
    }];
    
    [priceView addSubview:self.priceTextField];
    [self.priceTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(priceView);
        make.left.equalTo(priceView).offset(leftPadding);
        make.right.equalTo(priceView).offset(-15);
        make.height.equalTo(priceView);
    }];
    
    // 金额
    UIView *amountView = [[UIView alloc] init];
    amountView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:amountView];
    [amountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(priceView.mas_bottom).offset(0.5);
        make.left.right.equalTo(priceView);
        make.height.equalTo(@44);
    }];

    UILabel *amountTitleLabel = [UILabel NNHWithTitle:@"金额（CNY）" titleColor:[UIConfigManager colorThemeDark] font:[UIConfigManager fontThemeTextDefault]];
    [amountView addSubview:amountTitleLabel];
    [amountTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(amountView);
        make.left.equalTo(amountView).offset(15);
    }];
    
    UIButton *allAmountButton = [UIButton NNHBtnTitle:@"全部" titileFont:[UIConfigManager fontThemeTextDefault] backGround:[UIConfigManager colorThemeWhite] titleColor:[UIColor akext_colorWithHex:@"#4e66b2"]];
    [allAmountButton addTarget:self action:@selector(allAmountButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [amountView addSubview:allAmountButton];
    [allAmountButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(amountView);
        make.width.equalTo(@60);
    }];

    [amountView addSubview:self.amountTextField];
    [self.amountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(amountView);
        make.left.equalTo(amountView).offset(leftPadding);
        make.right.equalTo(allAmountButton.mas_left).offset(-10);
        make.height.equalTo(amountView);
    }];
    
    // 数量
    UIView *numView = [[UIView alloc] init];
    numView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:numView];
    [numView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(amountView.mas_bottom).offset(0.5);
        make.left.right.equalTo(priceView);
        make.height.equalTo(priceView);
    }];

    UILabel *numTitleLabel = [UILabel NNHWithTitle:@"数量" titleColor:[UIConfigManager colorThemeDark] font:[UIConfigManager fontThemeTextDefault]];
    [numView addSubview:numTitleLabel];
    self.numTitleLabel = numTitleLabel;
    [numTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(numView);
        make.left.equalTo(numView).offset(15);
    }];
    
    UIButton *allCountButton = [UIButton NNHBtnTitle:@"全部" titileFont:[UIConfigManager fontThemeTextDefault] backGround:[UIConfigManager colorThemeWhite] titleColor:[UIColor akext_colorWithHex:@"#4e66b2"]];
    [allCountButton addTarget:self action:@selector(allCountButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [numView addSubview:allCountButton];
    [allCountButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(numView);
        make.width.equalTo(@60);
    }];

    [numView addSubview:self.numTextField];
    [self.numTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(numView);
        make.left.equalTo(numView).offset(leftPadding);
        make.right.equalTo(allCountButton.mas_left).offset(-15);
        make.height.equalTo(numView);
    }];
    
    [self.view addSubview:self.availableLabel];
    [self.view addSubview:self.freezeLabel];
    [self.availableLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(NNHMargin_15);
        make.top.equalTo(numView.mas_bottom).offset(NNHMargin_15);
    }];
    
    [self.freezeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.availableLabel.mas_right).offset(NNHMargin_20);
        make.centerY.equalTo(self.availableLabel);
    }];
    
    UIButton *submitButton = [UIButton NNHOperationBtnWithTitle:@"确认出售" target:self action:@selector(submitAction) operationButtonType:NNHOperationButtonTypeRed isAddCornerRadius:YES];
    self.submitButton = submitButton;
    submitButton.nn_acceptEventInterval = 1;
    [self.view addSubview:submitButton];
    [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.freezeLabel.mas_bottom).offset(NNHNormalViewH);
        make.left.equalTo(self.view).offset(NNHMargin_15);
        make.height.equalTo(@44);
        make.width.equalTo(@(SCREEN_WIDTH - 30));
    }];
}

#pragma mark - Network Methods

- (void)requestOrderData
{
    NNHWeakSelf(self)
    NNAPILegalTenderTool *tradeTool = [[NNAPILegalTenderTool alloc] initTradeActionCoinInfoWithTradeID:self.tradeID];
    [tradeTool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
        [weakself handleOrderData:responseDic];
    } failBlock:^(NNHRequestError *error) {
        
    } isCached:NO];
}

- (void)handleOrderData:(NSDictionary *)responseDic
{
    self.orderModel = [NNLegalTenderTradeOrderActionModel mj_objectWithKeyValues:responseDic[@"data"]];
    self.titleView.orderModel = self.orderModel;
    
    self.numTitleLabel.text = [NSString stringWithFormat:@"数量（%@）",self.orderModel.coinname];
    
    self.priceTextField.text = self.orderModel.price;
    self.amountTextField.placeholder = [NSString stringWithFormat:@"限额%@-%@",self.orderModel.minmum,self.orderModel.maxmum];
    self.availableLabel.text = [NSString stringWithFormat:@"可用%@：%@",self.orderModel.coinname,self.orderModel.coinamount];
    self.freezeLabel.text = [NSString stringWithFormat:@"冻结%@：%@",self.orderModel.coinname,self.orderModel.fut_coinamount];
    
    if ([self.orderModel.type isEqualToString:@"1"]) {
        self.navigationItem.title = [NSString stringWithFormat:@"购买%@",self.orderModel.coinname];
        [self.submitButton setTitle:@"确认购买" forState:UIControlStateNormal];
        [self.submitButton setBackgroundColor:[UIColor akext_colorWithHex:@"#3fbe72"] forState:UIControlStateNormal];
        self.numTextField.placeholder = @"请输入购买数量";
    }else {
        self.navigationItem.title = [NSString stringWithFormat:@"出售%@",self.orderModel.coinname];
        [self.submitButton setTitle:@"确认出售" forState:UIControlStateNormal];
        [self.submitButton setBackgroundColor:[UIConfigManager colorThemeRed] forState:UIControlStateNormal];
        self.numTextField.placeholder = @"请输入出售数量";
    }
    
    self.numTextField.afterPlacesCount = [self.orderModel.round integerValue];
}

#pragma mark - Public Methods

#pragma mark - Private Methods

/** 点击全部金额 */
- (void)allAmountButtonAction
{
    NSString *usableTotal= [self.orderModel.coinamount calculateByMultiplying:self.orderModel.price];
    
    if ([self.orderModel.type isEqualToString:@"1"]) {
        self.amountTextField.text = [self.orderModel.maxmum calculateByRounding:2];
    }else {
        if ([self.orderModel.maxmum calculateIsGreaterThan:usableTotal]) {
            self.amountTextField.text = [usableTotal calculateByRounding:2];
        }else {
            self.amountTextField.text = [self.orderModel.maxmum calculateByRounding:2];
        }
    }

    [self calculateOrderNum];
}

/** 点击全部数量 */
- (void)allCountButtonAction
{
    if ([self.orderModel.type isEqualToString:@"1"]) {
        self.numTextField.text = [self.orderModel.num calculateByRounding:[self.orderModel.round integerValue]];
    }else {
        if ([self.orderModel.maxmum calculateIsGreaterThan:self.orderModel.coinamount]) {
            self.numTextField.text = [self.orderModel.coinamount calculateByRounding:[self.orderModel.round integerValue]];;
        }else {
            self.numTextField.text = [self.orderModel.num calculateByRounding:[self.orderModel.round integerValue]];
        }
    }
    
    [self calculateOrderAmount];
}

/** 计算订单总额 */
- (void)calculateOrderAmount
{
    if (self.numTextField.hasText && [self.numTextField.text floatValue] > 0) {
        NSString *amount = [self.numTextField.text calculateByMultiplying:self.orderModel.price];
            self.amountTextField.text = [amount calculateByRounding:2];
    }else {
        self.amountTextField.text = @"";
    }
}

/** 计算订单交易数量 */
- (void)calculateOrderNum
{
    if (self.amountTextField.hasText && [self.amountTextField.text floatValue] > 0) {
        NSString *count = [self.amountTextField.text calculateByDividing:self.orderModel.price];
        self.numTextField.text = [count calculateByRounding:[self.orderModel.round integerValue]];
    }else {
        self.numTextField.text = @"";
    }
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.amountTextField) {
        [self calculateOrderNum];
    }
    
    if (textField == self.numTextField) {
        [self calculateOrderAmount];
    }
}

- (void)submitAction
{
    if (self.amountTextField.text.floatValue == 0) {
        [SVProgressHUD showMessage:@"交易金额不得为零"];
        return;
    }
    
    if (self.numTextField.text.floatValue == 0) {
        [SVProgressHUD showMessage:@"交易数量不得为零"];
        return;
    }
    
    NNHWeakSelf(self)
    [SVProgressHUD show];
    NNAPILegalTenderTool *tradeTool = [[NNAPILegalTenderTool alloc] initDoTradeWithTradeID:self.tradeID number:self.numTextField.text amount:self.amountTextField.text];
    [tradeTool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
        [SVProgressHUD dismiss];
        NSString *orderID = responseDic[@"data"][@"tradeid"];
        NNLegalTenderTradeOrderDetailViewController *detailVC = [[NNLegalTenderTradeOrderDetailViewController alloc] initWithOrderID:orderID];
        detailVC.fromActionVC = YES;
        [weakself.navigationController pushViewController:detailVC animated:YES];
    } failBlock:^(NNHRequestError *error) {
        
    } isCached:NO];
}

#pragma mark - Lazy Loads

- (NNLegalTenderTradeActionTitleView *)titleView
{
    if (_titleView == nil) {
        _titleView = [[NNLegalTenderTradeActionTitleView alloc] init];
    }
    return _titleView;
}

- (UITextField *)priceTextField
{
    if (_priceTextField == nil) {
        _priceTextField = [[UITextField alloc] init];
        _priceTextField.font = [UIConfigManager fontThemeTextDefault];
        _priceTextField.textColor = [UIConfigManager colorThemeDark];
        _priceTextField.keyboardType = UIKeyboardTypeDecimalPad;
        _priceTextField.enabled = NO;
        _priceTextField.text = @"";
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
    }
    return _numTextField;
}

- (NNHDecimalsTextField *)amountTextField
{
    if (_amountTextField == nil) {
        _amountTextField = [[NNHDecimalsTextField alloc] init];
        _amountTextField.placeholder = @"交易限额";
        _amountTextField.font = [UIConfigManager fontThemeTextDefault];
        _amountTextField.textColor = [UIConfigManager colorThemeDark];
        _amountTextField.keyboardType = UIKeyboardTypeDecimalPad;
        [_amountTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _amountTextField.afterPlacesCount = 2;
    }
    return _amountTextField;
}

- (UILabel *)availableLabel
{
    if (_availableLabel == nil) {
        _availableLabel = [UILabel NNHWithTitle:@"可用USDT：100" titleColor:[UIConfigManager colorThemeDarkGray] font:[UIConfigManager fontThemeTextTip]];
    }
    return _availableLabel;
}

- (UILabel *)freezeLabel
{
    if (_freezeLabel == nil) {
        _freezeLabel = [UILabel NNHWithTitle:@"冻结USDT：100" titleColor:[UIConfigManager colorThemeDarkGray] font:[UIConfigManager fontThemeTextTip]];
    }
    return _freezeLabel;
}


@end
