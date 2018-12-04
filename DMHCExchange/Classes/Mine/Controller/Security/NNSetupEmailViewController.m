//
//  NNSetupEmailViewController.m
//  DMHCExchange
//
//  Created by 牛牛 on 2018/10/25.
//  Copyright © 2018年 超级钱包. All rights reserved.
//

#import "NNSetupEmailViewController.h"
#import "NNTextField.h"
#import "NNCountDownButton.h"
#import "NNHApiSecurityTool.h"

@interface NNSetupEmailViewController ()

/** 邮箱 */
@property (nonatomic, strong) NNTextField *emailTextField;
/** 验证码 */
@property (nonatomic, strong) NNTextField *codeTextField;
/** 获取验证码 */
@property (nonatomic, strong) NNCountDownButton *codeButton;
/** 确认 */
@property (nonatomic, strong) UIButton *sureButton;

@end

@implementation NNSetupEmailViewController

#pragma mark - Life Cycle Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"修改绑定邮箱";
    
    [self setupChildView];
}

#pragma mark - Initial Methods
- (void)setupChildView
{
    UILabel *emailLabel = [UILabel NNHWithTitle:@"账号" titleColor:[UIConfigManager colorThemeDark] font:[UIConfigManager fontThemeTextMain]];
    [self.view addSubview:emailLabel];
    [emailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(25);
        make.left.equalTo(self.view).offset(15);
    }];
    
    [self.view addSubview:self.emailTextField];
    [self.emailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(emailLabel);
        make.top.equalTo(emailLabel.mas_bottom);
        make.right.equalTo(self.view).offset(-15);
        make.height.equalTo(@50);
    }];
    
    UIView *firstLineView = [UIView lineView];
    [self.view addSubview:firstLineView];
    [firstLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.emailTextField.mas_bottom);
        make.left.equalTo(emailLabel);
        make.right.equalTo(self.view);
        make.height.equalTo(@(NNHLineH));
    }];
    
    UILabel *verificationCodeLabel = [UILabel NNHWithTitle:@"邮箱验证码" titleColor:[UIConfigManager colorThemeDark] font:[UIConfigManager fontThemeTextMain]];
    [self.view addSubview:verificationCodeLabel];
    [verificationCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(firstLineView.mas_bottom).offset(20);
        make.left.equalTo(emailLabel);
    }];
    
    [self.view addSubview:self.codeButton];
    [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-NNHMargin_15);
        make.top.equalTo(verificationCodeLabel.mas_bottom).offset(10);
        make.height.equalTo(@(30));
        make.width.equalTo(@80);
    }];
    
    [self.view addSubview:self.codeTextField];
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(emailLabel);
        make.top.equalTo(verificationCodeLabel.mas_bottom);
        make.right.equalTo(self.codeButton.mas_left).offset(-15);
        make.height.equalTo(@50);
    }];
    
    UIView *secondLineView = [UIView lineView];
    [self.view addSubview:secondLineView];
    [secondLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeTextField.mas_bottom);
        make.left.equalTo(emailLabel);
        make.right.equalTo(self.view);
        make.height.equalTo(@(NNHLineH));
    }];
    
    [self.view addSubview:self.sureButton];
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(secondLineView.mas_bottom).offset(60);
        make.left.equalTo(self.view).offset(NNHMargin_15);
        make.right.equalTo(self.view).offset(-NNHMargin_15);
        make.height.equalTo(@(NNHNormalViewH));
    }];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidChange:(UITextField *)textField
{
    self.sureButton.enabled = self.emailTextField.hasText && self.codeTextField.hasText;
}

#pragma mark - Target Methods
- (void)clickEnsureButton:(UIButton *)button
{
    NNHWeakSelf(self)
    [SVProgressHUD nn_showWithStatus:@"提交中"];
    NNHApiSecurityTool *apiTool = [[NNHApiSecurityTool alloc] initUpdateEmailWithNewEmail:self.emailTextField.text valicode:self.codeTextField.text encrypt:self.encrypt verifyType:self.securityVerifyType];
    [apiTool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
        
        [SVProgressHUD showMessage:@"修改成功"];
        
        // 修改状态
        NNUserModel *userModel = [NNHProjectControlCenter sharedControlCenter].userControl_currentUserModel;
        userModel.email = weakself.emailTextField.text;        
        [[NNHProjectControlCenter sharedControlCenter] userControl_saveUserDataWithUserInfo:userModel];
        
        // 返回
        NSArray *array = weakself.navigationController.childViewControllers;
        if (array.count > 3) {
            UIViewController *controller = array[array.count - 3];
            [weakself.navigationController popToViewController:controller animated:YES];
        }else {
            [weakself.navigationController popViewControllerAnimated:YES];
        }
        
    } failBlock:^(NNHRequestError *error) {
        
    } isCached:NO];
}

#pragma mark - Lazy Loads
- (NNTextField *)emailTextField
{
    if (_emailTextField == nil) {
        _emailTextField = [[NNTextField alloc] init];
        _emailTextField.placeholder = @"请输入新邮箱账号";
        _emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
        [_emailTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _emailTextField;
}

- (NNTextField *)codeTextField
{
    if (_codeTextField == nil) {
        _codeTextField = [[NNTextField alloc] init];
        _codeTextField.placeholder = @"请输入邮箱验证码";
        _codeTextField.keyboardType = UIKeyboardTypeNumberPad;
        [_codeTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _codeTextField.nn_maxLength = 6;
    }
    return _codeTextField;
}

- (UIButton *)sureButton
{
    if (_sureButton == nil) {
        _sureButton = [UIButton NNHOperationBtnWithTitle:@"确认修改" target:self action:@selector(clickEnsureButton:) operationButtonType:NNHOperationButtonTypeRed isAddCornerRadius:YES];
        _sureButton.enabled = NO;
    }
    return _sureButton;
}

/** 获取验证码按钮 */
- (NNCountDownButton *)codeButton
{
    if (_codeButton == nil) {
        NNHWeakSelf(self)
        _codeButton = [[NNCountDownButton alloc] initWithTotalTime:60 titleBefre:@"获取验证码" titleConting:@"s" titleAfterCounting:@"获取验证码" clickAction:^(NNCountDownButton *countBtn) {
            NNHStrongSelf(self)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NNHApiSecurityTool *apiTool = [[NNHApiSecurityTool alloc] initWithMobile:strongself.emailTextField.text verifyCodeType:NNHSendVerificationCodeType_updateEmail countryCode:nil verifyType:NNSecurityVerifyTypeEmail];
                [apiTool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
                    [countBtn startCounting];
                    [SVProgressHUD showMessage:@"获取验证码成功 请注意查收"];
                } failBlock:^(NNHRequestError *error) {
                    [countBtn resetButton];
                } isCached:NO];
            });
        }];
    }
    return _codeButton;
}

@end
