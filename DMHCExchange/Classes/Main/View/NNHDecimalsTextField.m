//
//  NNHDecimalsTextField.m
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/11/6.
//  Copyright © 2018 超级钱包. All rights reserved.
//

#import "NNHDecimalsTextField.h"

@interface NNHDecimalsTextField ()<UITextFieldDelegate>

@end

@implementation NNHDecimalsTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor whiteColor];
        self.textColor = [UIConfigManager colorThemeDark];
        self.font = [UIConfigManager fontThemeTextDefault];
        self.delegate = self;
        self.frontPlacesCount = 9;
        self.afterPlacesCount = 2;
    }
    return self;
}

#define myDotNumbers     @"0123456789.\n"
#define myNumbers          @"0123456789\n"

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (self.nnhDelegate && [self.nnhDelegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        [self.nnhDelegate nnh_textField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    
    // 判断是否输入内容，或者用户点击的是键盘的删除按钮
    if (![string isEqualToString:@""]) {
        NSCharacterSet *cs;
        // 小数点在字符串中的位置 第一个数字从0位置开始
        NSInteger dotLocation = [textField.text rangeOfString:@"."].location;
        // 判断字符串中是否有小数点，并且小数点不在第一位
        // NSNotFound 表示请求操作的某个内容或者item没有发现，或者不存在
        // range.location 表示的是当前输入的内容在整个字符串中的位置，位置编号从0开始
        if (dotLocation == NSNotFound && range.location != 0) {
            // 取只包含“myDotNumbers”中包含的内容，其余内容都被去掉
            /* [NSCharacterSet characterSetWithCharactersInString:myDotNumbers]的作用是去掉"myDotNumbers"中包含的所有内容，只要字符串中有内容与"myDotNumbers"中的部分内容相同都会被舍去在上述方法的末尾加上invertedSet就会使作用颠倒，只取与“myDotNumbers”中内容相同的字符
             */
            cs = [[NSCharacterSet characterSetWithCharactersInString:myDotNumbers] invertedSet];
            if (range.location >= self.frontPlacesCount) {
                NNHLog(@"单笔金额不能超过亿位");
                if ([string isEqualToString:@"."] && range.location == self.frontPlacesCount) {
                    return YES;
                }
                return NO;
            }
        }else {
            cs = [[NSCharacterSet characterSetWithCharactersInString:myNumbers] invertedSet];
        }
        // 按cs分离出数组,数组按@""分离出字符串
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        if (!basicTest) {
            NNHLog(@"只能输入数字和小数点");
            return NO;
        }
        if (dotLocation != NSNotFound && range.location > dotLocation + self.afterPlacesCount) {
            NNHLog(@"小数点后最多两位");
            return NO;
        }
        if (textField.text.length > self.frontPlacesCount + self.afterPlacesCount) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.nnhDelegate && [self.nnhDelegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
        return [self.nnhDelegate nnh_textFieldShouldBeginEditing:textField];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.nnhDelegate && [self.nnhDelegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        [self.nnhDelegate nnh_textFieldDidBeginEditing:textField];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (self.nnhDelegate && [self.nnhDelegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
        return [self.nnhDelegate nnh_textFieldShouldEndEditing:textField];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.nnhDelegate && [self.nnhDelegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        return [self.nnhDelegate nnh_textFieldDidEndEditing:textField];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason
API_AVAILABLE(ios(10.0)){
    if (self.nnhDelegate && [self.nnhDelegate respondsToSelector:@selector(textFieldDidEndEditing:reason:)]) {
        [self.nnhDelegate nnh_textFieldDidEndEditing:textField reason:reason];
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if (self.nnhDelegate && [self.nnhDelegate respondsToSelector:@selector(textFieldShouldClear:)]) {
        return [self.nnhDelegate nnh_textFieldShouldClear:textField];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.nnhDelegate && [self.nnhDelegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
        return [self.nnhDelegate nnh_textFieldShouldReturn:textField];
    }
    return YES;
}


@end
