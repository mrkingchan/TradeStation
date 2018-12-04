//
//  NNHLoginTextField.m
//  TFC
//
//  Created by 牛牛 on 2018/6/25.
//  Copyright © 2018年 牛牛汇. All rights reserved.
//

#import "NNHLoginTextField.h"

@interface NNHLoginTextField ()

/** 眼睛按钮 */
@property (nonatomic, strong) UIButton *secureButton;

@end

@implementation NNHLoginTextField

- (instancetype)init
{
    if (self = [super init]){
        self.textColor = [UIConfigManager colorThemeDark];
        self.font = [UIConfigManager fontThemeTextMain];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor akext_colorWithHex:@"d9d9d9"].CGColor);
    CGContextFillRect(context, CGRectMake(0, CGRectGetHeight(self.frame) - 0.5, CGRectGetWidth(self.frame), 0.5));
}

- (void)setPlaceholder:(NSString *)placeholder
{
    [super setPlaceholder:placeholder];
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName:[UIConfigManager colorThemeDarkGray]}];
}

- (void)setShowSecureButotn:(BOOL)showSecureButotn
{
    _showSecureButotn = showSecureButotn;
    self.secureTextEntry = YES;
    self.rightView = self.secureButton;
    self.rightViewMode = showSecureButotn ?  UITextFieldViewModeAlways : UITextFieldViewModeNever;
}

- (void)secureButtonClick:(UIButton *)button
{
    button.selected = !button.selected;
    self.secureTextEntry = button.selected;
    
    //避免出现明文密文转换时，光标偏移的bug
    NSString *text = self.text;
    self.text = @"";
    self.text = text;
}

/** 眼睛按钮 */
- (UIButton *)secureButton
{
    if (_secureButton == nil) {
        _secureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _secureButton.frame = CGRectMake(0, 0, NNHNormalViewH, NNHNormalViewH);
        [_secureButton setImage:[UIImage imageNamed:@"ic_login_open_eye"] forState:UIControlStateNormal];
        [_secureButton setImage:[UIImage imageNamed:@"ic_login_close_eye"] forState:UIControlStateSelected];
        [_secureButton addTarget:self action:@selector(secureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _secureButton.adjustsImageWhenHighlighted = NO;
        _secureButton.selected = YES;
    }
    return _secureButton;
}

@end
