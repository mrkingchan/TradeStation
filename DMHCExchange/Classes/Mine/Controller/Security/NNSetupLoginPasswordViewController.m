//
//  NNHSetUpLoginPasswordViewController.m
//  SuperWallet
//
//  Created by 来旭磊 on 2018/3/7.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import "NNSetupLoginPasswordViewController.h"
#import "NNHApiSecurityTool.h"
#import "NNHAlertTool.h"
#import "UITextField+NNHExtension.h"

@interface NNSetupLoginPasswordViewController ()

/** 第一次输入密码 */
@property (nonatomic, strong) UITextField *firstTextField;
/** 第二次输入密码 */
@property (nonatomic, strong) UITextField *secondTextField;
/** 确认按钮 */
@property (nonatomic, strong) UIButton *ensureButton;

@end

@implementation NNSetupLoginPasswordViewController

#pragma mark - Life Cycle Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"修改登录密码";
    
    [self setupChildView];
}

#pragma mark - Initial Methods
- (void)setupChildView
{
    UILabel *firstLabel = [UILabel NNHWithTitle:@"登录密码" titleColor:[UIConfigManager colorThemeDark] font:[UIConfigManager fontThemeTextMain]];
    [self.view addSubview:firstLabel];
    [firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(25);
        make.left.equalTo(self.view).offset(15);
    }];
    
    [self.view addSubview:self.firstTextField];
    [self.firstTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(firstLabel);
        make.top.equalTo(firstLabel.mas_bottom);
        make.right.equalTo(self.view).offset(-15);
        make.height.equalTo(@50);
    }];
    
    UIView *firstLineView = [UIView lineView];
    [self.view addSubview:firstLineView];
    [firstLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstTextField.mas_bottom);
        make.left.equalTo(firstLabel);
        make.right.equalTo(self.view);
        make.height.equalTo(@(NNHLineH));
    }];
    
    UILabel *secondLabel = [UILabel NNHWithTitle:@"确认登录密码" titleColor:[UIConfigManager colorThemeDark] font:[UIConfigManager fontThemeTextMain]];
    [self.view addSubview:secondLabel];
    [secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(firstLineView.mas_bottom).offset(25);
        make.left.equalTo(firstLabel);
    }];

    [self.view addSubview:self.secondTextField];
    [self.secondTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(secondLabel.mas_bottom);
        make.left.right.equalTo(self.firstTextField);
        make.height.equalTo(self.firstTextField);
    }];
    
    UIView *secongLineView = [UIView lineView];
    [self.view addSubview:secongLineView];
    [secongLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.secondTextField.mas_bottom);
        make.left.equalTo(firstLabel);
        make.right.equalTo(self.view);
        make.height.equalTo(@(NNHLineH));
    }];
    
    [self.view addSubview:self.ensureButton];
    [self.ensureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(secongLineView.mas_bottom).offset(60);
        make.left.equalTo(self.view).offset(NNHMargin_15);
        make.right.equalTo(self.view).offset(-NNHMargin_15);
        make.height.equalTo(@(NNHNormalViewH));
    }];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidChange:(UITextField *)textField
{
    self.ensureButton.enabled = self.firstTextField.text.length >= 6 && self.secondTextField.text.length >= 6;
}

#pragma mark - Target Methods
- (void)clickEnsureButton:(UIButton *)button
{    
    [SVProgressHUD nn_showWithStatus:@"提交中"];
    NNHApiSecurityTool *tool = [[NNHApiSecurityTool alloc] initUpdateLoginPasswordWithPassword:self.firstTextField.text confirmpwd:self.secondTextField.text encrypt:self.encrypt verifyType:self.securityVerifyType];
    NNHWeakSelf(self)
    [tool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
        
        [SVProgressHUD showMessage:@"修改成功"];
        
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
- (UITextField *)firstTextField
{
    if (_firstTextField == nil) {
        _firstTextField = [[UITextField alloc] init];
        _firstTextField.font = [UIConfigManager fontThemeTextDefault];
        _firstTextField.placeholder = @"请输入登录密码";
        [_firstTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _firstTextField.secureTextEntry = YES;
        _firstTextField.nn_maxLength = 16;
    }
    return _firstTextField;
}

- (UITextField *)secondTextField
{
    if (_secondTextField == nil) {
        _secondTextField = [[UITextField alloc] init];
        _secondTextField.font = [UIConfigManager fontThemeTextDefault];
        _secondTextField.placeholder = @"请再次输入登录密码";
        [_secondTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _secondTextField.secureTextEntry = YES;
        _secondTextField.nn_maxLength = 16;
    }
    return _secondTextField;
}

- (UIButton *)ensureButton
{
    if (_ensureButton == nil) {
        _ensureButton = [UIButton NNHOperationBtnWithTitle:@"确定修改" target:self action:@selector(clickEnsureButton:) operationButtonType:NNHOperationButtonTypeRed isAddCornerRadius:YES];
        _ensureButton.nn_acceptEventInterval = NNHAcceptEventInterval;
        _ensureButton.enabled = NO;
    }
    return _ensureButton;
}

@end
