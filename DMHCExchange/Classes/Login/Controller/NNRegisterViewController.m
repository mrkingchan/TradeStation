//
//  NNRegisterViewController.m
//  SuperWallet
//
//  Created by 牛牛 on 2018/3/16.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import "NNRegisterViewController.h"
#import "NNHLoginTextField.h"
#import "UILabel+NNHAttributeTextTapAction.h"
#import "NNWebViewController.h"
#import "NNCountDownButton.h"
#import "NNHApiLoginTool.h"
#import "NNHApiSecurityTool.h"
#import "UIButton+NNImagePosition.h"
#import "NNRegisterAreaView.h"
#import "NNHCountryCodeModel.h"

@interface NNRegisterViewController ()<UITextFieldDelegate, UIScrollViewDelegate>

/** 注册标题 */
@property (nonatomic, strong) UILabel *titleLabel;
/** 切换标题 */
@property (nonatomic, strong) UIButton *changeRegisterButton;
/** 选择国家 */
@property (nonatomic, strong) NNHLoginTextField *areaTextFiled;
/** 电话号码 */
@property (nonatomic, strong) NNHLoginTextField *phoneTextFiled;
/** 邀请人 */
@property (nonatomic, strong) NNHLoginTextField *inviteTextField;
/** 密码 */
@property (nonatomic, strong) NNHLoginTextField *passwordTextFiled;
/** 密码 */
@property (nonatomic, strong) NNHLoginTextField *surePasswordTextFiled;
/** 验证码 */
@property (nonatomic, strong) NNHLoginTextField *codeTextField;
/** 登录按钮 */
@property (nonatomic, strong) UIButton *registerButton;
/** 获取验证码按钮 */
@property (nonatomic, strong) NNCountDownButton *codeButton;
/** 注册协议label */
@property (nonatomic, strong) UILabel *tipLabel;
/** 同意注册协议label */
@property (nonatomic, strong) UIButton *agreeButton;
/** 返回按钮 */
@property (nonatomic, strong) UIButton *backButton;
/** 区域view */
@property (nonatomic, weak) UILabel *areaLabel;
@property (nonatomic, strong) NNRegisterAreaView *areaMenu;
/** 下拉框是否打开 */
@property (nonatomic, assign) BOOL openFlag;

@end

@implementation NNRegisterViewController

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
    
    [self requestCodeData];
    [self setupChildView];
}

- (void)setupChildView {
    [self.view addSubview:self.backButton];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view).offset(STATUSBAR_HEIGHT);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    
    CGFloat marginX = 42;
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backButton.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(marginX);
    }];
    
    UILabel *huoLabel = [UILabel NNHWithTitle:@"或" titleColor:[UIConfigManager colorThemeDarkGray] font:[UIConfigManager fontThemeLargerBtnTitles]];
    [self.view addSubview:huoLabel];
    [huoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.baseline.equalTo(self.titleLabel);
        make.left.equalTo(self.titleLabel.mas_right).offset(10);
    }];
    
    [self.view addSubview:self.changeRegisterButton];
    [self.changeRegisterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.baseline.equalTo(self.titleLabel);
        make.left.equalTo(huoLabel.mas_right).offset(10);
    }];
    
    UIScrollView *contentView = [[UIScrollView alloc] init];
    contentView.delegate = self;
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(50);
        make.left.bottom.right.equalTo(self.view);
    }];
    
    [contentView addSubview:self.areaTextFiled];
    [self.areaTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.centerX.equalTo(contentView);
        make.height.equalTo(@0);
        make.width.equalTo(@(SCREEN_WIDTH - marginX * 2));
    }];
    
    [contentView addSubview:self.phoneTextFiled];
    [self.phoneTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.areaTextFiled.mas_bottom);
        make.height.equalTo(@50);
        make.width.equalTo(self.areaTextFiled);
        make.centerX.equalTo(contentView);
    }];
    
    [contentView addSubview:self.passwordTextFiled];
    [self.passwordTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneTextFiled.mas_bottom);
        make.centerX.equalTo(contentView);
        make.size.equalTo(self.phoneTextFiled);
    }];
    
    [contentView addSubview:self.surePasswordTextFiled];
    [self.surePasswordTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordTextFiled.mas_bottom);
        make.centerX.equalTo(contentView);
        make.size.equalTo(self.phoneTextFiled);
    }];
    
    [contentView addSubview:self.codeTextField];
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.surePasswordTextFiled.mas_bottom);
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
    
    [contentView addSubview:self.inviteTextField];
    [self.inviteTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeTextField.mas_bottom);
        make.centerX.equalTo(contentView);
        make.size.equalTo(self.phoneTextFiled);
    }];
    
    [contentView addSubview:self.agreeButton];
    [self.agreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inviteTextField.mas_bottom);
        make.left.equalTo(self.phoneTextFiled);
        make.height.equalTo(@60);
    }];
    
    [contentView addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.agreeButton);
        make.left.equalTo(self.agreeButton.mas_right);
        make.height.equalTo(self.agreeButton);
    }];
    
    [contentView addSubview:self.registerButton];
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.agreeButton.mas_bottom);
        make.centerX.equalTo(self.phoneTextFiled);
        make.size.equalTo(self.phoneTextFiled);
        make.bottom.equalTo(contentView).offset(-50);
    }];
    
    [contentView addSubview:self.areaMenu];
    [self.areaMenu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.areaTextFiled.mas_bottom);
        make.centerX.equalTo(contentView);
        make.width.equalTo(self.areaTextFiled);
        make.height.equalTo(@(0));
    }];
}

#pragma mark -
#pragma mark ---------私有方法
- (void)requestCodeData
{
    NNHWeakSelf(self)
    NNHApiLoginTool *loginTool = [[NNHApiLoginTool alloc] initCountryCodeData];
    [loginTool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
        weakself.areaMenu.dataSource = [NNHCountryCodeModel mj_objectArrayWithKeyValuesArray:responseDic[@"data"]];
        weakself.areaLabel.text = [NSString stringWithFormat:@"%@(%@)",weakself.areaMenu.selectedModel.name, weakself.areaMenu.selectedModel.scode];
    } failBlock:^(NNHRequestError *error) {
        
    } isCached:NO];
}

- (void)registerButtonClick
{
    if (!self.agreeButton.isSelected) {
        [SVProgressHUD showMessage:@"请同意注册协议"];
        return;
    }
    
    NNHApiLoginTool *loginTool = [[NNHApiLoginTool alloc] initWithMobile:self.phoneTextFiled.text valicode:self.codeTextField.text loginpwd:self.passwordTextFiled.text confirmpwd:self.surePasswordTextFiled.text parentid:self.inviteTextField.text countryCode:self.areaMenu.selectedModel.code verifyType:self.changeRegisterButton.selected ? NNSecurityVerifyTypePhone : NNSecurityVerifyTypeEmail];
    NNHWeakSelf(self)
    [SVProgressHUD nn_showWithStatus:@"注册中"];
    [loginTool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
        NNHStrongSelf(self)
        [SVProgressHUD dismissWithDelay:0.5 completion:^{
            [SVProgressHUD showMessage:@"注册成功"];
            [strongself.navigationController popViewControllerAnimated:YES];
        }];
        
    } failBlock:^(NNHRequestError *error) {
        
    } isCached:NO];
}

- (void)agreeButtonClick:(UIButton *)button
{
    button.selected = !button.selected;
}

- (void)changeRegisterType:(UIButton *)button
{
    button.selected = !button.selected;
    
    if (button.selected) {
        [UIView transitionWithView:self.view duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            self.titleLabel.text = @"手机注册";
            self.phoneTextFiled.placeholder = @"请输入手机号码";
            self.phoneTextFiled.keyboardType = UIKeyboardTypeNumberPad;
            self.areaTextFiled.hidden = NO;
            [self.areaTextFiled mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@50);
            }];
        } completion:^(BOOL finished) {
            
        }];
        
    }else {
        [UIView transitionWithView:self.view duration:1.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            self.titleLabel.text = @"邮箱注册";
            self.phoneTextFiled.placeholder = @"请输入邮箱账号";
            self.phoneTextFiled.keyboardType = UIKeyboardTypeEmailAddress;
            self.areaTextFiled.hidden = YES;
            [self.areaTextFiled mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0);
            }];
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)backButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

/** 点击下拉框 打开或关闭币种选择 */
- (void)changeTableViewUIWithOpen:(BOOL)openFlag
{
    if (!openFlag) { // 如果要打开
        self.areaMenu.hidden = NO;
        CGFloat height = 50 * 5 + 60;
        [UIView animateWithDuration:0.3 animations:^{
            [self.areaMenu mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(height));
            }];
        } completion:^(BOOL finished) {
            self.openFlag = YES;
        }];
        
    }else { // 如果要打开
        [UIView animateWithDuration:0.3 animations:^{
            [self.areaMenu mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(0));
            }];
        } completion:^(BOOL finished) {
            self.areaMenu.hidden = YES;
            self.openFlag = NO;
        }];
    }
    [self.view layoutIfNeeded];
}

#pragma mark -
#pragma mark ---------UITextFieldDelegate
- (void)textFieldDidChange:(NNHLoginTextField *)textField
{
    self.codeButton.enabled = self.phoneTextFiled.text.length >= NNHMinPhoneLength && self.codeButton.curSec == 60;
    self.registerButton.enabled = self.phoneTextFiled.text.length >= NNHMinPhoneLength && self.codeTextField.hasText && self.passwordTextFiled.text.length >= 6 && self.surePasswordTextFiled.text.length >= 6;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.areaTextFiled) {
        [self changeTableViewUIWithOpen:self.openFlag];
        return NO;
    }else {
        return YES;
    }
}

#pragma mark -
#pragma mark --------- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.openFlag) {
        [self changeTableViewUIWithOpen:self.openFlag];
    }
}

#pragma mark -
#pragma mark ---------getter && setter
- (NNHLoginTextField *)areaTextFiled
{
    if (_areaTextFiled == nil) {
        _areaTextFiled = [[NNHLoginTextField alloc] init];
        _areaTextFiled.placeholder = @"地区";
        _areaTextFiled.hidden = YES;
        _areaTextFiled.delegate = self;
        
        UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_login_area_next"]];
        [_areaTextFiled addSubview:arrowImageView];
        [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_areaTextFiled);
            make.centerY.equalTo(_areaTextFiled);
        }];
        
        UILabel *areaLabel = [UILabel NNHWithTitle:@"中国大陆(+86)" titleColor:[UIConfigManager colorThemeDarkGray] font:[UIFont systemFontOfSize:11]];
        [_areaTextFiled addSubview:areaLabel];
        _areaLabel = areaLabel;
        [areaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(_areaTextFiled);
            make.right.equalTo(arrowImageView.mas_left).offset(-5);
        }];
    }
    return _areaTextFiled;
}

- (NNHLoginTextField *)phoneTextFiled
{
    if (_phoneTextFiled == nil) {
        _phoneTextFiled = [[NNHLoginTextField alloc] init];
        _phoneTextFiled.placeholder = @"请输入邮箱账号";
        [_phoneTextFiled addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _phoneTextFiled.keyboardType = UIKeyboardTypeEmailAddress;
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

- (NNHLoginTextField *)inviteTextField
{
    if (_inviteTextField == nil) {
        _inviteTextField = [[NNHLoginTextField alloc] init];
        _inviteTextField.placeholder = @"请输入推荐人号码（选填）";
        [_inviteTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _inviteTextField.keyboardType = UIKeyboardTypeASCIICapable;
    }
    return _inviteTextField;
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

- (UIButton *)agreeButton
{
    if (_agreeButton == nil) {
        _agreeButton = [UIButton NNHBtnImage:@"ic_login_check_default" target:self action:@selector(agreeButtonClick:)];
        [_agreeButton setImage:[UIImage imageNamed:@"ic_login_check_pressed"] forState:UIControlStateSelected];
        _agreeButton.adjustsImageWhenHighlighted = NO;
        _agreeButton.selected = YES;
    }
    return _agreeButton;
}

- (UILabel *)tipLabel
{
    if (_tipLabel == nil) {
        _tipLabel = [UILabel NNHWithTitle:@" 同意并接受《用户服务协议》" titleColor:[UIConfigManager colorThemeDarkGray] font:[UIConfigManager fontThemeTextDefault]];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:_tipLabel.text];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIConfigManager colorThemeRed] range:NSMakeRange(6, 8)];
        _tipLabel.attributedText = attributedString;
        NNHWeakSelf(self)
        [_tipLabel nnh_addAttributeTapActionWithStrings:@[@"《用户服务协议》"] tapClicked:^(NSString *string, NSRange range, NSInteger index) {
            NNWebViewController *vc = [[NNWebViewController alloc] init];
            vc.url = NNH_API_MemberAgreement;
            [weakself.navigationController pushViewController:vc animated:YES];
        }];
        _tipLabel.enabledTapEffect = NO;
    }
    return _tipLabel;
}

- (UIButton *)backButton
{
    if (_backButton == nil) {
        _backButton = [UIButton NNHBtnImage:@"ic_nav_back" target:self action:@selector(backButtonClick)];
    }
    return _backButton;
}

- (UIButton *)registerButton
{
    if (_registerButton == nil) {
        _registerButton = [UIButton NNHOperationBtnWithTitle:@"立即注册" target:self action:@selector(registerButtonClick) operationButtonType:NNHOperationButtonTypeRed isAddCornerRadius:YES];
        _registerButton.enabled = NO;
    }
    return _registerButton;
}

- (NNCountDownButton *)codeButton {
    if (_codeButton == nil) {
        NNHWeakSelf(self)
        _codeButton = [[NNCountDownButton alloc] initWithTotalTime:60 titleBefre:@"获取验证码" titleConting:@"s" titleAfterCounting:@"获取验证码" clickAction:^(NNCountDownButton *countBtn) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NNHStrongSelf(self)
                NNHApiSecurityTool *tool = [[NNHApiSecurityTool alloc] initWithMobile:strongself.phoneTextFiled.text verifyCodeType:NNHSendVerificationCodeType_userRegister countryCode:strongself.areaMenu.selectedModel.code verifyType:strongself.changeRegisterButton.selected ? NNSecurityVerifyTypePhone : NNSecurityVerifyTypeEmail];
                [tool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
                    [countBtn startCounting];
                    [SVProgressHUD showMessage:@"获取验证码成功 请注意查收"];
                } failBlock:^(NNHRequestError *error) {
                    [countBtn resetButton];
                } isCached:NO];
            });
        }];
        _codeButton.slideCapchaView = YES;
        _codeButton.bgNormalColor = [UIColor whiteColor];
        _codeButton.bgCountingColor = [UIColor whiteColor];
        _codeButton.lbNormalColor = [UIConfigManager colorThemeRed];
        _codeButton.lbCountingColor = [UIConfigManager colorThemeRed];
        _codeButton.activityColor = [UIColor blackColor];
        _codeButton.enabled = NO;
    }
    return _codeButton;
}

- (NNRegisterAreaView *)areaMenu {
    if (_areaMenu == nil) {
        _areaMenu = [[NNRegisterAreaView alloc] init];
        _areaMenu.hidden = YES;
        NNHWeakSelf(self)
        _areaMenu.selectedCodeBlock = ^(NNHCountryCodeModel *countryCode) {
            weakself.areaLabel.text = [NSString stringWithFormat:@"%@(%@)",weakself.areaMenu.selectedModel.name, weakself.areaMenu.selectedModel.scode];
            [weakself changeTableViewUIWithOpen:weakself.openFlag];
        };
    }
    return _areaMenu;
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [UILabel NNHWithTitle:@"邮箱注册" titleColor:[UIConfigManager colorThemeDark] font:[UIFont boldSystemFontOfSize:34]];
    }
    return _titleLabel;
}

- (UIButton *)changeRegisterButton
{
    if (_changeRegisterButton == nil) {
        _changeRegisterButton = [UIButton NNHBtnTitle:@"手机注册" titileFont:[UIConfigManager fontThemeLargerBtnTitles] backGround:[UIColor whiteColor] titleColor:[UIConfigManager colorThemeRed]];
        [_changeRegisterButton setTitle:@"邮箱注册" forState:UIControlStateSelected];
        [_changeRegisterButton addTarget:self action:@selector(changeRegisterType:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeRegisterButton;
}

@end
