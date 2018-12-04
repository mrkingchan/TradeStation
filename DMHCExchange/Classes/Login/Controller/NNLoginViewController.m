//
//  NNHLoginViewController.m
//  SuperWallet
//
//  Created by 牛牛 on 2018/3/6.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import "NNLoginViewController.h"
#import "NNRegisterViewController.h"
#import "NNForgotPasswordViewController.h"
#import "NNLoginSecurityVerifyViewController.h"
#import "NNHLoginTextField.h"
#import "NNHApiLoginTool.h"
#import "NNHAlertTool.h"
#import "NNNavigationController.h"

@interface NNLoginViewController ()

/** 电话号码 */
@property (nonatomic, strong) NNHLoginTextField *phoneTextFiled;
/** 密码 */
@property (nonatomic, strong) NNHLoginTextField *passwordTextFiled;
/** 登录按钮 */
@property (nonatomic, strong) UIButton *loginButton;
/** 返回按钮 */
@property (nonatomic, strong) UIButton *backButton;
/** 忘记密码按钮 */
@property (nonatomic, strong) UIButton *missCodeButton;
/** 注册 */
@property (nonatomic, strong) UIButton *registerButton;

@end

/** 跳出VC **/
static BOOL  isClick = YES;
@implementation NNLoginViewController

#pragma mark -
#pragma mark ---------Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupChildView];
}

/** 添加子控件 */
- (void)setupChildView
{
    [self.view addSubview:self.backButton];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-NNHMargin_10);
        make.top.equalTo(self.view).offset(STATUSBAR_HEIGHT);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    
    CGFloat marginX = 42;
    UILabel *titleLabel = [UILabel NNHWithTitle:@"登录" titleColor:[UIConfigManager colorThemeDark] font:[UIFont boldSystemFontOfSize:34]];
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backButton.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(marginX);
    }];
    
    [self.view addSubview:self.phoneTextFiled];
    [self.phoneTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(110);
        make.height.equalTo(@(NNHNormalViewH));
        make.width.equalTo(@(SCREEN_WIDTH - marginX * 2));
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [self.view addSubview:self.passwordTextFiled];
    [self.passwordTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneTextFiled.mas_bottom).offset(15);
        make.centerX.equalTo(self.phoneTextFiled);
        make.size.equalTo(self.phoneTextFiled);
    }];
    
    [self.view addSubview:self.loginButton];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordTextFiled.mas_bottom).offset(50);
        make.centerX.equalTo(self.phoneTextFiled);
        make.size.equalTo(self.phoneTextFiled);
    }];
    
    [self.view addSubview:self.missCodeButton];
    [self.missCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginButton.mas_bottom);
        make.right.equalTo(self.phoneTextFiled).offset(-10);
        make.height.equalTo(@(50));
    }];
    [self.view addSubview:self.registerButton];
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.missCodeButton);
        make.left.equalTo(self.phoneTextFiled).offset(10);
        make.height.equalTo(@(50));
    }];
}

#pragma mark -
#pragma mark ---------私有方法
- (void)loginButtonClick:(UIButton *)button
{
    NNHApiLoginTool *loginTool = [[NNHApiLoginTool alloc] initLoginWithUserName:self.phoneTextFiled.text password:self.passwordTextFiled.text];
    NNHWeakSelf(self)
    [SVProgressHUD nn_showWithStatus:@"登录中"];
    [loginTool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
        NNHStrongSelf(self)
        [SVProgressHUD dismissWithDelay:0.5 completion:^{
            NNLoginSecurityVerifyViewController *vc = [[NNLoginSecurityVerifyViewController alloc] init];
            vc.username = responseDic[@"data"][@"username"];
            vc.cryptcode = responseDic[@"data"][@"cryptcode"];
            vc.verifySuccessBlock = ^{
                if (strongself.loginSuccessBlock) {
                    strongself.loginSuccessBlock();
                }
            };
            [strongself.navigationController pushViewController:vc animated:YES];
        }];
        
    } failBlock:^(NNHRequestError *error) {
        
    } isCached:NO];
}

- (void)missCodeButtonClick
{
    NNHWeakSelf(self)
    [[NNHAlertTool shareAlertTool] showActionSheet:self title:nil message:@"找回密码" acttionTitleArray:@[@"通过手机找回",@"通过邮箱找回"] confirm:^(NSInteger index) {
        
        if (index == 0) {
            NNForgotPasswordViewController *vc = [[NNForgotPasswordViewController alloc] initWithSecurityVerifyType:NNSecurityVerifyTypePhone];
            [weakself.navigationController pushViewController:vc animated:YES];
        }else {
            NNForgotPasswordViewController *vc = [[NNForgotPasswordViewController alloc] initWithSecurityVerifyType:NNSecurityVerifyTypeEmail];
            [weakself.navigationController pushViewController:vc animated:YES];
        }

    } cancle:^{
        
    }];
}

- (void)registerButtonClick
{
    NNRegisterViewController *vc = [[NNRegisterViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
#pragma mark ---------UITextFieldDelegate
- (void)textFieldDidChange:(NNHLoginTextField *)textField
{
    self.loginButton.enabled = self.phoneTextFiled.hasText && self.passwordTextFiled.hasText;
}

#pragma mark -----------PrivateMethods
+ (instancetype)presentInViewController:(UIViewController *)vc completion:(completionBlock)block;
{
    if (isClick) {
        isClick = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            isClick = YES;
        });
        NNLoginViewController *log = [[NNLoginViewController alloc]init];
        NNNavigationController *nav = [[NNNavigationController alloc] initWithRootViewController:log];
        log.loginSuccessBlock = block;
        [vc presentViewController:nav animated:YES completion:nil];
        return log;
    }
    return nil;
}

- (void)dismissVC
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark ---------getter && setter
- (NNHLoginTextField *)phoneTextFiled
{
    if (_phoneTextFiled == nil) {
        _phoneTextFiled = [[NNHLoginTextField alloc] init];
        _phoneTextFiled.placeholder = @"请输入邮箱/手机账号";
        _phoneTextFiled.keyboardType = UIKeyboardTypeASCIICapable;
        [_phoneTextFiled addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _phoneTextFiled;
}

- (NNHLoginTextField *)passwordTextFiled
{
    if (_passwordTextFiled == nil) {
        _passwordTextFiled = [[NNHLoginTextField alloc] init];
        _passwordTextFiled.placeholder = @"请输入密码";
        _passwordTextFiled.showSecureButotn = YES;
        _passwordTextFiled.keyboardType = UIKeyboardTypeASCIICapable;
        _passwordTextFiled.nn_maxLength = 16;
        [_passwordTextFiled addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _passwordTextFiled;
}

- (UIButton *)loginButton
{
    if (_loginButton == nil) {
        _loginButton = [UIButton NNHOperationBtnWithTitle:@"立即登录" target:self action:@selector(loginButtonClick:) operationButtonType:NNHOperationButtonTypeRed isAddCornerRadius:YES];
        _loginButton.enabled = NO;
    }
    return _loginButton;
}

- (UIButton *)backButton
{
    if (_backButton == nil) {
        _backButton = [UIButton NNHBtnImage:@"ic_nav_close" target:self action:@selector(dismissVC)];
    }
    return _backButton;
}

- (UIButton *)missCodeButton
{
    if (_missCodeButton == nil) {
        _missCodeButton = [UIButton NNHBtnTitle:@"忘记密码" titileFont:[UIConfigManager fontThemeTextDefault] backGround:[UIColor whiteColor] titleColor:[UIConfigManager colorThemeRed]];
        [_missCodeButton addTarget:self action:@selector(missCodeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _missCodeButton.adjustsImageWhenHighlighted = NO;
    }
    return _missCodeButton;
}

- (UIButton *)registerButton
{
    if (_registerButton == nil) {
        _registerButton = [UIButton NNHBtnTitle:@"新用户注册" titileFont:[UIConfigManager fontThemeTextDefault] backGround:[UIColor whiteColor] titleColor:[UIConfigManager colorThemeRed]];
        [_registerButton addTarget:self action:@selector(registerButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _registerButton.adjustsImageWhenHighlighted = NO;
    }
    return _registerButton;
}

@end
