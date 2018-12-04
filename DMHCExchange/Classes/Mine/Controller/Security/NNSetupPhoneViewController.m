//
//  NNSetPhoneViewController.m
//  YWL
//
//  Created by 牛牛 on 2018/7/16.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import "NNSetupPhoneViewController.h"
#import "NNRegisterAreaView.h"
#import "NNHCountryCodeModel.h"
#import "NNTextField.h"
#import "NNCountDownButton.h"
#import "NNHApiSecurityTool.h"
#import "NNHApiLoginTool.h"

@interface NNSetupPhoneViewController () <UITextFieldDelegate>

/** 选择国家 */
@property (nonatomic, strong) NNTextField *areaTextFiled;
/** 手机号码 */
@property (nonatomic, strong) NNTextField *phoneField;
/** 验证码 */
@property (nonatomic, strong) NNTextField *codeField;
/** 获取验证码 */
@property (nonatomic, strong) NNCountDownButton *codeButton;
/** 区域view */
@property (nonatomic, weak) UILabel *areaLabel;
@property (nonatomic, strong) NNRegisterAreaView *areaMenu;
/** 下拉框是否打开 */
@property (nonatomic, assign) BOOL openFlag;
/** 确认按钮 */
@property (nonatomic, strong) UIButton *ensureButton;

@end

@implementation NNSetupPhoneViewController

#pragma mark - Life Cycle Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"修改手机";
    
    [self setupChildView];
    [self requestCodeData];
}

#pragma mark - Initial Methods
- (void)setupChildView
{
    [self.view addSubview:self.areaTextFiled];
    [self.areaTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(25);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.equalTo(@50);
    }];
    
    UIView *firstLineView = [UIView lineView];
    [self.view addSubview:firstLineView];
    [firstLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.areaTextFiled.mas_bottom);
        make.left.equalTo(self.areaTextFiled);
        make.right.equalTo(self.view);
        make.height.equalTo(@(NNHLineH));
    }];
    
    UILabel *phoneLabel = [UILabel NNHWithTitle:@"手机" titleColor:[UIConfigManager colorThemeDark] font:[UIConfigManager fontThemeTextMain]];
    [self.view addSubview:phoneLabel];
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(firstLineView.mas_bottom).offset(20);
        make.left.equalTo(self.areaTextFiled);
    }];
    
    [self.view addSubview:self.phoneField];
    [self.phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneLabel.mas_bottom);
        make.left.right.equalTo(self.areaTextFiled);
        make.height.equalTo(self.areaTextFiled);
    }];
    
    UIView *secondLineView = [UIView lineView];
    [self.view addSubview:secondLineView];
    [secondLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneField.mas_bottom);
        make.left.right.equalTo(firstLineView);
        make.height.equalTo(firstLineView);
    }];
    
    UILabel *codeLabel = [UILabel NNHWithTitle:@"手机验证码" titleColor:[UIConfigManager colorThemeDark] font:[UIConfigManager fontThemeTextMain]];
    [self.view addSubview:codeLabel];
    [codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(secondLineView.mas_bottom).offset(20);
        make.left.equalTo(self.areaTextFiled);
    }];
    
    [self.view addSubview:self.codeButton];
    [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.areaTextFiled);
        make.top.equalTo(codeLabel.mas_bottom).offset(10);
        make.height.equalTo(@(30));
        make.width.equalTo(@80);
    }];
    
    [self.view addSubview:self.codeField];
    [self.codeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(codeLabel.mas_bottom);
        make.left.equalTo(self.areaTextFiled);
        make.right.equalTo(self.codeButton.mas_left).offset(-15);
        make.height.equalTo(self.areaTextFiled);
    }];
    
    UIView *thirdLineView = [UIView lineView];
    [self.view addSubview:thirdLineView];
    [thirdLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeField.mas_bottom);
        make.left.equalTo(self.areaTextFiled);
        make.right.equalTo(self.view);
        make.height.equalTo(@(NNHLineH));
    }];
 
    [self.view addSubview:self.ensureButton];
    [self.ensureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(thirdLineView.mas_bottom).offset(60);
        make.left.equalTo(self.view).offset(NNHMargin_15);
        make.right.equalTo(self.view).offset(-NNHMargin_15);
        make.height.equalTo(@(NNHNormalViewH));
    }];
    
    [self.view addSubview:self.areaMenu];
    [self.areaMenu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(firstLineView.mas_bottom);
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.areaTextFiled);
        make.height.equalTo(@(0));
    }];
}

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

- (void)changeTableViewUIWithOpen:(BOOL)openFlag
{
    if (!openFlag) { // 如果要打开
        self.areaMenu.hidden = NO;
        CGFloat height = 280;
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

#pragma mark - UITextFieldDelegate
- (void)textFieldDidChange:(UITextField *)textField
{
    self.codeButton.enabled = self.phoneField.text.length  > 5;
    self.ensureButton.enabled = self.phoneField.text.length  > 5 && self.codeField.hasText;
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

#pragma mark - Target Methods
- (void)clickEnsureButton:(UIButton *)button
{
    NNHWeakSelf(self)    
    [SVProgressHUD nn_showWithStatus:@"提交中"];
    NNHApiSecurityTool *apiTool = [[NNHApiSecurityTool alloc] initUpdatePhoneWithMobile:self.phoneField.text valicode:self.codeField.text encrypt:self.encrypt countrycode:self.areaMenu.selectedModel.code verifyType:self.securityVerifyType];
    [apiTool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
        
        [SVProgressHUD showMessage:@"修改成功"];
        
        // 修改状态并保存
        NNUserModel *userModel = [NNHProjectControlCenter sharedControlCenter].userControl_currentUserModel;
        userModel.mobile = weakself.phoneField.text;
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
- (NNTextField *)areaTextFiled
{
    if (_areaTextFiled == nil) {
        _areaTextFiled = [[NNTextField alloc] init];
        _areaTextFiled.text = @"地区";
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

- (NNTextField *)phoneField
{
    if (_phoneField == nil) {
        _phoneField = [[NNTextField alloc] init];
        _phoneField.placeholder = @"请输入手机账号";
        _phoneField.keyboardType = UIKeyboardTypeNumberPad;
        [_phoneField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _phoneField.nn_maxLength = NNHMaxPhoneLength;
    }
    return _phoneField;
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
        _ensureButton = [UIButton NNHOperationBtnWithTitle:@"确定" target:self action:@selector(clickEnsureButton:) operationButtonType:NNHOperationButtonTypeRed isAddCornerRadius:YES];
        _ensureButton.enabled = NO;
        _ensureButton.nn_acceptEventInterval = NNHAcceptEventInterval;
    }
    return _ensureButton;
}

- (NNRegisterAreaView *)areaMenu
{
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

/** 获取验证码按钮 */
- (NNCountDownButton *)codeButton
{
    if (_codeButton == nil) {
        NNHWeakSelf(self)
        _codeButton = [[NNCountDownButton alloc] initWithTotalTime:60 titleBefre:@"获取验证码" titleConting:@"s" titleAfterCounting:@"获取验证码" clickAction:^(NNCountDownButton *countBtn) {
            NNHStrongSelf(self)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NNHApiSecurityTool *apiTool = [[NNHApiSecurityTool alloc] initWithMobile:strongself.phoneField.text verifyCodeType:NNHSendVerificationCodeType_updatePhone countryCode:strongself.areaMenu.selectedModel.code verifyType:NNSecurityVerifyTypePhone];
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
