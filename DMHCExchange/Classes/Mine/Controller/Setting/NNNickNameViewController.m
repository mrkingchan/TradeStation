//
//  NNNickNameViewController.m
//  SuperWallet
//
//  Created by 牛牛 on 2018/3/30.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import "NNNickNameViewController.h"
#import "NNTextField.h"
#import "NNAPIMineTool.h"

@interface NNNickNameViewController ()

/** 昵称 */
@property (nonatomic, strong) NNTextField *nameTextField;
/** 确认按钮 */
@property (nonatomic, strong) UIButton *ensureButton;

@end

@implementation NNNickNameViewController

#pragma mark - Life Cycle Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"修改昵称";
    
    [self setupChildView];
}

#pragma mark - Initial Methods
- (void)setupChildView
{
    UILabel *nametitleLabel = [UILabel NNHWithTitle:@"昵称" titleColor:[UIConfigManager colorThemeDark] font:[UIConfigManager fontThemeTextMain]];
    [self.view addSubview:nametitleLabel];
    [nametitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(25);
        make.left.equalTo(self.view).offset(15);
    }];
    
    [self.view addSubview:self.nameTextField];
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nametitleLabel);
        make.top.equalTo(nametitleLabel.mas_bottom);
        make.right.equalTo(self.view).offset(-15);
        make.height.equalTo(@50);
    }];
    
    UIView *lineView = [UIView lineView];
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameTextField.mas_bottom);
        make.left.equalTo(nametitleLabel);
        make.right.equalTo(self.view);
        make.height.equalTo(@(NNHLineH));
    }];
    
    UILabel *promptLabel = [UILabel NNHWithTitle:@"*由中英文、数字以及下划线组成且不超过8个汉字或16个字符" titleColor:[UIConfigManager colorTextLightGray] font:[UIConfigManager fontThemeTextTip]];
    promptLabel.numberOfLines = 2;
    [self.view addSubview:promptLabel];
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(NNHMargin_15);
        make.right.equalTo(self.view).offset(-NNHMargin_15);
    }];
    
    [self.view addSubview:self.ensureButton];
    [self.ensureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(promptLabel.mas_bottom).offset(60);
        make.left.equalTo(self.view).offset(NNHMargin_15);
        make.right.equalTo(self.view).offset(-NNHMargin_15);
        make.height.equalTo(@(NNHNormalViewH));
    }];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidChange:(UITextField *)textField
{
    self.ensureButton.enabled = self.nameTextField.hasText;
}

#pragma mark - Target Methods
- (void)clickEnsureButton
{
    if ([self.nameTextField.text checkIsValidateNickname]) {
        NNHWeakSelf(self)
        NNAPIMineTool *tool = [[NNAPIMineTool alloc] initChangeUserDataSourceWithNickName:self.nameTextField.text sex:nil headerpic:nil borndate:nil area:nil areaCode:nil];
        [tool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
            NNUserModel *userModel = [NNHProjectControlCenter sharedControlCenter].userControl_currentUserModel;
            userModel.nickname = weakself.nameTextField.text;
            [weakself.navigationController popViewControllerAnimated:YES];
        } failBlock:^(NNHRequestError *error) {
            
        } isCached:NO];
    }else{
        [SVProgressHUD showMessage:@"请输入合法的昵称"];
    }
}

#pragma mark - Lazy Loads
- (NNTextField *)nameTextField
{
    if (_nameTextField == nil) {
        _nameTextField = [[NNTextField alloc] init];
        _nameTextField.placeholder = [NNHProjectControlCenter sharedControlCenter].userControl_currentUserModel.nickname;
        [_nameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _nameTextField.nn_maxLength = 16;
    }
    return _nameTextField;
}

- (UIButton *)ensureButton
{
    if (_ensureButton == nil) {
        _ensureButton = [UIButton NNHOperationBtnWithTitle:@"确定修改" target:self action:@selector(clickEnsureButton) operationButtonType:NNHOperationButtonTypeRed isAddCornerRadius:YES];
        _ensureButton.enabled = NO;
    }
    return _ensureButton;
}

@end
