//
//  UIButton+NNImagePosition.h
//  DMHCAMU
//
//  Created by 牛牛 on 2017/6/16.
//  Copyright © 2017年 牛牛汇. All rights reserved.
//

typedef NS_ENUM(NSInteger, NNImagePosition) {
    NNImagePositionLeft = 0,              //图片在左，文字在右，默认
    NNImagePositionRight = 1,             //图片在右，文字在左
    NNImagePositionTop = 2,               //图片在上，文字在下
    NNImagePositionBottom = 3,            //图片在下，文字在上
};

#import <UIKit/UIKit.h>

@interface UIButton (NNImagePosition)

/**
 *  利用UIButton的titleEdgeInsets和imageEdgeInsets来实现文字和图片的自由排列
 *  注意：这个方法需要在设置图片和文字之后才可以调用，且button的大小要大于 图片大小+文字大小+spacing
 *
 *  @param spacing 图片和文字的间隔
 */
- (void)nn_setImagePosition:(NNImagePosition)postion spacing:(CGFloat)spacing;

@end
