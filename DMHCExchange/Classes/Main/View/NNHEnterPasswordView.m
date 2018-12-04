//
//  NNHEnterPasswordView.m
//  WBTMall
//
//  Created by 来旭磊 on 17/4/7.
//  Copyright © 2017年 牛牛汇. All rights reserved.
//

#import "NNHEnterPasswordView.h"
#import "NNHApplicationHelper.h"

@interface NNHEnterPasswordView ()<UITextFieldDelegate>

/** 背景灰色view **/
@property (nonatomic, strong) UIImageView *imageViewBack;
/** 底部view */
@property (nonatomic, strong) UIView *backgroundView;
/** 关闭按钮 **/
@property (nonatomic, strong) UIButton *closeButton;
/** 付款详情label */
@property (nonatomic, strong) UILabel *enterTitleLabel;

/** 余额资金密码 */
@property (nonatomic, strong) UITextField *codeField;
/** 密码输入控件 */
@property (nonatomic, strong) UIView *codeView;
/** 保存输入字符 */
@property (nonatomic, strong) NSMutableArray *passwordArray;
/** 忘记密码 */
@property (nonatomic, strong) UIButton *missCodeButton;

@end

@implementation NNHEnterPasswordView

- (void)dealloc
{
    NNHLog(@"支付控件消失");
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupChildView];
    }
    return self;
}

- (void)setupChildView
{
    [self addSubview:self.imageViewBack];
    [self addSubview:self.backgroundView];
    
    [self.imageViewBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    self.backgroundView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT * 0.6);
    
    [self.backgroundView addSubview:self.enterTitleLabel];
    [self.backgroundView addSubview:self.closeButton];
    [self.backgroundView addSubview:self.codeField];
    
    
    [self.backgroundView addSubview:self.enterTitleLabel];
    [self.enterTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backgroundView);
        make.height.equalTo(@60);
        make.top.equalTo(self.backgroundView);
    }];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.enterTitleLabel);
        make.right.equalTo(self.backgroundView);
        make.size.mas_equalTo(CGSizeMake(NNHNormalViewH, NNHNormalViewH));
    }];
    
    [self.codeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.enterTitleLabel.mas_bottom);
        make.left.equalTo(self.backgroundView).offset(NNHMargin_15);
        make.width.equalTo(@(SCREEN_WIDTH - 30));
        make.height.equalTo(@(NNHNormalViewH));
    }];
    [self.backgroundView addSubview:self.codeView];
    [self.codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.codeField);
    }];
    
    [self.backgroundView setNeedsLayout];
    [self.backgroundView layoutIfNeeded];
    
    //创建5条竖线来分割payTextField
    for (int i = 0; i < 5; i++) {
        UIImageView *lineImageView = [[UIImageView alloc] init];
        CGFloat lineWidth = (SCREEN_WIDTH - 30) / 6;
        lineImageView.frame = CGRectMake(lineWidth * (i + 1), 0, 1, self.codeField.bounds.size.height);
        lineImageView.backgroundColor = [UIConfigManager colorThemeSeperatorDarkGray];
        [self.codeView addSubview:lineImageView];
    }
    //在分割好的6个框中间都放入一个 黑色的圆点 来代表输入的密码
    for (int i = 0; i < 6; i++) {
        UIImageView *passWordImageView = [[UIImageView alloc] init];
        CGFloat pwX = (SCREEN_WIDTH - 30) / 6;
        passWordImageView.bounds = CGRectMake(0, 0, 10, 10);
        passWordImageView.center = CGPointMake(pwX/2 + pwX * i, self.codeField.bounds.size.height/2);
        passWordImageView.backgroundColor = [UIColor blackColor];
        passWordImageView.layer.cornerRadius = 10/2;
        passWordImageView.clipsToBounds = YES;
        passWordImageView.hidden = YES;
        [self.codeView addSubview:passWordImageView];
        [self.passwordArray addObject:passWordImageView];
    }
    
    [self.backgroundView addSubview:self.missCodeButton];
    [self.missCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.codeField.mas_right);
        make.top.equalTo(self.codeField.mas_bottom);
        make.height.equalTo(@(NNHNormalViewH));
        make.width.equalTo(@80);
    }];
}

- (void)showInFatherView:(UIView *)fatherView
{
    [fatherView addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(fatherView);
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundView.nnh_y = SCREEN_HEIGHT * 0.4;
    } completion:^(BOOL finished) {
        [self resetStatus];
    }];
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

/** 取消付款控件动画效果 */
- (void)dissmissWithCompletion:(void (^)(void))completion
{
    [SVProgressHUD dismiss];
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.codeField resignFirstResponder];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            
            self.backgroundView.nnh_y = SCREEN_HEIGHT;
        } completion:^(BOOL finished) {
            if (completion) {
                completion();
            }
            [self removeFromSuperview];
        }];
    }];
}

/** 输入资金密码 */
- (void)textFieldDidChange:(UITextField *)textField
{
    NSInteger count = textField.text.length;
    
    if (count == 0) {
        for (int i = 0; i < self.passwordArray.count; i ++) {
            UIImageView *imageView = self.passwordArray[i];
            imageView.hidden = YES;
        }
    }else {
        for (int i = 0; i < self.passwordArray.count; i ++) {
            UIImageView *imageView = self.passwordArray[i];
            if (i < count) {
                imageView.hidden = NO;
            }else{
                imageView.hidden = YES;
            }
        }
    }
    
    if (textField.text.length == 6) {
        textField.enabled = NO;
        if (self.didEnterCodeBlock) {
            [SVProgressHUD showWithStatus:nil];
            
            self.didEnterCodeBlock(textField.text);
        }
    }
    if (textField.text.length > 6) {
        textField.text = [textField.text substringToIndex:6];
    }
}

- (void)resetStatus
{
    [SVProgressHUD dismiss];
    self.codeField.enabled = YES;
    self.codeField.text = @"";
    for (int i = 0; i < self.passwordArray.count; i ++) {
        UIImageView *imageView = self.passwordArray[i];
        imageView.hidden = YES;
    }
    
    [self.codeField becomeFirstResponder];
}

- (void)closeAction
{
    // 输入view消失
    [self dissmissWithCompletion:^{
        
    }];
}

/** 点击弹出键盘 */
- (void)payCodeViewAction
{
    [self.codeField becomeFirstResponder];
}

/** 忘记密码 */
- (void)missPayCode
{
    [self dissmissWithCompletion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NNHApplicationHelper sharedInstance] forgetPayPassword];
    });
}

#pragma mark -
#pragma mark ---------Getter && Setter
/** 背景灰色图片 */
- (UIImageView *)imageViewBack
{
    if (_imageViewBack == nil) {
        _imageViewBack = [[UIImageView alloc]init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeAction)];
        _imageViewBack.userInteractionEnabled = YES;
        [_imageViewBack addGestureRecognizer:tap];
        _imageViewBack.backgroundColor = [UIColor akext_colorWithHex:@"000000"];
        _imageViewBack.alpha = 0.6;
    }
    return _imageViewBack;
}

- (UIView *)backgroundView
{
    if (_backgroundView == nil) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = [UIConfigManager colorThemeColorForVCBackground];
    }
    return _backgroundView;
}

- (UIButton *)closeButton
{
    if (_closeButton == nil) {
        _closeButton = [UIButton NNHBtnImage:@"icon_pay_close" target:self action:@selector(closeAction)];
    }
    return _closeButton;
}

- (UILabel *)enterTitleLabel
{
    if (_enterTitleLabel == nil) {
        _enterTitleLabel = [UILabel NNHWithTitle:@"请输入支付密码" titleColor:[UIConfigManager colorThemeBlack] font:[UIConfigManager fontThemeLargerBtnTitles]];
    }
    return _enterTitleLabel;
}

- (UITextField *)codeField
{
    if (_codeField == nil) {
        _codeField = [[UITextField alloc] init];
        _codeField.backgroundColor = [UIColor whiteColor];
        _codeField.borderStyle = UITextBorderStyleRoundedRect;
        _codeField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _codeField.keyboardType = UIKeyboardTypeNumberPad;
        _codeField.tintColor = [UIColor clearColor];
        _codeField.secureTextEntry = YES;
        [_codeField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _codeField;
}

- (NSMutableArray *)passwordArray
{
    if (_passwordArray == nil) {
        _passwordArray = [NSMutableArray array];
    }
    return _passwordArray;
}

- (UIView *)codeView
{
    if (_codeView == nil) {
        _codeView = [[UIView alloc] init];
        _codeView.backgroundColor = [UIColor whiteColor];
        _codeView.layer.cornerRadius = NNHMargin_5;
        _codeView.layer.borderColor = [UIConfigManager colorThemeSeperatorDarkGray].CGColor;
        _codeView.layer.borderWidth = NNHLineH;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(payCodeViewAction)];
        [_codeView addGestureRecognizer:tap];
    }
    return _codeView;
}

- (UIButton *)missCodeButton
{
    if (_missCodeButton == nil) {
        _missCodeButton = [UIButton NNHBorderBtnTitle:@"忘记密码？" borderColor:[UIColor clearColor] titleColor:[UIConfigManager colorBlueOperation]];
        [_missCodeButton addTarget:self action:@selector(missPayCode) forControlEvents:UIControlEventTouchUpInside];
        [_missCodeButton setTitleColor:[UIColor akext_colorWithHex:@"#1c94e8"] forState:UIControlStateNormal];
    }
    return _missCodeButton;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

@end

