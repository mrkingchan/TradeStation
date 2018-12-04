//
//  NNHVerifyPhoneViewController.m
//  SuperWallet
//
//  Created by 来旭磊 on 2018/3/7.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import "NNVerifyPhoneViewController.h"
#import "NNTextField.h"
#import "NNCountDownButton.h"
#import "NNHApiSecurityTool.h"
#import "NNSetupLoginPasswordViewController.h"
#import "NNSetupPayPasswordViewController.h"
#import "NNSetupPhoneViewController.h"

@interface NNVerifyPhoneViewController ()

/** 手机号码 */
@property (nonatomic, strong) UILabel *phoneNumLabel;
/** 确认按钮 */
@property (nonatomic, strong) UIButton *ensureButton;
/** 手机号码 */
@property (nonatomic, strong) NNTextField *phoneField;
/** 用户名 */
@property (nonatomic, strong) NNTextField *nameField;
/** 验证码 */
@property (nonatomic, strong) NNTextField *codeField;
/** 获取验证码 */
@property (nonatomic, strong) NNCountDownButton *codeButton;
/** 发送验证码类型 */
@property (nonatomic, assign) NNHSendVerificationCodeType type;

@end

@implementation NNVerifyPhoneViewController
{
    NSString *_currentPhoneNumber;
}

#pragma mark - Life Cycle Methods
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (instancetype)initWithType:(NNHSendVerificationCodeType)type
{
    if (self = [super init]) {
        _type = type;
        _currentPhoneNumber = [NNHProjectControlCenter sharedControlCenter].userControl_currentUserModel.completemobile;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIConfigManager colorThemeColorForVCBackground];
    self.navigationItem.title = @"验证手机";
    
    [self setupChildView];
}

#pragma mark - Initial Methods
- (void)setupChildView
{
    [self.view addSubview:self.phoneField];
    [self.phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(30);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.equalTo(@44);
    }];
    
    if (!_currentPhoneNumber) {
        [self.view addSubview:self.nameField];
        [self.nameField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.phoneField.mas_bottom).offset(15);
            make.left.right.equalTo(self.phoneField);
            make.height.equalTo(self.phoneField);
        }];
    }
    
    UIView *codeView = [[UIView alloc] init];
    codeView.backgroundColor = [UIConfigManager colorThemeWhite];
    [self.view addSubview:codeView];
    [codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.phoneField);
        make.top.equalTo(!_currentPhoneNumber ? self.nameField.mas_bottom : self.phoneField.mas_bottom).offset(15);
        make.height.equalTo(@(NNHNormalViewH));
    }];
    
    [codeView addSubview:self.codeField];
    [self.codeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(codeView);
        make.top.bottom.equalTo(codeView);
        make.width.equalTo(@(SCREEN_WIDTH - 120));
    }];
    
    [codeView addSubview:self.codeButton];
    [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(codeView).offset(-NNHMargin_10);
        make.centerY.equalTo(codeView);
        make.height.equalTo(@(30));
        make.width.equalTo(@80);
    }];
    
    [self.view addSubview:self.ensureButton];
    [self.ensureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(NNHMargin_15);
        make.right.equalTo(self.view).offset(-NNHMargin_15);
        make.top.equalTo(codeView.mas_bottom).offset(60);
        make.height.equalTo(@(NNHNormalViewH));
    }];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidChange:(UITextField *)textField
{
    if (![NSString isEmptyString:_currentPhoneNumber]) {
        self.ensureButton.enabled = self.codeField.hasText;
    }else{
        self.codeButton.enabled = self.phoneField.text.length  > 5 && self.nameField.text.length >= 6;
        self.ensureButton.enabled = self.phoneField.text.length  > 5 && self.codeField.hasText && self.nameField.text.length >= 6;
    }
}

#pragma mark - Target Methods
- (void)clickEnsureButton:(UIButton *)button
{
//    // 处理用户名
//    NSString *userName = _currentPhoneNumber ? [NNHProjectControlCenter sharedControlCenter].userControl_currentUserModel.username : self.nameField.text;
//    
//    NNHWeakSelf(self)
//    NNHApiSecurityTool *apiTool = [[NNHApiSecurityTool alloc] initResetPasswordValidationWithMobile:self.phoneField.text code:self.codeField.text username:userName codeType:self.type];
//    [apiTool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
//        if (weakself.type == NNHSendVerificationCodeType_changeLoginPassword || weakself.type == NNHSendVerificationCodeType_userForgetpwd) {
//            NNSetupLoginPasswordViewController *setVc = [[NNSetupLoginPasswordViewController alloc] initSetupPasswordWithSource:NNSetupPasswordSourceSetting];
//            setVc.username = userName;
//            setVc.encrypt = responseDic[@"data"][@"encrypt"];
//            setVc.mobile = responseDic[@"data"][@"mobile"];
//            [weakself.navigationController pushViewController:setVc animated:YES];
//        }else if (weakself.type == NNHSendVerificationCodeType_updatePhone) {
//            NNSetupPhoneViewController *vc = [[NNSetupPhoneViewController alloc] init];
//            [weakself.navigationController pushViewController:vc animated:YES];
//        }else {
//            NNSetupPayPasswordViewController *setVc = [[NNSetupPayPasswordViewController alloc] initWithFromType:NNHChangePayCodeFromType_Other];
//            [weakself.navigationController pushViewController:setVc animated:YES];
//        }
//    } failBlock:^(NNHRequestError *error) {
//        
//    } isCached:NO];
}

#pragma mark - Lazy Loads
- (UILabel *)phoneNumLabel
{
    if (_phoneNumLabel == nil) {
        _phoneNumLabel = [UILabel NNHWithTitle:_currentPhoneNumber titleColor:[UIConfigManager colorTextLightGray] font:[UIConfigManager fontThemeTextDefault]];
    }
    return _phoneNumLabel;
}

- (NNTextField *)phoneField
{
    if (_phoneField == nil) {
        _phoneField = [[NNTextField alloc] init];
        if ([NSString isEmptyString:_currentPhoneNumber]) {
            _phoneField.placeholder = @"请输入您的手机号码";
            _phoneField.enabled = YES;
        }else{
            _phoneField.text = _currentPhoneNumber;
            _phoneField.enabled = NO;
        }
        _phoneField.keyboardType = UIKeyboardTypeNumberPad;
        [_phoneField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _phoneField;
}

- (NNTextField *)nameField
{
    if (_nameField == nil) {
        _nameField = [[NNTextField alloc] init];
        _nameField.placeholder = @"请输入6-25位用户名";
        _nameField.keyboardType = UIKeyboardTypeASCIICapable;
        [_nameField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _nameField.nn_maxLength = 25;
    }
    return _nameField;
}

- (NNTextField *)codeField
{
    if (_codeField == nil) {
        _codeField = [[NNTextField alloc] init];
        _codeField.placeholder = @"请输入验证码";
        _codeField.keyboardType = UIKeyboardTypeNumberPad;
        [_codeField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _codeField.nn_maxLength = 6;
    }
    return _codeField;
}

- (UIButton *)ensureButton
{
    if (_ensureButton == nil) {
        _ensureButton = [UIButton NNHOperationBtnWithTitle:@"下一步" target:self action:@selector(clickEnsureButton:) operationButtonType:NNHOperationButtonTypeRed isAddCornerRadius:YES];
        _ensureButton.enabled = NO;
        _ensureButton.nn_acceptEventInterval = NNHAcceptEventInterval;
    }
    return _ensureButton;
}

/** 获取验证码按钮 */
- (NNCountDownButton *)codeButton
{
    if (_codeButton == nil) {
        NNHWeakSelf(self)
        _codeButton = [[NNCountDownButton alloc] initWithTotalTime:60 titleBefre:@"获取验证码" titleConting:@"s" titleAfterCounting:@"获取验证码" clickAction:^(NNCountDownButton *countBtn) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                NSString *mobile = ![NSString isEmptyString:_currentPhoneNumber] ? _currentPhoneNumber : weakself.phoneField.text;
//                NNHApiSecurityTool *apiTool;
//                if (weakself.type == NNHSendVerificationCodeType_userForgetpwd) {
//                    apiTool = [[NNHApiSecurityTool alloc] initWithMobile:mobile username:weakself.nameField.text];
//                }else{
//                    apiTool = [[NNHApiSecurityTool alloc] initWithMobile:mobile verifyCodeType:weakself.type countryCode:nil];
//                }
//                [apiTool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
//                    [countBtn startCounting];
//                    [SVProgressHUD showMessage:@"获取验证码成功 请注意查收"];
//                } failBlock:^(NNHRequestError *error) {
//                    [countBtn resetButton];
//                } isCached:NO];
            });
        }];
        _codeButton.layer.cornerRadius = 2.5f;
        _codeButton.layer.masksToBounds = YES;
        _codeButton.enabled = ![NSString isEmptyString:_currentPhoneNumber];
    }
    return _codeButton;
}

@end
