//
//  NNSetupPayPasswordViewController.m
//  SuperWallet
//
//  Created by 来旭磊 on 2018/3/7.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import "NNSetupPayPasswordViewController.h"
#import "UITextField+NNHExtension.h"
#import "NNHApiSecurityTool.h"

@interface NNSetupPayPasswordViewController ()

/** 第一次输入密码 */
@property (nonatomic, strong) UITextField *payPasswordField;
/** 确认按钮 */
@property (nonatomic, strong) UIButton *ensureButton;

@end

@implementation NNSetupPayPasswordViewController

#pragma mark - Life Cycle Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"修改资金密码";
    
    [self setupChildView];
}

#pragma mark - Initial Methods
- (void)setupChildView
{
    UILabel *paytitleLabel = [UILabel NNHWithTitle:@"资金密码" titleColor:[UIConfigManager colorThemeDark] font:[UIConfigManager fontThemeTextMain]];
    [self.view addSubview:paytitleLabel];
    [paytitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(25);
        make.left.equalTo(self.view).offset(15);
    }];
    
    [self.view addSubview:self.payPasswordField];
    [self.payPasswordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(paytitleLabel);
        make.top.equalTo(paytitleLabel.mas_bottom);
        make.right.equalTo(self.view).offset(-15);
        make.height.equalTo(@50);
    }];
    
    UIView *lineView = [UIView lineView];
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.payPasswordField.mas_bottom);
        make.left.equalTo(paytitleLabel);
        make.right.equalTo(self.view);
        make.height.equalTo(@(NNHLineH));
    }];
    
    [self.view addSubview:self.ensureButton];
    [self.ensureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(60);
        make.left.equalTo(self.view).offset(NNHMargin_15);
        make.right.equalTo(self.view).offset(-NNHMargin_15);
        make.height.equalTo(@(NNHNormalViewH));
    }];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidChange:(UITextField *)textField
{
    self.ensureButton.enabled = textField.text.length >= 6;
}

#pragma mark - Target Methods
- (void)clickEnsureButton:(UIButton *)button
{    
    [SVProgressHUD nn_showWithStatus:@"提交中"];
    NNHWeakSelf(self)
    NNHApiSecurityTool *userTool = [[NNHApiSecurityTool alloc] initUpdatePayPasswordWithPassword:self.payPasswordField.text encrypt:self.encrypt verifyType:self.securityVerifyType];
    [userTool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
        
        [SVProgressHUD showMessage:@"修改成功"];
        
        // 修改状态
        NNUserModel *userModel = [NNHProjectControlCenter sharedControlCenter].userControl_currentUserModel;
        userModel.payDec = @"1";        
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
- (UITextField *)payPasswordField
{
    if (_payPasswordField == nil) {
        _payPasswordField = [[UITextField alloc] init];
        _payPasswordField.font = [UIConfigManager fontThemeTextDefault];
        _payPasswordField.placeholder = @"请输入6位数字资金密码";
        _payPasswordField.keyboardType = UIKeyboardTypeNumberPad;
        _payPasswordField.secureTextEntry = YES;
        [_payPasswordField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _payPasswordField.nn_maxLength = 6;
    }
    return _payPasswordField;
}

- (UIButton *)ensureButton
{
    if (_ensureButton == nil) {
        _ensureButton = [UIButton NNHOperationBtnWithTitle:@"确定" target:self action:@selector(clickEnsureButton:) operationButtonType:NNHOperationButtonTypeRed isAddCornerRadius:YES];
        _ensureButton.nn_acceptEventInterval = NNHAcceptEventInterval;
        _ensureButton.enabled = NO;
    }
    return _ensureButton;
}

@end
