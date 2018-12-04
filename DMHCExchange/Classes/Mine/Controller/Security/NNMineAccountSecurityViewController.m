//
//  NNMineAccountSecurityViewController.m
//  DMHCExchange
//
//  Created by 牛牛 on 2018/10/24.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import "NNMineAccountSecurityViewController.h"
#import "NNSecurityVerifyViewController.h"
#import "NNHAlertTool.h"

@interface NNMineAccountSecurityViewController ()

/** 修改手机号码 */
@property (nonatomic, strong) NNHMyItem *phoneItem;
/** 修改手机号码 */
@property (nonatomic, strong) NNHMyItem *emailItem;
/** 修改登录密码 */
@property (nonatomic, strong) NNHMyItem *loginPwdItem;
/** 修改支付密码 */
@property (nonatomic, strong) NNHMyItem *payPwdItem;
/** 指纹 */
@property (nonatomic, strong) NNHMyItem *fingerprintItem;
/** 用户数据 */
@property (nonatomic, strong) NNUserModel *userModel;
/** 底部view */
@property (nonatomic, strong) UIView *footerView;

@end

@implementation NNMineAccountSecurityViewController

#pragma mark -
#pragma mark ---------Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.userModel = [NNHProjectControlCenter sharedControlCenter].userControl_currentUserModel;
    [self changeAccountSecurityStatus];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"安全中心";
    self.tableView.backgroundColor = [UIConfigManager colorThemeColorForVCBackground];
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
    group.items = @[self.loginPwdItem, self.payPwdItem, self.phoneItem, self.emailItem, self.fingerprintItem];
}

- (void)changeAccountSecurityStatus
{
    if ([self.userModel.isloginpwd boolValue]) {
        self.loginPwdItem.rightTitle = @"已设置";
        self.loginPwdItem.rightTitleColor = [UIConfigManager colorThemeDarkGray];
    }else{
        self.loginPwdItem.rightTitle = @"未设置";
        self.loginPwdItem.rightTitleColor = [UIConfigManager colorTextLightGray];
    }

    if ([self.userModel.payDec boolValue]) {
        self.payPwdItem.rightTitle = @"已设置";
        self.payPwdItem.rightTitleColor = [UIConfigManager colorThemeDarkGray];
    }else{
        self.payPwdItem.rightTitle = @"未设置";
        self.payPwdItem.rightTitleColor = [UIConfigManager colorTextLightGray];
    }

    if ([self.userModel.mobile isNotBlank]) {
        self.phoneItem.rightTitle = self.userModel.mobile;
        self.phoneItem.rightTitleColor = [UIConfigManager colorThemeDarkGray];
    }else{
        self.phoneItem.rightTitle = @"未设置";
        self.phoneItem.rightTitleColor = [UIConfigManager colorTextLightGray];
    }
    
    if ([self.userModel.email isNotBlank]) {
        self.emailItem.rightTitle = self.userModel.email;
        self.emailItem.rightTitleColor = [UIConfigManager colorThemeDarkGray];
    }else{
        self.emailItem.rightTitle = @"未设置";
        self.emailItem.rightTitleColor = [UIConfigManager colorTextLightGray];
    }
    
    [self.tableView reloadData];
}

- (void)securityVerifyWithVerificationCodeType:(NNHSendVerificationCodeType)verificationCodeType
{
    NNHWeakSelf(self)
    [[NNHAlertTool shareAlertTool] showActionSheet:self title:nil message:@"验证方式" acttionTitleArray:self.userModel.verifyTypeDic.allValues confirm:^(NSInteger index) {
        NSInteger verifyType = [self.userModel.verifyTypeDic.allKeys[index] integerValue];
        NNSecurityVerifyViewController *vc = [[NNSecurityVerifyViewController alloc] initWithSecurityVerifyType:verifyType verificationCodeType:verificationCodeType];
        [weakself.navigationController pushViewController:vc animated:YES];
    } cancle:^{
        
    }];
}

- (NNHMyItem *)phoneItem
{
    if (_phoneItem == nil) {
        _phoneItem = [NNHMyItem itemWithTitle:@"绑定手机" itemAccessoryViewType:NNHItemAccessoryViewTypeRightView];
        NNHWeakSelf(self)
        _phoneItem.operation = ^{
            [weakself securityVerifyWithVerificationCodeType:NNHSendVerificationCodeType_phoneSecurityVerify];
        };
    }
    return _phoneItem;
}

- (NNHMyItem *)emailItem
{
    if (_emailItem == nil) {
        _emailItem = [NNHMyItem itemWithTitle:@"绑定邮箱" itemAccessoryViewType:NNHItemAccessoryViewTypeRightView];
        NNHWeakSelf(self)
        _emailItem.operation = ^{
            [weakself securityVerifyWithVerificationCodeType:NNHSendVerificationCodeType_emailSecurityVerify];
        };
    }
    return _emailItem;
}

- (NNHMyItem *)loginPwdItem
{
    if (_loginPwdItem == nil) {
        _loginPwdItem = [NNHMyItem itemWithTitle:@"修改登录密码" itemAccessoryViewType:NNHItemAccessoryViewTypeRightView];
        NNHWeakSelf(self)
        _loginPwdItem.operation = ^{
            [weakself securityVerifyWithVerificationCodeType:NNHSendVerificationCodeType_changeLoginPassword];
        };
    }
    return _loginPwdItem;
}

- (NNHMyItem *)payPwdItem
{
    if (_payPwdItem == nil) {
        _payPwdItem = [NNHMyItem itemWithTitle:@"修改资金密码" itemAccessoryViewType:NNHItemAccessoryViewTypeRightView];
        NNHWeakSelf(self)
        _payPwdItem.operation = ^{
            [weakself securityVerifyWithVerificationCodeType:NNHSendVerificationCodeType_changePayPassword];
        };
    }
    return _payPwdItem;
}

- (NNHMyItem *)fingerprintItem
{
    if (_fingerprintItem == nil) {
        _fingerprintItem = [NNHMyItem itemWithTitle:@"指纹/面容 ID验证" itemAccessoryViewType:NNHItemAccessoryViewTypeSwitch];
    }
    return _fingerprintItem;
}

#pragma mark -
#pragma mark ---------UserAction
- (void)loginAction
{
    NNHWeakSelf(self)
    [[NNHAlertTool shareAlertTool] showAlertView:self title:@"确定要退出登录吗?" message:nil cancelButtonTitle:@"取消" otherButtonTitle:@"确定" confirm:^{
        
        [[NNHProjectControlCenter sharedControlCenter].userControl logOut];
        
        if (weakself.logoutSuccessBlock) {
            weakself.logoutSuccessBlock();
        }
        
        [weakself.navigationController popViewControllerAnimated:NO];
        
    } cancle:^{
        
    }];
}

#pragma mark -
#pragma mark ---------Getters & Setters
- (UIView *)footerView
{
    if (_footerView == nil) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        
        UIButton *logoutButton =  [UIButton NNHOperationBtnWithTitle:@"退出登录" target:self action:@selector(loginAction) operationButtonType:NNHOperationButtonTypeGrey isAddCornerRadius:NO];
        [_footerView addSubview:logoutButton];
        [logoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(NNHMargin_15);
            make.right.mas_equalTo(-NNHMargin_15);
            make.top.equalTo(_footerView).offset(56);
            make.bottom.equalTo(_footerView);
        }];
    }
    return _footerView;
}

@end
