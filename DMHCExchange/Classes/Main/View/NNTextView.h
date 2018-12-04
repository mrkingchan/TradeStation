//
//  NNHTextView.h
//  NNHPlatform
//
//  Created by leiliao lai on 17/3/1.
//  Copyright © 2017年 Smile intl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NNTextView : UITextView

/** 占位文字 */
@property (nonatomic, copy) NSString *placeholder;
/** 占位文字的颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;

@end
