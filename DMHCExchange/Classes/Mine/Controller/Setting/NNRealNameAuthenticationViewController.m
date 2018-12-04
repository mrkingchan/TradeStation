//
//  NNRealNameAuthenticationViewController.m
//  YWL
//
//  Created by 牛牛 on 2018/5/8.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

typedef NS_ENUM(NSInteger, NNCertificateType) {
    NNCertificateTypeChina  = 0,      // 中国
    NNCertificateTypeOther  = 1       // 其他
};

#import "NNRealNameAuthenticationViewController.h"
#import "NNImagePickerViewController.h"
#import "NNHPickerVeiw.h"
#import "NNHCountryCodeModel.h"
#import "NNHAlertTool.h"
#import "NNTextField.h"
#import "NNAPIMineTool.h"
#import "NNHApiLoginTool.h"
#import "NNUploadImageTool.h"

@interface NNRealNameAuthenticationViewController ()

/** 类型 */
@property (nonatomic, strong) NNHMyItem *certificateItem;
@property (nonatomic, assign) NNCertificateType currentCertificateType;
/** 姓名 */
@property (nonatomic, strong) NNHMyItem *nameItem;
/** 身份 */
@property (nonatomic, strong) NNHMyItem *idCardItem;

/** 其他国家组 */
@property (nonatomic, strong) NNHMyGroup *otherGroup;
/** 性别 */
@property (nonatomic, strong) NNHMyItem *sexItem;
/** 地区 */
@property (nonatomic, strong) NNHMyItem *areaItem;
/** 护照 */
@property (nonatomic, strong) NNHMyItem *passportItem;

/** 姓名 */
@property (nonatomic, strong) NNTextField *nameTextField;
/** 身份 */
@property (nonatomic, strong) NNTextField *idCardTextField;
/** 护照 */
@property (nonatomic, strong) NNTextField *passportTextField;

/** 证件照片 */
@property (nonatomic, strong) NSMutableArray *photos;
/** 底部view */
@property (nonatomic, strong) UIView *footerView;
/** 国家编码view */
@property (nonatomic, strong) NNHPickerVeiw *countrycodeView;
/** 国家编码 */
@property (nonatomic, strong) NSArray <NNHCountryCodeModel *> *countrycodeArr;
@property (nonatomic, strong) NNHCountryCodeModel *currentCountryCodeModel;
/** 是否请求国家编码 */
@property (nonatomic, assign, getter=isRequestCountryCode) BOOL requestCountryCode;
/** 当前性别 */
@property (nonatomic, copy) NSString *currentSex;

@end

@implementation NNRealNameAuthenticationViewController

#pragma mark -
#pragma mark ---------Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIConfigManager colorThemeColorForVCBackground];
    self.navigationItem.title = @"实名认证";
    
    self.currentSex = @"1";
    self.requestCountryCode = YES;
    self.tableView.rowHeight = 60;
    self.tableView.tableFooterView = self.footerView;
    
    [self setupGroups];
}

- (void)setupGroups
{
    [self setupGroup0];
    [self.tableView reloadData];
}

- (void)setupGroup0
{
    // 1.创建组
    NNHMyGroup *group = [NNHMyGroup group];
    [self.groups addObject:group];
    
    // 2.设置组的所有行数据
    self.nameItem.customRightView = self.nameTextField;
    self.idCardItem.customRightView = self.idCardTextField;
    
    group.items = @[self.certificateItem,self.nameItem,self.idCardItem];
}

- (void)resetUI
{
    if (self.currentCertificateType == NNCertificateTypeChina) {
        self.nameItem.title = @"真实姓名";
        self.nameTextField.placeholder = @"请输入真实姓名";
        self.idCardItem.title = @"身份证号";
        self.idCardTextField.placeholder = @"请输入身份证号";
        
        if ([self.groups containsObject:self.otherGroup]) {
            [self.groups removeObject:self.otherGroup];
        }
    }else {
        self.nameItem.title = @"姓氏";
        self.nameTextField.placeholder = @"请输入真实姓氏";
        self.idCardItem.title = @"名字";
        self.idCardTextField.placeholder = @"请输入真实名字";
        
        if (![self.groups containsObject:self.otherGroup]) {
            [self.groups addObject:self.otherGroup];
        }
    }
    
    [self.tableView reloadData];
}

- (void)requestCodeData
{
    NNHWeakSelf(self)
    NNHApiLoginTool *loginTool = [[NNHApiLoginTool alloc] initCountryCodeData];
    [loginTool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
        weakself.requestCountryCode = NO;
        weakself.countrycodeArr = [NNHCountryCodeModel mj_objectArrayWithKeyValuesArray:responseDic[@"data"]];
    } failBlock:^(NNHRequestError *error) {
        
    } isCached:NO];
}

#pragma mark -
#pragma mark ---------UserAction
- (void)sureRealNameAction
{
    if (self.currentCertificateType == NNCertificateTypeChina) {
        if (!self.nameTextField.hasText) {
            [SVProgressHUD showMessage:@"请填写真实姓名"];
            return;
        }
        if (!self.idCardTextField.hasText) {
            [SVProgressHUD showMessage:@"请填写真实姓名"];
            return;
        }
    }else {
        if (!self.nameTextField.hasText || !self.idCardTextField.hasText) {
            [SVProgressHUD showMessage:@"请填写姓氏或名字"];
            return;
        }
        if (![self.currentCountryCodeModel.scode isNotBlank]) {
            [SVProgressHUD showMessage:@"请选择国家及地区"];
            return;
        }
        if (!self.passportTextField.hasText) {
            [SVProgressHUD showMessage:@"请填写护照ID"];
            return;
        }
    }
    
    if (![self.photos[0] isNotBlank]) {
        [SVProgressHUD showMessage:@"请上传证件正面照"];
        return;
    }
    if (![self.photos[1] isNotBlank]) {
        [SVProgressHUD showMessage:@"请上传证件反面照"];
        return;
    }
    if (![self.photos[2] isNotBlank]) {
        [SVProgressHUD showMessage:@"请上传手持证件照"];
        return;
    }
    
    NSString *realNameStr = self.nameTextField.text;
    NSString *idCardStr = self.idCardTextField.text;
    if (self.currentCertificateType == NNCertificateTypeOther) {
        realNameStr = [NSString stringWithFormat:@"%@%@",self.idCardTextField.text,self.nameTextField.text];
        idCardStr = self.passportTextField.text;
    }

    NNHWeakSelf(self)
    [SVProgressHUD nn_showWithStatus:@"提交中"];
    NNAPIMineTool *tool = [[NNAPIMineTool alloc] initWithRealName:realNameStr idnumber:idCardStr idcardimg:[self.photos componentsJoinedByString:@","] countrycode:self.currentCountryCodeModel.code sex:self.currentSex isoverseas:self.currentCertificateType == NNCertificateTypeOther];
    [tool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
        [SVProgressHUD showMessage:@"提交成功"];
        
        // 修改状态
        NNUserModel *userModel = [NNHProjectControlCenter sharedControlCenter].userControl_currentUserModel;
        userModel.isnameauth = @"2";
        [[NNHProjectControlCenter sharedControlCenter] userControl_saveUserDataWithUserInfo:userModel];
        
        [weakself.navigationController popViewControllerAnimated:YES];
        
    } failBlock:^(NNHRequestError *error) {

    } isCached:NO];
}

- (void)uploadPhotoAction:(UIButton *)button
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
            [button setImage:[photos lastObject] forState:UIControlStateNormal];
            [weakself.photos replaceObjectAtIndex:button.tag - 1000 withObject:upUrl];
        } failedBlock:^(NNHRequestError *error) {

        }];
    }];

    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (NNHMyItem *)certificateItem
{
    if (_certificateItem == nil) {
        _certificateItem = [NNHMyItem itemWithTitle:@"证件类型" itemAccessoryViewType:NNHItemAccessoryViewTypeRightView];
        _certificateItem.rightTitle = @"中国大陆地区";
        
        NSDictionary *certificateDic = @{@(NNCertificateTypeChina) : @"中国大陆地区",@(NNCertificateTypeOther) : @"其他国家和地区"};
        NNHWeakSelf(self)
        NNHWeakSelf(_certificateItem)
        _certificateItem.operation = ^{
            NNHStrongSelf(self)
            NNHStrongSelf(_certificateItem)
            [[NNHAlertTool shareAlertTool] showActionSheet:strongself title:nil message:@"选择证件类型" acttionTitleArray:certificateDic.allValues confirm:^(NSInteger index) {
                
                // 更新对应UI
                strongself.currentCertificateType = [certificateDic.allKeys[index] integerValue];
                strong_certificateItem.rightTitle = certificateDic.allValues[index];
                [strongself resetUI];
                
                // 获取国家编码
                if (strongself.currentCertificateType == NNCertificateTypeOther && strongself.isRequestCountryCode) {
                    [strongself requestCodeData];
                }
                
            } cancle:^{
                
            }];
        };
    }
    return _certificateItem;
}

- (NNHMyItem *)nameItem
{
    if (_nameItem == nil) {
        _nameItem = [NNHMyItem itemWithTitle:@"真实姓名" itemAccessoryViewType:NNHItemAccessoryViewTypeCustomView];
    }
    return _nameItem;
}

- (NNHMyItem *)idCardItem
{
    if (_idCardItem == nil) {
        _idCardItem = [NNHMyItem itemWithTitle:@"身份证号" itemAccessoryViewType:NNHItemAccessoryViewTypeCustomView];
    }
    return _idCardItem;
}

- (NNHMyItem *)sexItem
{
    if (_sexItem == nil) {
        _sexItem = [NNHMyItem itemWithTitle:@"性别" itemAccessoryViewType:NNHItemAccessoryViewTypeRightView];
        _sexItem.rightTitle = @"男";
        
        NSArray *sexArr = @[@"男",@"女"];
        NNHWeakSelf(self)
        NNHWeakSelf(_sexItem)
        _sexItem.operation = ^{
            NNHStrongSelf(self)
            NNHStrongSelf(_sexItem)
            [[NNHAlertTool shareAlertTool] showActionSheet:strongself title:nil message:@"选择性别" acttionTitleArray:sexArr confirm:^(NSInteger index) {
                strongself.currentSex = [NSString stringWithFormat:@"%zd",index + 1];
                strong_sexItem.rightTitle = sexArr[index];
                [strongself.tableView reloadData];
            } cancle:^{
                
            }];
        };
    }
    return _sexItem;
}

- (NNHMyItem *)areaItem
{
    if (_areaItem == nil) {
        _areaItem = [NNHMyItem itemWithTitle:@"国家及地区" itemAccessoryViewType:NNHItemAccessoryViewTypeRightView];
        _areaItem.rightTitle = @"请选择";
        NNHWeakSelf(self)
        _areaItem.operation = ^{
            [weakself.countrycodeView showWithAnimation:YES fatherView:weakself.navigationController.view];
            [weakself.countrycodeView reloadAllData];
        };
    }
    return _areaItem;
}

- (NNHMyItem *)passportItem
{
    if (_passportItem == nil) {
        _passportItem = [NNHMyItem itemWithTitle:@"护照ID/其他" itemAccessoryViewType:NNHItemAccessoryViewTypeCustomView];
    }
    
    if (!_passportItem.customRightView) {
        _passportItem.customRightView = self.passportTextField;
    }

    return _passportItem;
}

- (NNHMyGroup *)otherGroup
{
    if (_otherGroup == nil) {
        _otherGroup = [NNHMyGroup group];
    }
    
    if (_otherGroup.items.count == 0) {
        _otherGroup.items = @[self.sexItem, self.areaItem, self.passportItem];
    }
    
    return _otherGroup;
}

- (NNTextField *)nameTextField
{
    if (_nameTextField == nil) {
        _nameTextField = [[NNTextField alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH -100, 44)];
        _nameTextField.textAlignment = NSTextAlignmentRight;
        _nameTextField.placeholder = @"请输入用户名";
    }
    return _nameTextField;
}

- (NNTextField *)idCardTextField
{
    if (_idCardTextField == nil) {
        _idCardTextField = [[NNTextField alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH -100, 44)];
        _idCardTextField.textAlignment = NSTextAlignmentRight;
        _idCardTextField.placeholder = @"请输入身份证号";
    }
    return _idCardTextField;
}

- (NNTextField *)passportTextField
{
    if (_passportTextField == nil) {
        _passportTextField = [[NNTextField alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH -100, 44)];
        _passportTextField.textAlignment = NSTextAlignmentRight;
        _passportTextField.placeholder = @"请输入护照ID/其他";
        _passportTextField.keyboardType = UIKeyboardTypeASCIICapable;
    }
    return _passportTextField;
}

- (NSMutableArray *)photos
{
    if (_photos == nil) {
        _photos = [NSMutableArray arrayWithObjects:@"",@"",@"", nil];
    }
    return _photos;
}

- (UIView *)footerView
{
    if (_footerView == nil) {
        
        CGFloat btnW = (SCREEN_WIDTH - 40) / 2;
        CGFloat btnH = btnW * 2 / 3;
        
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 700)];
        _footerView.backgroundColor = [UIConfigManager colorThemeColorForVCBackground];
        
        // 图片区域
        UIView *photoContntView = [[UIView alloc] init];
        photoContntView.backgroundColor = [UIColor whiteColor];
        [_footerView addSubview:photoContntView];
        [photoContntView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_footerView).offset(10);
            make.left.right.equalTo(_footerView);
        }];
        
        UILabel *photoPromptLabel = [UILabel NNHWithTitle:@"请上传证件照" titleColor:[UIConfigManager colorThemeDark] font:[UIConfigManager fontThemeTextMain]];
        [photoContntView addSubview:photoPromptLabel];
        [photoPromptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(photoContntView);
            make.left.equalTo(photoContntView).offset(15);
            make.height.equalTo(@60);
        }];
        
        UIButton *photoOneButton = [UIButton NNHBtnImage:@"btn_id_front" target:self action:@selector(uploadPhotoAction:)];
        photoOneButton.tag = 1000;
        [photoContntView addSubview:photoOneButton];
        [photoOneButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(photoPromptLabel.mas_bottom);
            make.left.equalTo(photoContntView).offset(15);
            make.width.equalTo(@(btnW));
            make.height.equalTo(@(btnH));
        }];
        
        UIButton *photoTwoButton = [UIButton NNHBtnImage:@"btn_id_rear" target:self action:@selector(uploadPhotoAction:)];
        photoTwoButton.tag = 1001;
        [photoContntView addSubview:photoTwoButton];
        [photoTwoButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(photoOneButton);
            make.right.equalTo(photoContntView).offset(-15);
            make.size.equalTo(photoOneButton);
        }];
        
        UIButton *photoThreeButton = [UIButton NNHBtnImage:@"btn_id_front_sign" target:self action:@selector(uploadPhotoAction:)];
        photoThreeButton.tag = 1002;
        [photoContntView addSubview:photoThreeButton];
        [photoThreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(photoOneButton.mas_bottom).offset(10);
            make.left.equalTo(photoOneButton);
            make.size.equalTo(photoOneButton);
            make.bottom.equalTo(photoContntView).offset(-15);
        }];
        
        // 提示
        NSString *tip = @"照片要求：jpg格式/png格式，大小不超过5M，信息清晰";
        UILabel *tipLabel = [UILabel NNHWithTitle:tip titleColor:[UIConfigManager colorThemeDarkGray] font:[UIConfigManager fontThemeTextMinTip]];
        [_footerView addSubview:tipLabel];
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(photoContntView.mas_bottom).offset(20);
            make.left.equalTo(_footerView).offset(NNHMargin_15);
            make.width.equalTo(@(SCREEN_WIDTH - 30));
        }];
        
        NSString *content = @"*以下错误将导致审核不通过：\n1.证件过期或上传的证件信息模糊，\n2.填写的证件号，姓名与实际信息不一致，\n3.手持照缺用户名，用户名错误，用户名不清晰或明忽明非手写等。";
        UILabel *contentLabel = [UILabel NNHWithTitle:content titleColor:[UIConfigManager colorThemeDarkGray] font:[UIConfigManager fontThemeTextMinTip]];
        contentLabel.numberOfLines = 0;
        contentLabel.attributedText = [NSMutableAttributedString nn_changeLineSpaceWithTotalString:content LineSpace:10];
        [_footerView addSubview:contentLabel];
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(tipLabel.mas_bottom).offset(20);
            make.left.equalTo(tipLabel);
            make.width.equalTo(tipLabel);
        }];
        
        UIButton *sureButton = [UIButton NNHOperationBtnWithTitle:@"提交" target:self action:@selector(sureRealNameAction) operationButtonType:NNHOperationButtonTypeRed isAddCornerRadius:YES];
        [_footerView addSubview:sureButton];
        [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentLabel.mas_bottom).offset(40);
            make.left.equalTo(tipLabel);
            make.width.equalTo(tipLabel);
            make.height.equalTo(@(NNHNormalViewH));
        }];        
    }
    
    return _footerView;
}

- (NNHPickerVeiw *)countrycodeView
{
    if (_countrycodeView == nil) {
        _countrycodeView = [[NNHPickerVeiw alloc] init];
        NNHWeakSelf(self);
        _countrycodeView.numberOfComponents = ^NSUInteger{
            return 1;
        };
        _countrycodeView.numberOfRows = ^NSUInteger (NSInteger Components){
            return weakself.countrycodeArr.count;
        };
        _countrycodeView.widthForComponent = ^CGFloat ((NSInteger Component)){
            return  SCREEN_WIDTH;
        };
        _countrycodeView.viewForRowAndComponent = ^ UIView *(NSInteger Component,NSInteger Row,UIView *resuseView){
            NNHCountryCodeModel *countryCodeModel = weakself.countrycodeArr[Row];
            NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:countryCodeModel.name attributes:@{NSForegroundColorAttributeName:[UIConfigManager colorThemeDark],NSFontAttributeName:[UIConfigManager fontThemeTextMain]}];
            UILabel *label;
            if (resuseView == nil) {
                label = [[UILabel alloc] init];
                label.attributedText = attributeStr;
                label.textAlignment = NSTextAlignmentCenter;
            }else{
                label.attributedText = attributeStr;
            }
            return label;
        };
        _countrycodeView.didSelectedRowAndComponent = ^(NSInteger Component,NSInteger Row){
            weakself.currentCountryCodeModel = weakself.countrycodeArr[Row];
            weakself.areaItem.rightTitle = weakself.currentCountryCodeModel.name;
            [weakself.tableView reloadData];
        };
    }
    return _countrycodeView;
}

@end
