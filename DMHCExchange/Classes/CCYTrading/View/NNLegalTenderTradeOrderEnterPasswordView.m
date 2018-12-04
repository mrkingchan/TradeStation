//
//  NNLegalTenderTradeOrderEnterPasswordView.m
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/29.
//  Copyright © 2018 超级钱包. All rights reserved.
//

#import "NNLegalTenderTradeOrderEnterPasswordView.h"
#import "UITextField+NNHExtension.h"

@interface NNLegalTenderTradeOrderEnterPasswordView ()

/** 资金密码 */
@property (nonatomic, strong) UITextField *payCodeTextField;

@end

@implementation NNLegalTenderTradeOrderEnterPasswordView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIConfigManager colorThemeWhite];
        [self setupChildView];
    }
    return self;
}

- (void)setupChildView
{
    UILabel *titleLabel = [UILabel NNHWithTitle:@"资金密码" titleColor:[UIConfigManager colorThemeBlack] font:[UIConfigManager fontThemeTextDefault]];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(NNHMargin_15);
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.payCodeTextField];
    [self.payCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.mas_right).offset(NNHMargin_20);
        make.top.bottom.equalTo(self);
        make.width.equalTo(@(SCREEN_WIDTH - 100));
    }];
}


#pragma mark - Private Methods

- (void)textFieldDidChange:(UITextField *)textField
{
    if (self.passwordActionBlock) {
        self.passwordActionBlock(textField.text);
    }
}

#pragma mark - Lazy Loads

- (UITextField *)payCodeTextField
{
    if (_payCodeTextField == nil) {
        _payCodeTextField = [[UITextField alloc] init];
        _payCodeTextField.font = [UIConfigManager fontThemeTextDefault];
        _payCodeTextField.placeholder = @"请输入资金密码";
        _payCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
        [_payCodeTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _payCodeTextField.nn_maxLength = 6;
        _payCodeTextField.secureTextEntry = YES;
    }
    return _payCodeTextField;
}

@end


