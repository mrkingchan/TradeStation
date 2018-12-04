//
//  NNHWebViewController.h
//  ElegantTrade
//
//  Created by 牛牛 on 16/11/3.
//  Copyright © 2016年 Smile intl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NNWebViewController : UIViewController

/** 跳转地址 */
@property (nonatomic, copy) NSString *url;
/** 标题 */
@property (nonatomic, copy) NSString *navTitle;
/** 是否返回首页 */
@property (nonatomic, assign, getter=isBackHome) BOOL backHome;

@end
