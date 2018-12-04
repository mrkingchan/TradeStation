//
//  NNCoinTextField.m
//  DMHCExchange
//
//  Created by 牛牛 on 2018/11/1.
//  Copyright © 2018年 超级钱包. All rights reserved.
//

#import "NNCoinTextField.h"

@implementation NNCoinTextField

- (instancetype)init
{
    if (self = [super init]){
        self.backgroundColor = [UIColor whiteColor];
        self.textColor = [UIConfigManager colorTextLightGray];
        self.font = [UIConfigManager fontThemeTextDefault];
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [UIConfigManager colorThemeSeperatorLightGray].CGColor;        
        self.keyboardType = UIKeyboardTypeDecimalPad;
    }
    return self;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    [super setPlaceholder:placeholder];
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName:[UIConfigManager colorTextLightGray],}];
}

//控制文本所在的的位置，左右缩 10
- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset( bounds , 10 , 0 );
}

//控制编辑文本时所在的位置，左右缩 10
- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectInset( bounds , 10 , 0 );
}

@end
