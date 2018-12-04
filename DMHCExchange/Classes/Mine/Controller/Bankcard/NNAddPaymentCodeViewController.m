//
//  NNPaymentCodeViewController.m
//  NBTMill
//
//  Created by 牛牛 on 2018/5/10.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import "NNAddPaymentCodeViewController.h"
#import "NNImagePickerViewController.h"
#import "NNTextField.h"
#import "NNUploadImageTool.h"
#import "UIButton+NNImagePosition.h"
#import "NNAPIMineTool.h"

@interface NNAddPaymentCodeViewController ()

/** 账户姓名 */
@property (nonatomic, strong) NNTextField *nameTextField;
/** 账户 */
@property (nonatomic, strong) NNTextField *accountTextField;
/** 微信 */
@property (nonatomic, strong) UIButton *wechatButton;
/** 支付宝 */
@property (nonatomic, strong) UIButton *payButton;
/** 二维码地址 */
@property (nonatomic, copy) NSString *qrCodeStr;
/** 提交 */
@property (nonatomic, strong) UIButton *submitButton;
/** 右侧提示 */
@property (nonatomic, weak) UIButton *arrowButton;

@end

@implementation NNAddPaymentCodeViewController

#pragma mark -
#pragma mark ---------Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"上传微信／支付宝收款码";
    self.view.backgroundColor = [UIConfigManager colorThemeColorForVCBackground];
    
    [self setupChildView];
}

- (void)setupChildView
{
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(15);
        make.left.right.equalTo(self.view);
    }];
    
    [contentView addSubview:self.nameTextField];
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.left.equalTo(contentView).offset(15);
        make.right.equalTo(contentView).offset(-15);
        make.height.equalTo(@50);
    }];
    
    UIView *lineView1 = [UIView lineView];
    [contentView addSubview:lineView1];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameTextField.mas_bottom);
        make.left.right.equalTo(contentView);
        make.height.equalTo(@(NNHLineH));
    }];

    [self.view addSubview:self.wechatButton];
    [self.wechatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView1.mas_bottom);
        make.left.equalTo(self.view).offset(NNHMargin_20);
        make.height.equalTo(@60);
    }];
    
    [self.view addSubview:self.payButton];
    [self.payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.wechatButton);
        make.left.equalTo(self.view.mas_centerX).offset(NNHMargin_15);
        make.height.equalTo(self.wechatButton);
    }];
    
    UIView *lineView2 = [UIView lineView];
    [contentView addSubview:lineView2];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.wechatButton.mas_bottom);
        make.left.right.equalTo(contentView);
        make.height.equalTo(@(NNHLineH));
    }];
    
    [self.view addSubview:self.accountTextField];
    [self.accountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView2.mas_bottom);
        make.left.right.equalTo(self.nameTextField);
        make.height.equalTo(self.nameTextField);
    }];
    
    UIView *lineView3 = [UIView lineView];
    [contentView addSubview:lineView3];
    [lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.accountTextField.mas_bottom);
        make.left.right.equalTo(contentView);
        make.height.equalTo(@(NNHLineH));
    }];

    // 选取收款码
    UIButton *payCodeButton = [UIButton NNHBtnTitle:@"选取文件" titileFont:[UIConfigManager fontThemeTextMain] backGround:[UIColor whiteColor] titleColor:[UIConfigManager colorThemeDark]];
    payCodeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [payCodeButton addTarget:self action:@selector(uploadPayCode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:payCodeButton];
    [payCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView3.mas_bottom);
        make.left.right.equalTo(self.nameTextField);
        make.height.equalTo(self.nameTextField);
        make.bottom.equalTo(contentView);
    }];
    
    UIButton *arrowButton = [UIButton NNHBtnTitle:@"请上传" titileFont:[UIConfigManager fontThemeTextTip] backGround:[UIColor whiteColor] titleColor:[UIConfigManager colorTextLightGray]];
    [arrowButton setImage:ImageName(@"ic_login_area_next") forState:UIControlStateNormal];
    [arrowButton nn_setImagePosition:NNImagePositionRight spacing:5];
    [arrowButton addTarget:self action:@selector(uploadPayCode) forControlEvents:UIControlEventTouchUpInside];
    [payCodeButton addSubview:arrowButton];
    self.arrowButton = arrowButton;
    [arrowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(payCodeButton);
        make.right.equalTo(payCodeButton);
    }];
    
    [self.view addSubview:self.submitButton];
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(payCodeButton.mas_bottom).offset(44);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.equalTo(self.nameTextField);
    }];
}

#pragma mark -
#pragma mark ---------UserAction
- (void)wechatAction
{
    if (self.wechatButton.selected) return;
    self.wechatButton.selected = YES;
    self.payButton.selected = NO;
}

- (void)payAction
{
    if (self.payButton.selected) return;
    self.wechatButton.selected = NO;
    self.payButton.selected = YES;
}

- (void)cancelHighlighted:(UIButton *)button
{
    button.highlighted = NO;
}

- (void)uploadPayCode
{
    NNImagePickerViewController *imagePickerVc = [[NNImagePickerViewController alloc] initWithMaxImagesCount:1 delegate:nil];
    imagePickerVc.naviBgColor = [UIColor blackColor];
    imagePickerVc.naviTitleColor = [UIConfigManager colorNaviBarTitle];
    imagePickerVc.barItemTextColor = [UIConfigManager colorNaviBarTitle];
    imagePickerVc.naviTitleFont = [UIConfigManager fontNaviTitle];
    imagePickerVc.barItemTextFont = [UIConfigManager fontNaviBarButtonTitle];
    NNHWeakSelf(self)
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos,NSArray *assets,BOOL isSelectOriginalPhoto) {
        [NNUploadImageTool uploadWithImage:[photos lastObject] successBlock:^(NSString *upUrl, NSString *wholeUrl) {
            weakself.qrCodeStr = upUrl;
            [weakself.arrowButton setTitle:@"已上传" forState:UIControlStateNormal];
        } failedBlock:^(NNHRequestError *error) {
            
        }];
    }];
    [self.navigationController presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)submitAction
{
    if ([NSString isEmptyString:self.qrCodeStr]) {
        [SVProgressHUD showMessage:@"请选取文件"];
        return;
    }
    
    NNAPIMineTool *tool = [[NNAPIMineTool alloc] initAddPaymentCodeWithName:self.nameTextField.text codeType:self.wechatButton.selected ? @"1" : @"2" payNumber:self.accountTextField.text img:self.qrCodeStr];
    NNHWeakSelf(self)
    [tool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {        
        [SVProgressHUD showMessage:@"添加成功"];
        
        // 修改状态并保存
        NNUserModel *userModel = [NNHProjectControlCenter sharedControlCenter].userControl_currentUserModel;
        userModel.banknumber = @"1";
        [[NNHProjectControlCenter sharedControlCenter] userControl_saveUserDataWithUserInfo:userModel];
        
        [weakself.navigationController popViewControllerAnimated:YES];
        
    } failBlock:^(NNHRequestError *error) {
        
    } isCached:NO];
}

#pragma mark -
#pragma mark ---------UITextFieldDelegate
- (void)textFieldDidChange:(NNTextField *)textField
{
    self.submitButton.enabled = self.nameTextField.hasText && self.accountTextField.hasText;
}

#pragma mark -
#pragma mark ---------Getters & Setters
- (NNTextField *)nameTextField
{
    if (_nameTextField == nil) {
        _nameTextField = [[NNTextField alloc] init];
        _nameTextField.placeholder = @"账户姓名";
        [_nameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _nameTextField;
}

- (NNTextField *)accountTextField
{
    if (_accountTextField == nil) {
        _accountTextField = [[NNTextField alloc] init];
        _accountTextField.placeholder = @"支付宝/微信帐号";
        [_accountTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _accountTextField;
}

- (UIButton *)submitButton
{
    if (_submitButton == nil) {
        _submitButton = [UIButton NNHOperationBtnWithTitle:@"提交" target:self action:@selector(submitAction) operationButtonType:NNHOperationButtonTypeRed isAddCornerRadius:YES];
        _submitButton.nn_acceptEventInterval = 3;
        _submitButton.enabled = NO;
    }
    return _submitButton;
}

- (UIButton *)wechatButton
{
    if (_wechatButton == nil) {
        _wechatButton = [UIButton NNHBtnTitle:@"微信" titileFont:[UIConfigManager fontThemeTextMain] backGround:[UIColor whiteColor] titleColor:[UIConfigManager colorThemeDark]];
        [_wechatButton addTarget:self action:@selector(wechatAction) forControlEvents:UIControlEventTouchUpInside];
        [_wechatButton addTarget:self action:@selector(cancelHighlighted:) forControlEvents:UIControlEventAllTouchEvents];
        [_wechatButton setImage:ImageName(@"ic_login_check_default") forState:UIControlStateNormal];
        [_wechatButton setImage:ImageName(@"ic_login_check_pressed") forState:UIControlStateSelected];
        [_wechatButton nn_setImagePosition:NNImagePositionLeft spacing:8];
        _wechatButton.selected = YES;
    }
    return _wechatButton;
}

- (UIButton *)payButton
{
    if (_payButton == nil) {
        _payButton = [UIButton NNHBtnTitle:@"支付宝" titileFont:[UIConfigManager fontThemeTextMain] backGround:[UIColor whiteColor] titleColor:[UIConfigManager colorThemeDark]];
        [_payButton addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
        [_payButton addTarget:self action:@selector(cancelHighlighted:) forControlEvents:UIControlEventAllTouchEvents];
        [_payButton setImage:ImageName(@"ic_login_check_default") forState:UIControlStateNormal];
        [_payButton setImage:ImageName(@"ic_login_check_pressed") forState:UIControlStateSelected];
        [_payButton nn_setImagePosition:NNImagePositionLeft spacing:8];
    }
    return _payButton;
}

@end
