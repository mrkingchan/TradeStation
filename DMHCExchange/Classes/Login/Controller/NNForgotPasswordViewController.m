//
//  NNForgotPasswordViewController.m
//  DMHCExchange
//
//  Created by 牛牛 on 2018/10/25.
//  Copyright © 2018年 超级钱包. All rights reserved.
//

#import "NNForgotPasswordViewController.h"
#import "NNHLoginTextField.h"
#import "NNCountDownButton.h"
#import "NNHApiLoginTool.h"
#import "NNHApiSecurityTool.h"
#import "NNRegisterAreaView.h"
#import "NNHCountryCodeModel.h"

@interface NNForgotPasswordViewController ()<UITextFieldDelegate, UIScrollViewDelegate>

/** 电话号码 */
@property (nonatomic, strong) NNHLoginTextField *phoneTextFiled;
/** 密码 */
@property (nonatomic, strong) NNHLoginTextField *passwordTextFiled;
/** 密码 */
@property (nonatomic, strong) NNHLoginTextField *surePasswordTextFiled;
/** 验证码 */
@property (nonatomic, strong) NNHLoginTextField *codeTextField;
/** 确认按钮 */
@property (nonatomic, strong) UIButton *sureButton;
/** 获取验证码按钮 */
@property (nonatomic, strong) NNCountDownButton *codeButton;
/** 找回方式 */
@property (nonatomic, assign) NNSecurityVerifyType securityVerifyType;

@end

@implementation NNForgotPasswordViewController

#pragma mark -
#pragma mark ---------Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupChildView];
}

- (instancetype)initWithSecurityVerifyType:(NNSecurityVerifyType)type
{
    if (self = [super init]) {
        _securityVerifyType = type;
    }
    return self;
}

/** 添加子控件 */
- (void)setupChildView
{
    UIButton *backButton = [UIButton NNHBtnImage:@"ic_nav_back" target:self action:@selector(popVCAction)];
    [self.view addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view).offset(STATUSBAR_HEIGHT);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    
    CGFloat marginX = 42;
    UILabel *titleLabel = [UILabel NNHWithTitle:self.securityVerifyType == NNSecurityVerifyTypePhone ? @"手机找回" : @"邮箱找回" titleColor:[UIConfigManager colorThemeDark] font:[UIFont boldSystemFontOfSize:34]];
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backButton.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(marginX);
    }];
    
    UIScrollView *contentView = [[UIScrollView alloc] init];
    contentView.delegate = self;
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(50);
        make.left.bottom.right.equalTo(self.view);
    }];
    
    CGFloat textFieldH = 50.0;
    [contentView addSubview:self.phoneTextFiled];
    [self.phoneTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.width.equalTo(@(SCREEN_WIDTH - marginX * 2));
        make.height.equalTo(@(textFieldH));
        make.centerX.equalTo(contentView);
    }];
    
    [contentView addSubview:self.codeTextField];
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneTextFiled.mas_bottom);
        make.size.equalTo(self.phoneTextFiled);
        make.centerX.equalTo(contentView);
    }];
    
    [self.codeTextField addSubview:self.codeButton];
    [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.codeTextField);
        make.right.equalTo(self.codeTextField);
        make.width.equalTo(@100);
        make.height.equalTo(@35);
    }];
    
    [contentView addSubview:self.passwordTextFiled];
    [self.passwordTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeTextField.mas_bottom);
        make.centerX.equalTo(contentView);
        make.size.equalTo(self.phoneTextFiled);
    }];
    
    [contentView addSubview:self.surePasswordTextFiled];
    [self.surePasswordTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordTextFiled.mas_bottom);
        make.centerX.equalTo(contentView);
        make.size.equalTo(self.phoneTextFiled);
    }];
    
    [contentView addSubview:self.sureButton];
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.surePasswordTextFiled.mas_bottom).offset(20);
        make.centerX.equalTo(self.phoneTextFiled);
        make.size.equalTo(self.phoneTextFiled);
        make.bottom.equalTo(contentView).offset(-50);
    }];
}

- (void)sureRetrievePasswordAction
{
    NNHApiSecurityTool *tool = [[NNHApiSecurityTool alloc] initForgotPasswordWithVerifyType:self.securityVerifyType username:self.phoneTextFiled.text valicode:self.codeTextField.text loginpwd:self.passwordTextFiled.text confirmpwd:self.surePasswordTextFiled.text];
    NNHWeakSelf(self)
    [SVProgressHUD nn_showWithStatus:@"提交中"];
    [tool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
        
        [SVProgressHUD showMessage:@"操作成功"];
        [weakself.navigationController popViewControllerAnimated:YES];

    } failBlock:^(NNHRequestError *error) {

    } isCached:NO];
}

- (void)popVCAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark ---------UITextFieldDelegate
- (void)textFieldDidChange:(NNHLoginTextField *)textField
{
    if (self.securityVerifyType == NNSecurityVerifyTypePhone) {
        self.codeButton.enabled = self.phoneTextFiled.text.length >= NNHMinPhoneLength && self.codeButton.curSec == 60;
        self.sureButton.enabled = self.phoneTextFiled.text.length >= NNHMinPhoneLength && self.codeTextField.hasText && self.passwordTextFiled.text.length >= 6 && self.surePasswordTextFiled.text.length >= 6;
    }else {
        self.codeButton.enabled = self.phoneTextFiled.hasText && self.codeButton.curSec == 60;
        self.sureButton.enabled = self.phoneTextFiled.hasText && self.codeTextField.hasText && self.passwordTextFiled.text.length >= 6 && self.surePasswordTextFiled.text.length >= 6;
    }
}

#pragma mark -
#pragma mark ---------getter && setter
- (NNHLoginTextField *)phoneTextFiled
{
    if (_phoneTextFiled == nil) {
        _phoneTextFiled = [[NNHLoginTextField alloc] init];
        [_phoneTextFiled addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        if (_securityVerifyType == NNSecurityVerifyTypePhone) {
            _phoneTextFiled.placeholder = @"请输入手机账号";
            _phoneTextFiled.keyboardType = UIKeyboardTypeNumberPad;
            _phoneTextFiled.nn_maxLength = 12;
        }else{
            _phoneTextFiled.placeholder = @"请输入邮箱账号";
            _phoneTextFiled.keyboardType = UIKeyboardTypeEmailAddress;
        }
    }
    return _phoneTextFiled;
}

- (NNHLoginTextField *)codeTextField
{
    if (_codeTextField == nil) {
        _codeTextField = [[NNHLoginTextField alloc] init];
        _codeTextField.placeholder = @"请输入验证码";
        [_codeTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _codeTextField.keyboardType = UIKeyboardTypeNumberPad;
        _codeTextField.nn_maxLength = 6;
    }
    return _codeTextField;
}

- (NNHLoginTextField *)passwordTextFiled
{
    if (_passwordTextFiled == nil) {
        _passwordTextFiled = [[NNHLoginTextField alloc] init];
        _passwordTextFiled.placeholder = @"请输入密码";
        _passwordTextFiled.showSecureButotn = YES;
        [_passwordTextFiled addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _passwordTextFiled.keyboardType = UIKeyboardTypeASCIICapable;
        _passwordTextFiled.nn_maxLength = 16;
    }
    return _passwordTextFiled;
}

- (NNHLoginTextField *)surePasswordTextFiled
{
    if (_surePasswordTextFiled == nil) {
        _surePasswordTextFiled = [[NNHLoginTextField alloc] init];
        _surePasswordTextFiled.placeholder = @"请再次输入密码";
        _surePasswordTextFiled.showSecureButotn = YES;
        [_surePasswordTextFiled addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _surePasswordTextFiled.keyboardType = UIKeyboardTypeASCIICapable;
        _surePasswordTextFiled.nn_maxLength = 16;
    }
    return _surePasswordTextFiled;
}

- (UIButton *)sureButton
{
    if (_sureButton == nil) {
        _sureButton = [UIButton NNHOperationBtnWithTitle:@"确认" target:self action:@selector(sureRetrievePasswordAction) operationButtonType:NNHOperationButtonTypeRed isAddCornerRadius:YES];
        _sureButton.enabled = NO;
    }
    return _sureButton;
}

- (NNCountDownButton *)codeButton
{
    if (_codeButton == nil) {
        NNHWeakSelf(self)
        _codeButton = [[NNCountDownButton alloc] initWithTotalTime:60 titleBefre:@"获取验证码" titleConting:@"s" titleAfterCounting:@"获取验证码" clickAction:^(NNCountDownButton *countBtn) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NNHStrongSelf(self)
                NNHApiSecurityTool *tool = [[NNHApiSecurityTool alloc] initWithMobile:strongself.phoneTextFiled.text verifyCodeType:NNHSendVerificationCodeType_userForgetpwd countryCode:nil verifyType:strongself.securityVerifyType];
                [tool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
                    [countBtn startCounting];
                    [SVProgressHUD showMessage:@"获取验证码成功 请注意查收"];
                } failBlock:^(NNHRequestError *error) {
                    [countBtn resetButton];
                } isCached:NO];
            });
        }];
        _codeButton.enabled = NO;
    }
    return _codeButton;
}

@end
