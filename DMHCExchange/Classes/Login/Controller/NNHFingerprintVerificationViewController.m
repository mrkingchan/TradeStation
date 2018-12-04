//
//  NNHFingerprintVerificationViewController.m
//  NNHBitooex
//
//  Created by 牛牛 on 2018/3/26.
//  Copyright © 2018年 深圳市云牛惠科技有限公司. All rights reserved.
//

#import "NNHFingerprintVerificationViewController.h"
#import "UITextField+NNHExtension.h"
#import "NNHFingerprintTool.h"
#import "NNHApiLoginTool.h"

@interface NNHFingerprintVerificationViewController ()

/** 密码 */
@property (nonatomic, strong) UITextField *pwdTextFiled;
/** 下划线 */
@property (nonatomic, strong) UIView *lineView;;
/** 确认按钮 */
@property (nonatomic, strong) UIButton *sureButton;
/** 指纹按钮 */
@property (nonatomic, strong) UIButton *fingerprintButton;
/** 密码按钮 */
@property (nonatomic, strong) UIButton *pwdButton;

@end

@implementation NNHFingerprintVerificationViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor akext_colorWithHex:@"0c1623"];
    
    [self setupChildView];
    
    if ([[NNHFingerprintTool sharedInstance] openFingerprint]) { // 主动调用指纹
        [self fingerprintVerificationAction];
    }else{
        self.pwdButton.selected = NO;
        [self switchVerification:self.pwdButton];
    }
}

- (void)setupChildView {
    UILabel *titleLabel = [UILabel NNHWithTitle:@"Smile intl验证" titleColor:[UIConfigManager colorThemeWhite] font:[UIConfigManager fontNaviTitle]];
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(STATUSBAR_HEIGHT);
        make.centerX.equalTo(self.view);
        make.height.equalTo(@44);
    }];
    
    [self.view addSubview:self.fingerprintButton];
    [self.fingerprintButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-20);
    }];
    
    [self.view addSubview:self.pwdTextFiled];
    [self.pwdTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view).offset(-60);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(SCREEN_WIDTH - 85);
        make.height.equalTo(@44);
    }];
    
    [self.view addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.pwdTextFiled).offset(NNHLineH);
        make.left.right.equalTo(self.pwdTextFiled);
        make.height.equalTo(@(NNHLineH));
    }];
    
    [self.view addSubview:self.sureButton];
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pwdTextFiled.mas_bottom).offset(40);
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.pwdTextFiled);
        make.height.equalTo(self.pwdTextFiled);
    }];
    
    [self.view addSubview:self.pwdButton];
    [self.pwdButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-20 - (NNHBottomSafeHeight));
        make.height.equalTo(@44);
    }];
}

#pragma mark -
#pragma mark ---------UserAction
- (void)sureButtonClick
{
    NNHApiLoginTool *loginTool = [[NNHApiLoginTool alloc] initFingerprintVerificationWithPwd:self.pwdTextFiled.text];
    NNHWeakSelf(self)
    [loginTool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {

        [weakself closeAction];
        
    } failBlock:^(NNHRequestError *error) {

    } isCached:NO];
}

- (void)switchVerification:(UIButton *)button
{
    if (button.selected) {
        button.selected = NO;
        self.fingerprintButton.hidden = NO;
        self.pwdTextFiled.hidden = self.lineView.hidden = self.sureButton.hidden = YES;
    }else{
        button.selected = YES;
        self.fingerprintButton.hidden = YES;
        self.pwdTextFiled.hidden = self.lineView.hidden = self.sureButton.hidden = NO;
    }
}

- (void)closeAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)fingerprintVerificationAction {
    if (![[NNHFingerprintTool sharedInstance] openFingerprint]) {
        [SVProgressHUD showMessage:@"指纹/面容未开启，请用登录密码验证"];
        return;
    }
    NNHWeakSelf(self)
    [[NNHFingerprintTool sharedInstance] openFingerprintResults:^(BOOL success) {
        if (success) {            
            [weakself closeAction];
        }
    }];
}

#pragma mark -
#pragma mark ---------UITextFieldDelegate
- (void)textFieldDidChange:(UITextField *)textField
{
    self.sureButton.enabled = self.pwdTextFiled.text.length >= 6;
}

- (UITextField *)pwdTextFiled
{
    if (_pwdTextFiled == nil) {
        _pwdTextFiled = [[UITextField alloc] init];
        _pwdTextFiled.placeholder = @"请输入登录密码";
        _pwdTextFiled.textColor = [UIColor akext_colorWithHex:@"637794"];
        [_pwdTextFiled setValue:[UIColor akext_colorWithHex:@"637794"] forKeyPath:@"_placeholderLabel.textColor"];
        _pwdTextFiled.font = [UIFont systemFontOfSize:13];
        [_pwdTextFiled addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _pwdTextFiled.nn_maxLength = 16;
        _pwdTextFiled.secureTextEntry = YES;
        _pwdTextFiled.hidden = YES;
    }
    return _pwdTextFiled;
}

/** 登录按钮 */
- (UIButton *)sureButton
{
    if (_sureButton == nil) {
        _sureButton = [UIButton NNHOperationBtnWithTitle:@"确定" target:self action:@selector(sureButtonClick) operationButtonType:NNHOperationButtonTypeRed isAddCornerRadius:YES];
        [_sureButton setBackgroundColor:[UIColor akext_colorWithHex:@"393d46"] forState:UIControlStateDisabled];
        [_sureButton setTitleColor:[UIConfigManager colorTextLightGray] forState:UIControlStateDisabled];
        _sureButton.enabled = NO;
        _sureButton.hidden = YES;
        _sureButton.nn_acceptEventInterval = NNHAcceptEventInterval;
    }
    return _sureButton;
}

- (UIButton *)fingerprintButton {
    if (_fingerprintButton == nil) {
        NSString *imgStr = isiPhoneX ? @"ic_face_id" : @"ic_fingerprint";
        _fingerprintButton = [UIButton NNHBtnImage:imgStr target:self action:@selector(fingerprintVerificationAction)];
    }
    return _fingerprintButton;
}

- (UIButton *)pwdButton
{
    if (_pwdButton == nil) {
        _pwdButton = [UIButton NNHBtnTitle:@"登录密码验证" titileFont:[UIConfigManager fontThemeTextMain] backGround:[UIColor clearColor] titleColor:[UIColor akext_colorWithHex:@"637794"]];
        [_pwdButton setTitle:@"指纹/面容 ID验证" forState:UIControlStateSelected];
        [_pwdButton addTarget:self action:@selector(switchVerification:) forControlEvents:UIControlEventTouchUpInside];;
    }
    return _pwdButton;
}

- (UIView *)lineView
{
    if (_lineView == nil) {
        _lineView = [UIView lineView];
        _lineView.backgroundColor = [UIColor akext_colorWithHex:@"637794"];
        _lineView.hidden = YES;
    }
    return _lineView;
}

@end
