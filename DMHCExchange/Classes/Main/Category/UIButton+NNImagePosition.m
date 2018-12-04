//
//  UIButton+NNImagePosition.m
//  DMHCAMU
//
//  Created by 牛牛 on 2017/6/16.
//  Copyright © 2017年 牛牛汇. All rights reserved.
//

#import "UIButton+NNImagePosition.h"

@implementation UIButton (NNImagePosition)

- (void)nn_setImagePosition:(NNImagePosition)postion spacing:(CGFloat)spacing
{
    CGFloat imageWith = self.imageView.image.size.width;
    CGFloat imageHeight = self.imageView.image.size.height;
    CGFloat labelWidth = [self.titleLabel.text sizeWithFont:self.titleLabel.font].width;
//    CGFloat labelHeight = [self.titleLabel.text sizeWithFont:self.titleLabel.font].height;
    
    // image中心移动的x距离
    CGFloat imageOffsetX = (imageWith + labelWidth) / 2 - imageWith / 2;
    
    // image中心移动的y距离
    CGFloat imageOffsetY = spacing;
    
    // label中心移动的x距离
    CGFloat labelOffsetX = (imageWith + labelWidth / 2) - (imageWith + labelWidth) / 2;
    
    // label中心移动的y距离
    CGFloat labelOffsetY = imageHeight / 2 + spacing;
    
    switch (postion) {
        case NNImagePositionLeft:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, -spacing/2, 0, spacing/2);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, spacing/2, 0, -spacing/2);
            break;
            
        case NNImagePositionRight:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + spacing/2, 0, -(labelWidth + spacing/2));
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageHeight + spacing/2), 0, imageHeight + spacing/2);
            break;
            
        case NNImagePositionTop:
            self.imageEdgeInsets = UIEdgeInsetsMake(-imageOffsetY, imageOffsetX, imageOffsetY, -imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(labelOffsetY, -labelOffsetX, -labelOffsetY, labelOffsetX);
            break;
            
        case NNImagePositionBottom:
            self.imageEdgeInsets = UIEdgeInsetsMake(imageOffsetY, imageOffsetX, -imageOffsetY, -imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(-labelOffsetY, -labelOffsetX, labelOffsetY, labelOffsetX);
            break;
            
        default:
            break;
    }
}

@end
