//
//  NNFlowLabel.h
//  SuperWallet
//
//  Created by 来旭磊 on 2018/4/9.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

/*****************************************************
 
 @Author             来旭磊
 
 @CreateTime      TimeForever
 
 @ function           简单跑马灯view
 
 @Remarks          <#注释#>
 
 *****************************************************/

#import <UIKit/UIKit.h>

#define TEXTCOLOR [UIColor whiteColor]
#define TEXTFONTSIZE 9

@interface NNFlowLabel : UIView

/** 背景颜色 */
@property (nonatomic, strong) UIColor *customerBackgroudColor;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString*)title font:(UIFont *)font;

// 开始跑马
- (void)start;
//停止跑马
- (void)stop;

@end
