//
//  NNHWalletCoinWithdrawViewController.m
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/24.
//  Copyright © 2018 超级钱包. All rights reserved.
//

#import "NNHWalletCoinWithdrawViewController.h"
#import "NNWalletCoinWithdrawTotalCountView.h"

#import "NNHScanCodeController.h"
#import "NNHApiWalletTool.h"
#import "UITextField+NNHExtension.h"
#import "NNCountDownButton.h"
#import "NNHApiSecurityTool.h"
#import "NNWalletCoinWithdrawModel.h"
#import "NNHEnterPasswordView.h"
#import "NNUserModel.h"
#import "NNHAlertTool.h"
#import "NNHDecimalsTextField.h"

@interface NNHWalletCoinWithdrawViewController ()<UITextFieldDelegate>

/** scrollView */
@property (nonatomic, strong) UIScrollView *scrollView;
/** 可用数量 */
@property (nonatomic, strong) NNWalletCoinWithdrawTotalCountView *totaCountView;
/** 提币地址view */
@property (nonatomic, strong) UIView *addressView;
/** 填写提币地址 */
@property (nonatomic, strong) UITextField *addressField;
/** 提币数量 */
@property (nonatomic, strong) UIView *countView;
/** 填写提币数量 */
@property (nonatomic, strong) NNHDecimalsTextField *countField;
/** 标签 */
@property (nonatomic, strong) UIView *remarkView;
/** 填写标签 */
@property (nonatomic, strong) UITextField *remarkTextField;
/** 手续费view */
@property (nonatomic, strong) UIView *feeView;
/** 手续费label */
@property (nonatomic, strong) UILabel *feeLabel;
/** 资金密码view */
@property (nonatomic, strong) UIView *payCodeView;
/** 资金密码输入框 */
@property (nonatomic, strong) UITextField *payCodeTextField;
/** 短信view */
@property (nonatomic, strong) UIView *messageView;
/** 短信验证码 */
@property (nonatomic, strong) UITextField *codeField;
/** 验证码按钮 */
@property (nonatomic, strong) NNCountDownButton *codeButton;
/** 确认按钮 */
@property (nonatomic, strong) UIButton *ensureButton;
/** 币种id */
@property (nonatomic, copy) NSString *coinID;
/** 币种名称 */
@property (nonatomic, copy) NSString *coinName;
/** 提现模型 */
@property (nonatomic, strong) NNWalletCoinWithdrawModel *withdrawModel;
/** 底部信息 */
@property (nonatomic, strong) UILabel *messageLabel;

@end

@implementation NNHWalletCoinWithdrawViewController

#pragma mark - Life Cycle Methods
- (instancetype)initWithCoinID:(NSString *)coinID
                      coinName:(NSString *)coinName
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
    
    self.view.backgroundColor = [UIConfigManager colorThemeColorForVCBackground];
    self.navigationItem.title = [NSString stringWithFormat:@"转出%@",self.coinName];
    
    [self setupChildView];
    [self requestCoinWithdrawInfo];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - Initial Methods
- (void)setupChildView
{
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.scrollView addSubview:self.totaCountView];
    [self.totaCountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
        make.top.equalTo(self.scrollView).offset(NNHMargin_10);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@(NNHNormalViewH * 2));
    }];
    
    [self.scrollView addSubview:self.addressView];
    [self.addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.top.equalTo(self.totaCountView.mas_bottom).offset(NNHMargin_10);
        make.height.equalTo(@(NNHNormalViewH));
    }];
    
    [self.scrollView addSubview:self.remarkView];
    [self.remarkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.top.equalTo(self.addressView.mas_bottom).offset(NNHLineH);
        make.height.equalTo(@(NNHNormalViewH));
    }];
    
    [self.scrollView addSubview:self.countView];
    [self.countView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.top.equalTo(self.remarkView.mas_bottom).offset(NNHLineH);
        make.height.equalTo(@(NNHNormalViewH));
    }];
    
    [self.scrollView addSubview:self.feeView];
    [self.feeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
        make.top.equalTo(self.countView.mas_bottom).offset(NNHLineH);
        make.height.equalTo(@(NNHNormalViewH));
        make.width.equalTo(@(SCREEN_WIDTH));
    }];
    
    [self.scrollView addSubview:self.payCodeView];
    [self.payCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
        make.top.equalTo(self.feeView.mas_bottom).offset(NNHMargin_10);
        make.height.equalTo(@(NNHNormalViewH));
        make.width.equalTo(@(SCREEN_WIDTH));
    }];
    
    [self.scrollView addSubview:self.messageView];
    [self.messageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
        make.top.equalTo(self.payCodeView.mas_bottom).offset(NNHLineH);
        make.height.equalTo(@(NNHNormalViewH));
        make.width.equalTo(@(SCREEN_WIDTH));
    }];
    
    [self.scrollView addSubview:self.ensureButton];
    [self.ensureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView).offset(NNHMargin_15);
        make.width.equalTo(@(SCREEN_WIDTH - 30));
        make.top.equalTo(self.messageView.mas_bottom).offset(60);
        make.height.equalTo(@(NNHNormalViewH));
    }];
    
    [self.scrollView addSubview:self.messageLabel];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView).offset(NNHMargin_15);
        make.top.equalTo(self.ensureButton.mas_bottom).offset(NNHNormalViewH);
        make.width.equalTo(@(SCREEN_WIDTH - 30));
        make.bottom.equalTo(@(NNHNormalViewH));
    }];

}

#pragma mark - Network Methods

- (void)requestCoinWithdrawInfo
{
    NNHWeakSelf(self)
    NNHApiWalletTool *networkTool = [[NNHApiWalletTool alloc] initWithCoinWithdrawDataWithCoinID:self.coinID];
    [networkTool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
        [weakself handleCoinData:responseDic];
    } failBlock:^(NNHRequestError *error) {

    } isCached:NO];
}

- (void)handleCoinData:(NSDictionary *)responseDic
{
    self.withdrawModel = [NNWalletCoinWithdrawModel mj_objectWithKeyValues:responseDic[@"data"]];
    [self.totaCountView configCoinName:self.withdrawModel.coinname count:self.withdrawModel.total];
    self.feeLabel.text = self.withdrawModel.fee;
    self.messageLabel.text = self.withdrawModel.desc;
    [self.messageLabel nnh_addLineSpaceWithLineSpace:5];
    if (self.withdrawModel.warning.length) {
        [[NNHAlertTool shareAlertTool] showAlertView:self title:self.withdrawModel.warning message:nil cancelButtonTitle:nil otherButtonTitle:@"确定" confirm:^{
            
        } cancle:^{
            
        }];
    }
}

#pragma mark - Target Methods
/** 扫描输入地址 */
- (void)scanButtonAction
{
    NNHScanCodeController *scanVc = [[NNHScanCodeController alloc] init];
    [self.navigationController pushViewController:scanVc animated:YES];
    NNHWeakSelf(self)
    scanVc.getQrCodeBlock = ^(NSString *code) {
        weakself.addressField.text = code;
    };
}

/** 点击确认按钮 */
- (void)clickEnsureButton:(UIButton *)button
{
    if ([self.withdrawModel.cointype isEqualToString:@"4"] && !self.remarkTextField.hasText) {
        [SVProgressHUD showMessage:@"请输入标签信息"];
        return;
    }
    
    if (![[NNHApplicationHelper sharedInstance] isSetupPayPassword]) return;
    
    [SVProgressHUD show];
    NNHWeakSelf(self)
    NNHApiWalletTool *networkTool = [[NNHApiWalletTool alloc] initWithCoinWithdrawActionWithCoinID:self.coinID num:self.countField.text paypassword:self.payCodeTextField.text moble_verify:self.codeField.text address:self.addressField.text memo:self.remarkTextField.text];
    [networkTool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
        [SVProgressHUD showMessage:@"提现成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakself.navigationController popViewControllerAnimated:YES];
        });
    } failBlock:^(NNHRequestError *error) {
    } isCached:NO];
}

#pragma mark - Private Methods
- (void)textFieldDidChange:(UITextField *)textField
{
    self.ensureButton.enabled = self.addressField.hasText && self.countField.hasText && self.codeField.hasText;
}

#pragma mark - Lazy Loads

- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView .showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.backgroundColor = [UIConfigManager colorThemeColorForVCBackground];
    }
    return _scrollView;
}

- (NNWalletCoinWithdrawTotalCountView *)totaCountView
{
    if (_totaCountView== nil) {
        _totaCountView = [[NNWalletCoinWithdrawTotalCountView alloc] init];
    }
    return _totaCountView;
}

- (UIView *)addressView
{
    if (_addressView == nil) {
        _addressView = [[UIView alloc] init];
        _addressView.backgroundColor = [UIConfigManager colorThemeWhite];
        UILabel *titleLabel = [UILabel NNHWithTitle:@"地址" titleColor:[UIConfigManager colorThemeBlack] font:[UIConfigManager fontThemeTextDefault]];
        [_addressView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_addressView).offset(NNHMargin_15);
            make.centerY.equalTo(_addressView);
        }];
        
        [_addressView addSubview:self.addressField];
        [self.addressField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_addressView).offset(60);
            make.centerY.equalTo(_addressView);
            make.width.equalTo(@(SCREEN_WIDTH - 100));
        }];
        
        UIButton *scanButton = [UIButton NNHBtnImage:@"ic_scan" target:self action:@selector(scanButtonAction)];
        [_addressView addSubview:scanButton];
        [scanButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(_addressView);
            make.width.equalTo(@(NNHNormalViewH));
        }];
    }
    return _addressView;
}

- (UITextField *)addressField
{
    if (_addressField == nil) {
        _addressField = [[UITextField alloc] init];
        _addressField.font = [UIConfigManager fontThemeTextDefault];
        _addressField.placeholder = @"请选择提资产地址或扫描录入";
        [_addressField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _addressField;
}

- (UIView *)remarkView
{
    if (_remarkView == nil) {
        _remarkView = [[UIView alloc] init];
        _remarkView.backgroundColor = [UIConfigManager colorThemeWhite];
        
        UILabel *titleLabel = [UILabel NNHWithTitle:@"标签" titleColor:[UIConfigManager colorThemeBlack] font:[UIConfigManager fontThemeTextDefault]];
        [_remarkView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_remarkView).offset(NNHMargin_15);
            make.centerY.equalTo(_remarkView);
        }];

        [_remarkView addSubview:self.remarkTextField];
        [self.remarkTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_remarkView).offset(60);
            make.centerY.equalTo(_remarkView);
            make.width.equalTo(@(SCREEN_WIDTH - 100));
        }];
    }
    return _remarkView;
}

- (UITextField *)remarkTextField
{
    if (_remarkTextField == nil) {
        _remarkTextField = [[UITextField alloc] init];
        _remarkTextField.font = [UIConfigManager fontThemeTextDefault];
        _remarkTextField.placeholder = @"请输入标签";
        _remarkTextField.delegate = self;
        [_remarkTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _remarkTextField;
}


- (UIView *)countView
{
    if (_countView == nil) {
        _countView = [[UIView alloc] init];
        _countView.backgroundColor = [UIConfigManager colorThemeWhite];
        
        UILabel *titleLabel = [UILabel NNHWithTitle:@"数量" titleColor:[UIConfigManager colorThemeBlack] font:[UIConfigManager fontThemeTextDefault]];
        [_countView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_countView).offset(NNHMargin_15);
            make.centerY.equalTo(_countView);
        }];
        
        [_countView addSubview:self.countField];
        [self.countField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_countView).offset(60);
            make.centerY.equalTo(_countView);
            make.width.equalTo(@(SCREEN_WIDTH - 100));
        }];
    }
    return _countView;
}

- (NNHDecimalsTextField *)countField
{
    if (_countField == nil) {
        _countField = [[NNHDecimalsTextField alloc] init];
        _countField.font = [UIConfigManager fontThemeTextDefault];
        _countField.placeholder = @"请输入提币数量";
        _countField.keyboardType = UIKeyboardTypeDecimalPad;
        [_countField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _countField.afterPlacesCount = 8;
    }
    return _countField;
}

- (UIView *)feeView
{
    if (_feeView == nil) {
        _feeView = [[UIView alloc] init];
        _feeView.backgroundColor = [UIConfigManager colorThemeWhite];
        
        UILabel *titleLabel = [UILabel NNHWithTitle:@"手续费：" titleColor:[UIConfigManager colorThemeBlack] font:[UIConfigManager fontThemeTextDefault]];
        [_feeView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_feeView).offset(NNHMargin_15);
            make.centerY.equalTo(_feeView);
        }];
        
        [_feeView addSubview:self.feeLabel];
        [self.feeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel.mas_right);
            make.centerY.equalTo(_feeView);
        }];
    }
    return _feeView;
}

- (UILabel *)feeLabel
{
    if (_feeLabel == nil) {
        _feeLabel = [UILabel NNHWithTitle:@"0.00" titleColor:[UIConfigManager colorThemeBlack] font:[UIConfigManager fontThemeTextDefault]];
    }
    return _feeLabel;
}

- (UIView *)payCodeView
{
    if (_payCodeView == nil) {
        _payCodeView = [[UIView alloc] init];
        _payCodeView.backgroundColor = [UIConfigManager colorThemeWhite];
        
        UILabel *titleLabel = [UILabel NNHWithTitle:@"资金密码" titleColor:[UIConfigManager colorThemeBlack] font:[UIConfigManager fontThemeTextDefault]];
        [_payCodeView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_payCodeView).offset(NNHMargin_15);
            make.top.equalTo(_payCodeView);
            make.height.equalTo(@(NNHNormalViewH));
        }];
        
        [_payCodeView addSubview:self.payCodeTextField];
        [self.payCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_payCodeView).offset(100);
            make.centerY.equalTo(_payCodeView);
            make.width.equalTo(@(SCREEN_WIDTH - 180));
        }];
    }
    return _payCodeView;
}

- (UITextField *)payCodeTextField
{
    if (_payCodeTextField == nil) {
        _payCodeTextField = [[UITextField alloc] init];
        _payCodeTextField.font = [UIConfigManager fontThemeTextDefault];
        _payCodeTextField.placeholder = @"请输入资金密码";
        _payCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
        [_payCodeTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _payCodeTextField.secureTextEntry = YES;
        _payCodeTextField.nn_maxLength = 6;
    }
    return _payCodeTextField;
}

- (UIView *)messageView
{
    if (_messageView == nil) {
        _messageView = [[UIView alloc] init];
        _messageView.backgroundColor = [UIConfigManager colorThemeWhite];
        
        UILabel *titleLabel = [UILabel NNHWithTitle:@"短信验证码" titleColor:[UIConfigManager colorThemeBlack] font:[UIConfigManager fontThemeTextDefault]];
        [_messageView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_messageView).offset(NNHMargin_15);
            make.top.equalTo(_messageView);
            make.height.equalTo(@(NNHNormalViewH));
        }];
        
        [_messageView addSubview:self.codeButton];
        [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_messageView).offset(-NNHMargin_15);
            make.centerY.equalTo(_messageView);
            make.height.equalTo(@(30));
            make.width.equalTo(@80);
        }];
        
        [_messageView addSubview:self.codeField];
        [self.codeField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_messageView).offset(100);
            make.centerY.equalTo(_messageView);
            make.width.equalTo(@(SCREEN_WIDTH - 180));
        }];
    }
    return _messageView;
}

- (UITextField *)codeField
{
    if (_codeField == nil) {
        _codeField = [[UITextField alloc] init];
        _codeField.font = [UIConfigManager fontThemeTextDefault];
        _codeField.placeholder = @"请输入验证码";
        _codeField.keyboardType = UIKeyboardTypeNumberPad;
        [_codeField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _codeField.nn_maxLength = 6;
    }
    return _codeField;
}

/** 获取验证码按钮 */
- (NNCountDownButton *)codeButton
{
    if (_codeButton == nil) {
        
        NNUserModel *userModel = [NNHProjectControlCenter sharedControlCenter].userControl_currentUserModel;
        _codeButton = [[NNCountDownButton alloc] initWithTotalTime:60 titleBefre:@"获取验证码" titleConting:@"s" titleAfterCounting:@"获取验证码" clickAction:^(NNCountDownButton *countBtn) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                NNHApiSecurityTool *apiTool = [[NNHApiSecurityTool alloc] initWithMobile:userModel.completemobile verifyCodeType:NNHSendVerificationCodeType_withdrawCoin countryCode:nil verifyType:NNSecurityVerifyTypePhone];
                
                [apiTool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
                    [countBtn startCounting];
                    [SVProgressHUD showMessage:@"获取验证码成功 请注意查收"];
                } failBlock:^(NNHRequestError *error) {
                    [countBtn resetButton];
                } isCached:NO];
            });
        }];
        
        [_codeButton setBackgroundColor:[UIConfigManager colorThemeRed] forState:UIControlStateNormal];
        _codeButton.lbNormalColor = [UIConfigManager colorThemeWhite];
        
    }
    return _codeButton;
}

- (UILabel *)messageLabel
{
    if (_messageLabel == nil) {
        _messageLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorThemeDarkGray] font:[UIConfigManager fontThemeTextTip]];
        _messageLabel.numberOfLines = 0;
    }
    return _messageLabel;
}

- (UIButton *)ensureButton
{
    if (_ensureButton == nil) {
        _ensureButton = [UIButton NNHOperationBtnWithTitle:@"确定提币" target:self action:@selector(clickEnsureButton:) operationButtonType:NNHOperationButtonTypeRed isAddCornerRadius:YES];
        _ensureButton.nn_acceptEventInterval = NNHAcceptEventInterval;
        _ensureButton.enabled = NO;
    }
    return _ensureButton;
}


@end
