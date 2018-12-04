//
//  NNCoinBuySellViewController.m
//  SuperWallet
//
//  Created by 牛牛 on 2018/3/31.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import "NNCoinBuySellViewController.h"
#import "NNCoinBuySellListView.h"
#import "NNCoinTextField.h"
#import "NNHAPITradingTool.h"
#import "NNHEnterPasswordView.h"
#import "NSString+NNHCalculte.h"

@interface NNAccountBalanceModel : NSObject

/** 币可用余额 */
@property (nonatomic, copy) NSString *coinid;
/** cny可用余额 */
@property (nonatomic, copy) NSString *unitcoinid;
/** 精度 */
@property (nonatomic, strong) NSDecimalNumber *decimalNumber;

@end

@implementation NNAccountBalanceModel

@end


@interface NNCoinBuySellViewController () <UITextFieldDelegate>

/** 右侧挂单view */
@property (nonatomic, strong) NNCoinBuySellListView *rightListView;
/** 密码view */
@property (nonatomic, strong) NNHEnterPasswordView *enterView;
/** 账户余额 */
@property (nonatomic, strong) NNAccountBalanceModel *accountBalanceModel;
/** 价格 */
@property (nonatomic, strong) NNCoinTextField *priceTextfield;
/** 买卖数量 */
@property (nonatomic, strong) NNCoinTextField *coinTextField;
/** 可用cny */
@property (nonatomic, strong) UILabel *availableCnyLabel;
/** 当前买卖数量 */
@property (nonatomic, strong) UILabel *availableCoinLabel;
/** 当前金额 */
@property (nonatomic, strong) UILabel *tradingAmountLabel;
/** 操作按钮 */
@property (nonatomic, strong) UIButton *operationButton;
/** 记录当前选中数量按钮 */
@property (nonatomic, strong) UIButton *selectedNumButton;
/** 买／卖 */
@property (nonatomic, assign) NNHCoinTradingOrderType coinTradingType;
/** 币种模型 */
@property (nonatomic, strong) NNCoinTradingMarketModel *coinTradingMarketModel;
/** 定时器 */
@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation NNCoinBuySellViewController

- (void)dealloc
{
    NNHLog(@"------%s-----",__func__);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 开启定时器
    dispatch_resume(self.timer);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    dispatch_source_cancel(self.timer);
    self.timer = nil;
}

- (instancetype)initWithCoinTradingType:(NNHCoinTradingOrderType)type
                 coinTradingMarketModel:(NNCoinTradingMarketModel *)model
{
    if (self = [super init]) {
        _coinTradingType = type;
        _coinTradingMarketModel = model;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = _coinTradingMarketModel.name;
    
    [self setupChildView];
    
    // 获取数据
    [self requestLeftDataSource];
//    [self requestRightDataSource];
//    [self requestNewPrice];
}

- (void)setupChildView
{
    [self createLeftView];
    [self createRightView];
}

- (void)requestNewPrice
{
    NNHAPITradingTool *tool = [[NNHAPITradingTool alloc] initTradingCoinNewPriceWithCoinID:self.coinTradingMarketModel.marketcoinid];
    NNHWeakSelf(self)
    [tool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
        weakself.rightListView.currentPrice = responseDic[@"data"][@"new_price"];
    } failBlock:^(NNHRequestError *error) {

    } isCached:NO];
}

- (void)requestLeftDataSource
{
    NNHAPITradingTool *tool = [[NNHAPITradingTool alloc] initTradingUserBalanceWithCoinID:self.coinTradingMarketModel.marketcoinid];
    tool.noJumpLogin = YES;
    NNHWeakSelf(self)
    [tool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
        weakself.accountBalanceModel = [NNAccountBalanceModel mj_objectWithKeyValues:responseDic[@"data"]];
        [weakself updateLeftValue];
    } failBlock:^(NNHRequestError *error) {

    } isCached:NO];
}

- (void)requestRightDataSource
{
    NNHAPITradingTool *tool = [[NNHAPITradingTool alloc] initTradingBuySellListWithWithCoinID:self.coinTradingMarketModel.marketcoinid];
    NNHWeakSelf(self)
    [tool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
        [weakself updateRightValue:responseDic];
    } failBlock:^(NNHRequestError *error) {

    } isCached:NO];
}

- (void)updateLeftValue
{
    self.availableCnyLabel.text = self.accountBalanceModel.unitcoinid;
    self.availableCoinLabel.text = self.accountBalanceModel.coinid;
}

- (void)updateRightValue:(NSDictionary *)responseDic
{
    self.rightListView.buyLists = responseDic[@"data"][@"buy"];
    self.rightListView.sellLists = responseDic[@"data"][@"sell"];
}

- (void)createLeftView
{
    [self.view addSubview:self.priceTextfield];
    [self.priceTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(15);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view.mas_centerX).offset(-15);
        make.height.equalTo(@44);
    }];
    
    [self.view addSubview:self.coinTextField];
    [self.coinTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceTextfield.mas_bottom).offset(10);
        make.left.equalTo(self.priceTextfield);
        make.right.equalTo(self.priceTextfield);
        make.height.equalTo(self.priceTextfield);
    }];
    
    // 比例容器
    NSArray *numArr = @[@"25%",@"50%",@"75%",@"100%"];
    CGFloat btnW = (SCREEN_WIDTH *0.5 - 10 - 15) / numArr.count;
    UIView *scaleContentView = [[UIView alloc] init];
    scaleContentView.backgroundColor = [UIColor whiteColor];
    NNHViewBorderRadius(scaleContentView, 0.00, 0.5, [UIConfigManager colorThemeSeperatorLightGray])
    [self.view addSubview:scaleContentView];
    [scaleContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coinTextField.mas_bottom).offset(15);
        make.left.right.equalTo(self.priceTextfield);
        make.height.equalTo(@28);
    }];
    for (NSInteger i = 0; i < numArr.count; i++) {
        UIButton *numButton = [UIButton NNHBtnTitle:numArr[i] titileFont:[UIFont systemFontOfSize:10] backGround:[UIColor whiteColor] titleColor:[UIConfigManager colorTextLightGray]];
        [numButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [numButton setBackgroundColor:[UIColor akext_colorWithHex:@"3fbe72"] forState:UIControlStateSelected];
        [numButton addTarget:self action:@selector(changeBuySellNumAction:) forControlEvents:UIControlEventTouchUpInside];
        [scaleContentView addSubview:numButton];
        [numButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(scaleContentView);
            make.left.equalTo(scaleContentView).offset(i *btnW);
            make.width.equalTo(@(btnW));
        }];
    }
    
    UILabel *tradingTitleLabel = [UILabel NNHWithTitle:@"交易额" titleColor:[UIConfigManager colorTextLightGray] font:[UIFont systemFontOfSize:11]];
    [self.view addSubview:tradingTitleLabel];
    [tradingTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scaleContentView.mas_bottom).offset(40);
        make.left.equalTo(self.priceTextfield);
    }];
    
    [self.view addSubview:self.tradingAmountLabel];
    [self.tradingAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.baseline.equalTo(tradingTitleLabel);
        make.left.equalTo(tradingTitleLabel.mas_right);
        make.right.equalTo(self.priceTextfield);
    }];
    
    [self.view addSubview:self.operationButton];
    [self.operationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tradingAmountLabel.mas_bottom).offset(25);
        make.left.right.equalTo(self.priceTextfield);
        make.height.equalTo(@44);
    }];
    
    UILabel *availableCnyTitleLabel = [UILabel NNHWithTitle:[NSString stringWithFormat:@"可用%@",self.coinTradingMarketModel.unitcoinname] titleColor:[UIConfigManager colorTextLightGray] font:[UIConfigManager fontThemeTextTip]];
    [self.view addSubview:availableCnyTitleLabel];
    [availableCnyTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.operationButton.mas_bottom).offset(40);
        make.left.equalTo(self.priceTextfield);
    }];
    
    [self.view addSubview:self.availableCnyLabel];
    [self.availableCnyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(availableCnyTitleLabel);
        make.right.equalTo(self.priceTextfield);
    }];
    
    UILabel *availableCoinTitleLabel = [UILabel NNHWithTitle:[NSString stringWithFormat:@"可用%@",self.coinTradingMarketModel.coinname] titleColor:[UIConfigManager colorTextLightGray] font:[UIConfigManager fontThemeTextTip]];
    [self.view addSubview:availableCoinTitleLabel];
    [availableCoinTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(availableCnyTitleLabel.mas_bottom).offset(15);
        make.left.equalTo(self.priceTextfield);
    }];
    
    [self.view addSubview:self.availableCoinLabel];
    [self.availableCoinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(availableCoinTitleLabel);
        make.right.equalTo(self.priceTextfield);
    }];
}

- (void)createRightView
{    
    [self.view addSubview:self.rightListView];
    [self.rightListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.view);
        make.right.equalTo(self.view).offset(-10);
        make.left.equalTo(self.view.mas_centerX).offset(15);
    }];
}

#pragma mark -
#pragma mark ---------userAction
- (void)changeBuySellNumAction:(UIButton *)button
{
    if (self.selectedNumButton == button && button.selected) {
        button.selected = NO;
        self.selectedNumButton = nil;
        return;
    };
    
    button.selected = YES;
    self.selectedNumButton.selected = NO;
    self.selectedNumButton = button;
    
    // 计算总价
    [self calculateTradingAmount];
}

- (void)calculateTradingAmount
{
    // 价格存在
    if (!self.priceTextfield.hasText) return;
    
    // 1、获取当前选中比例
    NSString *scale = [NSString stringWithFormat:@"%f",[self.selectedNumButton.currentTitle doubleValue] / 100];
    
    // 2、获取当前买卖币数量
    NSString *coinAmoutStr = self.accountBalanceModel.coinid;
    if (self.coinTradingType == NNHCoinTradingOrderType_buyIn) {
        coinAmoutStr = [self.accountBalanceModel.unitcoinid calculateByDividing:self.priceTextfield.text];
    }
    
    // 3、获取当前选中比例后的买卖币数量
    self.coinTextField.text = [[coinAmoutStr calculateByMultiplying:scale] calculateByRounding:[self.coinTradingMarketModel.lot integerValue]];
    
    // 计算交易总额
    self.tradingAmountLabel.text = [self calculateWithStartValue:self.priceTextfield.text endValue:self.coinTextField.text];
}

- (NSString *)calculateWithStartValue:(NSString *)startValue endValue:(NSString *)endValue
{
    return [startValue calculateByMultiplying:endValue];
}

- (void)operationAction
{
    if (![[NNHProjectControlCenter sharedControlCenter] loginStatus:YES]) return;
    if (![[NNHApplicationHelper sharedInstance] isSetupPayPassword]) return;
    
    if (!self.priceTextfield.hasText) {
        [SVProgressHUD showMessage:@"买卖价格不能为空"];
        return;
    }
    
    if (!self.coinTextField.hasText) {
        [SVProgressHUD showMessage:@"买卖数量不能为空"];
        return;
    }
    
    [self.enterView showInFatherView:self.navigationController.view];
}

- (void)inputPayCode:(NSString *)paycode
{
    [SVProgressHUD nn_showWithStatus:@"下单中"];
    NNHAPITradingTool *tool = [[NNHAPITradingTool alloc] initCoinOrderWithOrderType:self.coinTradingType paypwd:paycode coinName:self.coinTradingMarketModel.name amount:self.coinTextField.text price:self.priceTextfield.text];
    NNHWeakSelf(self)
    [tool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
        NNHStrongSelf(self)
        [SVProgressHUD nn_dismissWithDelay:.5 completion:^{
            [strongself.enterView dissmissWithCompletion:nil];
            [SVProgressHUD showMessage:@"下单完成"];
            [strongself requestLeftDataSource];
//            [strongself requestRightDataSource];
//            [strongself requestNewPrice];
        }];
    } failBlock:^(NNHRequestError *error) {
        [weakself.enterView resetStatus];
    } isCached:NO];
}

#pragma mark -
#pragma mark ---------UITextFieldDelegate
- (void)textFieldDidChange:(NNCoinTextField *)textField
{
    if (textField == self.coinTextField && self.selectedNumButton) { // 当操作买卖数量并且有选中状态时，清空
        [self changeBuySellNumAction:self.selectedNumButton];
    }
    
    if (self.priceTextfield.hasText && self.coinTextField.hasText) {
        self.tradingAmountLabel.text = [self calculateWithStartValue:self.priceTextfield.text endValue:[self.coinTextField.text calculateByRounding:[self.coinTradingMarketModel.lot integerValue]]];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    // 判断是否输入内容，或者用户点击的是键盘的删除按钮
    if (![string isEqualToString:@""]) {
        
        // 价格小数点
        NSInteger lot = 0;
        if (textField == self.priceTextfield) {
            lot = [self.coinTradingMarketModel.ccylot integerValue];
        }
        
        // 数量小数点
        if (textField == self.coinTextField) {
            lot = [self.coinTradingMarketModel.lot integerValue];
            if (lot == 0 && [string isEqualToString:@"."]) {
                return NO;
            }
        }
        
        // 小数点在字符串中的位置 第一个数字从0位置开始
        NSInteger dotLocation = [textField.text rangeOfString:@"."].location;
        
        if (dotLocation != NSNotFound && range.location > dotLocation + lot) {
            return NO;
        }
    }
    return YES;
}

- (NNCoinTextField *)priceTextfield
{
    if (_priceTextfield == nil) {
        _priceTextfield = [[NNCoinTextField alloc] init];
        _priceTextfield.delegate = self;
        [_priceTextfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _priceTextfield.placeholder = [NSString stringWithFormat:@"%@价格%@",_coinTradingType == NNHCoinTradingOrderType_buyIn ? @"买入" : @"卖出",_coinTradingMarketModel.unitcoinname];
    }
    return _priceTextfield;
}

- (NNCoinTextField *)coinTextField
{
    if (_coinTextField == nil) {
        _coinTextField = [[NNCoinTextField alloc] init];
        _coinTextField.delegate = self;
        [_coinTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _coinTextField.placeholder = [NSString stringWithFormat:@"数量%@",_coinTradingMarketModel.coinname];
    }
    return _coinTextField;
}

- (UIButton *)operationButton
{
    if (_operationButton == nil) {
        _operationButton = [UIButton NNHBtnTitle:@"买入" titileFont:[UIConfigManager fontThemeLargerBtnTitles] backGround:[UIColor akext_colorWithHex:@"#2ba246"] titleColor:[UIColor whiteColor]];
        [_operationButton addTarget:self action:@selector(operationAction) forControlEvents:UIControlEventTouchUpInside];
        if (_coinTradingType != NNHCoinTradingOrderType_buyIn) {
            [_operationButton setTitle:@"卖出" forState:UIControlStateNormal];
            [_operationButton setBackgroundColor:[UIConfigManager colorThemeRed] forState:UIControlStateNormal];
        }
    }
    return _operationButton;
}

- (UILabel *)tradingAmountLabel
{
    if (_tradingAmountLabel == nil) {
        _tradingAmountLabel = [UILabel NNHWithTitle:@"0.00" titleColor:[UIConfigManager colorThemeDark] font:[UIConfigManager fontThemeTextMain]];
        _tradingAmountLabel.textAlignment = NSTextAlignmentRight;
    }
    return _tradingAmountLabel;
}

- (UILabel *)availableCnyLabel
{
    if (_availableCnyLabel == nil) {
        _availableCnyLabel = [UILabel NNHWithTitle:@"0.00" titleColor:[UIConfigManager colorThemeDark] font:[UIConfigManager fontThemeTextTip]];
    }
    _availableCnyLabel.text = _accountBalanceModel.unitcoinid;
    return _availableCnyLabel;
}

- (UILabel *)availableCoinLabel
{
    if (_availableCoinLabel == nil) {
        _availableCoinLabel = [UILabel NNHWithTitle:@"0.00" titleColor:[UIConfigManager colorThemeDark] font:[UIConfigManager fontThemeTextTip]];
    }
    _availableCoinLabel.text = _accountBalanceModel.coinid;
    return _availableCoinLabel;
}

- (NNCoinBuySellListView *)rightListView
{
    if (_rightListView == nil) {
        _rightListView = [[NNCoinBuySellListView alloc] initWithLeftUnit:_coinTradingMarketModel.unitcoinname rightUnit:_coinTradingMarketModel.coinname];
        NNHWeakSelf(self)
        _rightListView.selectedPriceBlock = ^(NSString *price) {
            weakself.priceTextfield.text = [price calculateByRounding:[weakself.coinTradingMarketModel.ccylot integerValue]];
            if (weakself.selectedNumButton) {
                [weakself calculateTradingAmount];
            }else{
                if (weakself.coinTextField.hasText) {
                    weakself.tradingAmountLabel.text = [weakself calculateWithStartValue:weakself.priceTextfield.text endValue:weakself.coinTextField.text];
                }                
            }
        };
    }
    return _rightListView;
}

- (dispatch_source_t)timer
{
    if (_timer == nil) { // 定时刷新
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 3.0 * NSEC_PER_SEC, 0);
        NNHWeakSelf(self)
        dispatch_source_set_event_handler(_timer, ^{
            [weakself requestRightDataSource];
            [weakself requestNewPrice];
        });
    }
    return _timer;
}

-(NNHEnterPasswordView *)enterView
{
    if (_enterView == nil) {
        _enterView = [[NNHEnterPasswordView alloc] init];
        NNHWeakSelf(self)
        _enterView.didEnterCodeBlock = ^(NSString *password){
            [weakself inputPayCode:password];
        };
    }
    return _enterView;
}

@end
