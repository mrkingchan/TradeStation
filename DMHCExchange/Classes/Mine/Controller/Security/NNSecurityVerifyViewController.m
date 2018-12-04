//
//  NNSecurityVerifyViewController.m
//  DMHCExchange
//
//  Created by 牛牛 on 2018/10/25.
//  Copyright © 2018年 超级钱包. All rights reserved.
//

#import "NNSecurityVerifyViewController.h"
#import "NNTextField.h"
#import "NNCountDownButton.h"
#import "NNHApiSecurityTool.h"
#import "NNSetupLoginPasswordViewController.h"
#import "NNSetupPayPasswordViewController.h"
#import "NNSetupPhoneViewController.h"
#import "NNSetupEmailViewController.h"

@interface NNSecurityVerifyViewController ()

/** 验证码 */
@property (nonatomic, strong) NNTextField *codeTextField;
/** 获取验证码 */
@property (nonatomic, strong) NNCountDownButton *codeButton;
/** 下一步 */
@property (nonatomic, strong) UIButton *nextButton;
/** 当前帐号 */
@property (nonatomic, copy) NSString *currentAccount;
/** 验证方式 */
@property (nonatomic, assign) NNSecurityVerifyType securityVerifyType;
/** 验证码类型 */
@property (nonatomic, assign) NNHSendVerificationCodeType verificationCodeType;

@end

@implementation NNSecurityVerifyViewController

#pragma mark - Life Cycle Methods
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (instancetype)initWithSecurityVerifyType:(NNSecurityVerifyType)securityVerifyType
                      verificationCodeType:(NNHSendVerificationCodeType)verificationCodeType
{
    if (self = [super init]) {
        
        _securityVerifyType = securityVerifyType;
        _verificationCodeType = verificationCodeType;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"安全验证";
    
    [self setupChildView];
}

#pragma mark - Initial Methods
- (void)setupChildView
{
    NNUserModel *userModel = [NNHProjectControlCenter sharedControlCenter].userControl_currentUserModel;
    
    NSString *verifyTitleStr = self.securityVerifyType == NNSecurityVerifyTypePhone ? @"手机" : @"邮箱";
    self.currentAccount = self.securityVerifyType == NNSecurityVerifyTypePhone ? userModel.mobile : userModel.email;
    NSString *currentAccountStr = [NSString stringWithFormat:@"当前绑定%@：%@",verifyTitleStr,self.currentAccount];
    UILabel *currentAccountLabel = [UILabel NNHWithTitle:currentAccountStr titleColor:[UIConfigManager colorThemeDark] font:[UIFont boldSystemFontOfSize:14]];
    [self.view addSubview:currentAccountLabel];
    [currentAccountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(25);
        make.left.equalTo(self.view).offset(15);
    }];
    
    NSString *currentVerificationCodeStr = [NSString stringWithFormat:@"%@验证码",verifyTitleStr];
    UILabel *verificationCodeLabel = [UILabel NNHWithTitle:currentVerificationCodeStr titleColor:[UIConfigManager colorThemeDark] font:[UIConfigManager fontThemeTextMain]];
    [self.view addSubview:verificationCodeLabel];
    [verificationCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(currentAccountLabel.mas_bottom).offset(40);
        make.left.equalTo(currentAccountLabel);
    }];
    
    [self.view addSubview:self.codeButton];
    [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-NNHMargin_15);
        make.top.equalTo(verificationCodeLabel.mas_bottom).offset(10);
        make.height.equalTo(@(30));
        make.width.equalTo(@80);
    }];
    
    self.codeTextField.placeholder = [NSString stringWithFormat:@"请输入%@验证码",verifyTitleStr];
    [self.view addSubview:self.codeTextField];
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(currentAccountLabel);
        make.top.equalTo(verificationCodeLabel.mas_bottom);
        make.right.equalTo(self.codeButton.mas_left).offset(-15);
        make.height.equalTo(@50);
    }];
    
    UIView *lineView = [UIView lineView];
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeTextField.mas_bottom);
        make.left.equalTo(currentAccountLabel);
        make.right.equalTo(self.view);
        make.height.equalTo(@(NNHLineH));
    }];
    
    [self.view addSubview:self.nextButton];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(60);
        make.left.equalTo(self.view).offset(NNHMargin_15);
        make.right.equalTo(self.view).offset(-NNHMargin_15);
        make.height.equalTo(@(NNHNormalViewH));
    }];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidChange:(UITextField *)textField
{
    self.nextButton.enabled = self.codeTextField.hasText;
}

#pragma mark - Target Methods
- (void)clickEnsureButton:(UIButton *)button
{
    [SVProgressHUD nn_showWithStatus:@"提交中"];
    NNHWeakSelf(self)
    NNHApiSecurityTool *apiTool = [[NNHApiSecurityTool alloc] initResetPasswordValidationWithVerifyType:self.securityVerifyType code:self.codeTextField.text codeType:self.verificationCodeType];
    [apiTool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
        
        [SVProgressHUD nn_dismiss];
        if (weakself.verificationCodeType == NNHSendVerificationCodeType_changePayPassword) {
            NNSetupPayPasswordViewController *vc = [[NNSetupPayPasswordViewController alloc] init];
            vc.encrypt = responseDic[@"data"][@"encrypt"];
            vc.securityVerifyType = weakself.securityVerifyType;
            [weakself.navigationController pushViewController:vc animated:YES];
        }else if (weakself.verificationCodeType == NNHSendVerificationCodeType_phoneSecurityVerify) {
            NNSetupPhoneViewController *vc = [[NNSetupPhoneViewController alloc] init];
            vc.encrypt = responseDic[@"data"][@"encrypt"];
            vc.securityVerifyType = weakself.securityVerifyType;
            [weakself.navigationController pushViewController:vc animated:YES];
        }else if (weakself.verificationCodeType == NNHSendVerificationCodeType_emailSecurityVerify) {
            NNSetupEmailViewController *vc = [[NNSetupEmailViewController alloc] init];
            vc.encrypt = responseDic[@"data"][@"encrypt"];
            vc.securityVerifyType = weakself.securityVerifyType;
            [weakself.navigationController pushViewController:vc animated:YES];
        }else {
            NNSetupLoginPasswordViewController *vc = [[NNSetupLoginPasswordViewController alloc] init];
            vc.encrypt = responseDic[@"data"][@"encrypt"];
            vc.securityVerifyType = weakself.securityVerifyType;
            [weakself.navigationController pushViewController:vc animated:YES];
        }
        
    } failBlock:^(NNHRequestError *error) {

    } isCached:NO];
}

#pragma mark - Lazy Loads
- (NNTextField *)codeTextField
{
    if (_codeTextField == nil) {
        _codeTextField = [[NNTextField alloc] init];
        _codeTextField.keyboardType = UIKeyboardTypeNumberPad;
        [_codeTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _codeTextField.nn_maxLength = 6;
    }
    return _codeTextField;
}

- (UIButton *)nextButton
{
    if (_nextButton == nil) {
        _nextButton = [UIButton NNHOperationBtnWithTitle:@"下一步" target:self action:@selector(clickEnsureButton:) operationButtonType:NNHOperationButtonTypeRed isAddCornerRadius:YES];
        _nextButton.enabled = NO;
        _nextButton.nn_acceptEventInterval = NNHAcceptEventInterval;
    }
    return _nextButton;
}

/** 获取验证码按钮 */
- (NNCountDownButton *)codeButton
{
    if (_codeButton == nil) {
        NNHWeakSelf(self)
        _codeButton = [[NNCountDownButton alloc] initWithTotalTime:60 titleBefre:@"获取验证码" titleConting:@"s" titleAfterCounting:@"获取验证码" clickAction:^(NNCountDownButton *countBtn) {
            NNHStrongSelf(self)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                NNHApiSecurityTool *tool = [[NNHApiSecurityTool alloc] initWithMobile:strongself.currentAccount verifyCodeType:strongself.verificationCodeType countryCode:nil verifyType:strongself.securityVerifyType];
                [tool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
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
