//
//  NNLoginSecurityVerifyViewController.m
//  DMHCExchange
//
//  Created by 牛牛 on 2018/10/25.
//  Copyright © 2018年 超级钱包. All rights reserved.
//

#import "NNLoginSecurityVerifyViewController.h"
#import "NNHLoginTextField.h"
#import "NNHApiSecurityTool.h"
#import "NNCountDownButton.h"
#import "NNHApiLoginTool.h"
#import "NNAPIMineTool.h"
#import "JPUSHService.h"

@interface NNLoginSecurityVerifyViewController ()

/** 验证码 */
@property (nonatomic, strong) NNHLoginTextField *codeTextField;
/** 确认按钮 */
@property (nonatomic, strong) UIButton *sureButton;
/** 获取验证码按钮 */
@property (nonatomic, strong) NNCountDownButton *codeButton;

@end

@implementation NNLoginSecurityVerifyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupChildView];
}

- (void)setupChildView
{
    UIButton *backButton = [UIButton NNHBtnImage:@"ic_nav_back" target:self action:@selector(popVCAction)];
    [self.view addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view).offset(STATUSBAR_HEIGHT);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    
    UILabel *titleLabel = [UILabel NNHWithTitle:@"安全验证" titleColor:[UIConfigManager colorThemeDark] font:[UIFont boldSystemFontOfSize:34]];
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backButton.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(40);
    }];
    
    UILabel *accountLabel = [UILabel NNHWithTitle:@"当前登录账户：" titleColor:[UIConfigManager colorThemeDarkGray] font:[UIConfigManager fontThemeTextDefault]];
    [self.view addSubview:accountLabel];
    [accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(60);
        make.left.equalTo(titleLabel);
    }];
    
    UILabel *promptLabel = [UILabel NNHWithTitle:self.username titleColor:[UIConfigManager colorThemeDark] font:[UIFont boldSystemFontOfSize:14]];
    [self.view addSubview:promptLabel];
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(accountLabel.mas_bottom).offset(15);
        make.left.equalTo(titleLabel);
    }];
    
    [self.view addSubview:self.codeTextField];
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(promptLabel.mas_bottom).offset(30);
        make.left.equalTo(titleLabel);
        make.right.equalTo(self.view).offset(-40);
        make.height.equalTo(@50);
    }];
    
    [self.view addSubview:self.codeButton];
    [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.codeTextField);
        make.right.equalTo(self.codeTextField);
        make.width.equalTo(@100);
        make.height.equalTo(@35);
    }];

    [self.view addSubview:self.sureButton];
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeTextField.mas_bottom).offset(40);
        make.left.right.equalTo(self.codeTextField);
        make.height.equalTo(@44);
    }];
}

- (void)popVCAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sureButtonClick
{
    NNHApiLoginTool *loginTool = [[NNHApiLoginTool alloc] initWithLoginSecurityVerifyUserName:self.username cryptcode:self.cryptcode valicode:self.codeTextField.text];
    NNHWeakSelf(self)
    [SVProgressHUD nn_showWithStatus:@"验证中"];
    [loginTool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
        NNHStrongSelf(self)
        
        // 保存token
        NNUserModel *userModel = [NNUserModel mj_objectWithKeyValues:responseDic[@"data"]];
        [[NNHProjectControlCenter sharedControlCenter] userControl_saveUserDataWithUserInfo:userModel];
        
        // 请求用户数据
        NNAPIMineTool *tool = [[NNAPIMineTool alloc] initMemberDataSource];
        [tool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
            
            [SVProgressHUD dismissWithDelay:0.5 completion:^{
                
                // 保存登录数据
                NNUserModel *userInfoModel = [NNUserModel mj_objectWithKeyValues:responseDic[@"data"][@"userinfo"]];
                [[NNHProjectControlCenter sharedControlCenter] userControl_saveUserDataWithUserInfo:userInfoModel];
                
                //设置别名
                [JPUSHService setAlias:userInfoModel.uid
                            completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                                if (iResCode == 0) {
                                    NNHLog(@"设置别名成功!");
                                }
                            } seq:0];
                [strongself.parentViewController dismissViewControllerAnimated:YES completion:nil];
                
            }];

        } failBlock:^(NNHRequestError *error) {
            
        } isCached:NO];
        
    } failBlock:^(NNHRequestError *error) {
        
    } isCached:NO];
}

#pragma mark -
#pragma mark ---------UITextFieldDelegate
- (void)textFieldDidChange:(NNHLoginTextField *)textField
{
    self.sureButton.enabled = self.codeTextField.hasText;
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

- (UIButton *)sureButton
{
    if (_sureButton == nil) {
        _sureButton = [UIButton NNHOperationBtnWithTitle:@"确认" target:self action:@selector(sureButtonClick) operationButtonType:NNHOperationButtonTypeRed isAddCornerRadius:YES];
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
                NNSecurityVerifyType verifyType = [strongself.username containsString:@"@"] ? NNSecurityVerifyTypeEmail : NNSecurityVerifyTypePhone;
                NNHApiSecurityTool *tool = [[NNHApiSecurityTool alloc] initWithMobile:strongself.username verifyCodeType:NNHSendVerificationCodeType_loginSecurityVerify countryCode:nil verifyType:verifyType];
                [tool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
                    [countBtn startCounting];
                    [SVProgressHUD showMessage:@"获取验证码成功 请注意查收"];
                } failBlock:^(NNHRequestError *error) {
                    [countBtn resetButton];
                } isCached:NO];
            });
        }];
        _codeButton.clickButtonBlock = ^{
            [weakself.codeTextField resignFirstResponder];
        };
        _codeButton.slideCapchaView = YES;
    }

    return _codeButton;
}

@end
