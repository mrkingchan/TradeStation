//
//  UITextView+NNHExtension.m
//  DMHCAMU
//
//  Created by 牛牛 on 2017/7/15.
//  Copyright © 2017年 牛牛汇. All rights reserved.
//

#import "UITextView+NNHExtension.h"
#import <objc/runtime.h>

static const void *NNTextViewInputLimitMaxLength = &NNTextViewInputLimitMaxLength;
@implementation UITextView (NNHExtension)

- (NSInteger)nn_maxLength
{
    return [objc_getAssociatedObject(self, NNTextViewInputLimitMaxLength) integerValue];
}
- (void)setNn_maxLength:(NSInteger)maxLength
{
    objc_setAssociatedObject(self, NNTextViewInputLimitMaxLength, @(maxLength), OBJC_ASSOCIATION_ASSIGN);
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(nn_textViewTextDidChange:)
                                                name:@"UITextViewTextDidChangeNotification" object:self];
    
}
- (void)nn_textViewTextDidChange:(NSNotification *)notification
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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
