//
//  UITextField+NNHExtension.m
//  DMHCAMU
//
//  Created by 牛牛 on 2017/7/15.
//  Copyright © 2017年 牛牛汇. All rights reserved.
//

#import "UITextField+NNHExtension.h"
#import <objc/runtime.h>

static const void *NNTextFieldInputLimitMaxLength = &NNTextFieldInputLimitMaxLength;

@implementation UITextField (NNHExtension)

- (NSInteger)nn_maxLength
{
    return [objc_getAssociatedObject(self, NNTextFieldInputLimitMaxLength) integerValue];
}

- (void)setNn_maxLength:(NSInteger)maxLength
{
    objc_setAssociatedObject(self, NNTextFieldInputLimitMaxLength, @(maxLength), OBJC_ASSOCIATION_ASSIGN);
    [self addTarget:self action:@selector(jk_textFieldTextDidChange) forControlEvents:UIControlEventEditingChanged];
}

- (void)jk_textFieldTextDidChange
{
    NSString *toBeString = self.text;
    //获取高亮部分
    UITextRange *selectedRange = [self markedTextRange];
    UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
    
    //没有高亮选择的字，则对已输入的文字进行字数统计和限制
    //在iOS7下,position对象总是不为nil
    if ( (!position ||!selectedRange) && (self.nn_maxLength > 0 && toBeString.length > self.nn_maxLength))
    {
        NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:self.nn_maxLength];
        if (rangeIndex.length == 1){
            self.text = [toBeString substringToIndex:self.nn_maxLength];
        }else{
            NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, self.nn_maxLength)];
            NSInteger tmpLength;
            if (rangeRange.length > self.nn_maxLength) {
                tmpLength = rangeRange.length - rangeIndex.length;
            }else{
                tmpLength = rangeRange.length;
            }
            self.text = [toBeString substringWithRange:NSMakeRange(0, tmpLength)];
        }
    }
}

@end
