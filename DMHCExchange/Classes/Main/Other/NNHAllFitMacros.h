//
//  NNHAllFitMacros.h
//  ElegantTrade
//
//  Created by 牛牛 on 16/10/19.
//  Copyright © 2016年 Smile intl. All rights reserved.
//

#ifndef NNHAllFitMacros_h
#define NNHAllFitMacros_h

# pragma mark ---- 系统版本、设备型号、屏幕尺寸
#define SCREEN_BOUNDS ([[UIScreen mainScreen] bounds])
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
#define STATUSBAR_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height

#define NNHAdeptWidth(value) ((value) * [UIScreen mainScreen].bounds.size.width / 375.f)
#define NNHAdeptHeight(value) ((value) * [UIScreen mainScreen].bounds.size.height / 667.f)

# pragma mark ---- 适配ios11
// NSOrderedAscending的意思是：左边的操作对象小于右边的对象。
// NSOrderedDescending的意思是：左边的操作对象大于右边的对象。
#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

// 导航栏高度
#define NNHNavBarViewHeight isiPhoneX ? 88 : 64
// 底部栏高度
#define NNHTabBarViewHeight isiPhoneX ? 83 : 49
// 底部安全高度
#define NNHBottomSafeHeight isiPhoneX ? 34 : 0

#define isiPhoneX  (([[UIScreen mainScreen] bounds].size.height) >= 812.f ? 1 : 0 )

#define  nn_adjustsScrollViewInsets_NO(scrollView,vc)\
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
if ([UIScrollView instancesRespondToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
NSMethodSignature *signature = [UIScrollView instanceMethodSignatureForSelector:@selector(setContentInsetAdjustmentBehavior:)];\
NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];\
NSInteger argument = 2;\
invocation.target = scrollView;\
invocation.selector = @selector(setContentInsetAdjustmentBehavior:);\
[invocation setArgument:&argument atIndex:2];\
[invocation invoke];\
} else {\
vc.automaticallyAdjustsScrollViewInsets = NO;\
}\
_Pragma("clang diagnostic pop") \
} while (0)



# pragma mark ---- 设置RGB颜色/设置RGBA颜色

#define NNHRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define NNHRGBAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(r)/255.0 blue:(r)/255.0 alpha:a]


# pragma mark ---- 自定义高效率的 NSLog

#ifdef DEBUG
#define NNHLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define NNHLog(...)

#endif

// 防止xcode打印不全
#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);


# pragma mark ----  弱引用/强引用

#define NNHWeakSelf(type)  __weak typeof(type) weak##type = type;
#define NNHStrongSelf(type)  __strong typeof(type) strong##type = weak##type;


# pragma mark ---- view相关
// 图片
#define ImageName(X)    (UIImage*)([UIImage imageNamed:X])

// 设置 view 圆角和边框
#define NNHViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]];\
[View setClipsToBounds:YES];

// 设置 view 圆角
#define NNHViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View setClipsToBounds:YES];


# pragma mark ---- 设置通知
#define POST_NOTIFICATION(X)  [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:X object:nil]];
#define POST_NOTIFICATIONWithObject(notice,obj)  [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:notice object:obj]];

#endif /* NNHAllFitMacros_h */
