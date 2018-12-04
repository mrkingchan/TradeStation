//
//  NNFlowLabel.m
//  SuperWallet
//
//  Created by 来旭磊 on 2018/4/9.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import "NNFlowLabel.h"

@implementation NNFlowLabel
{
    
    CGRect rectMark1;// 标记第一个位置
    CGRect rectMark2;// 标记第二个位置
    
    NSMutableArray* labelArr;
    
    NSTimeInterval timeInterval;//时间
    
    BOOL isStop; //停止
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString*)title font:(UIFont *)font
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 计算间隔
        title = [NSString stringWithFormat:@"  %@  ",title];
        timeInterval = [self displayDurationForString:title];
        
        self.clipsToBounds = YES;
        
        //
        UILabel* textLb = [[UILabel alloc] initWithFrame:CGRectZero];
        textLb.textColor = TEXTCOLOR;
        textLb.font = font;
        textLb.text = title;
        
        //计算textLb大小
        CGSize sizeOfText = [textLb sizeThatFits:CGSizeZero];
        
        rectMark1 = CGRectMake(0, 0, sizeOfText.width, self.bounds.size.height);
        rectMark2 = CGRectMake(rectMark1.origin.x+rectMark1.size.width, 0, sizeOfText.width, self.bounds.size.height);
        
        textLb.frame = rectMark1;
        [self addSubview:textLb];
        
        labelArr = [NSMutableArray arrayWithObject:textLb];
        
        
        //判断是否需要reserveTextLb
        BOOL useReserve = sizeOfText.width > frame.size.width ? YES : NO;
        
        if (useReserve) {
            //alloc reserveTextLb ...
            
            UILabel* reserveTextLb = [[UILabel alloc] initWithFrame:rectMark2];
            reserveTextLb.textColor = TEXTCOLOR;
            reserveTextLb.font = font;
            reserveTextLb.text = title;
            [self addSubview:reserveTextLb];
            
            [labelArr addObject:reserveTextLb];
        }
        
    }
    return self;
}

- (void)setCustomerBackgroudColor:(UIColor *)customerBackgroudColor
{
    _customerBackgroudColor = customerBackgroudColor;
    self.backgroundColor = customerBackgroudColor;
}

- (void)paomaAnimate{
    
    if (!isStop) {
        UILabel* lbindex0 = labelArr[0];
        UILabel* lbindex1 = labelArr[1];
        
        [UIView transitionWithView:self duration:timeInterval options:UIViewAnimationOptionCurveLinear animations:^{
            lbindex0.frame = CGRectMake(-rectMark1.size.width, 0, rectMark1.size.width, rectMark1.size.height);
            lbindex1.frame = CGRectMake(lbindex0.frame.origin.x+lbindex0.frame.size.width, 0, lbindex1.frame.size.width, lbindex1.frame.size.height);
            
        } completion:^(BOOL finished) {

            lbindex0.frame = rectMark2;
            lbindex1.frame = rectMark1;
            
            [labelArr replaceObjectAtIndex:0 withObject:lbindex1];
            [labelArr replaceObjectAtIndex:1 withObject:lbindex0];
            
            [self paomaAnimate];
        }];
    }
}


- (void)start{
    isStop = NO;
    UILabel* lbindex0 = labelArr[0];
    UILabel* lbindex1 = labelArr[1];
    lbindex0.frame = rectMark2;
    lbindex1.frame = rectMark1;
    
    [labelArr replaceObjectAtIndex:0 withObject:lbindex1];
    [labelArr replaceObjectAtIndex:1 withObject:lbindex0];
    
    [self paomaAnimate];
    
}
- (void)stop{
    isStop = YES;
}

- (NSTimeInterval)displayDurationForString:(NSString*)string {
    
    return string.length / 5;
}


@end
