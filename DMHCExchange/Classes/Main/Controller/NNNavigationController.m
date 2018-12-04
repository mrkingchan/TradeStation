//
//  NNHNavigationController.m
//  ElegantTrade
//
//  Created by 牛牛 on 16/10/18.
//  Copyright © 2016年 Smile intl. All rights reserved.
//

#import "NNNavigationController.h"
#import "YTKNetworkAgent.h"
#import "NNKLineViewController.h"

@interface NNNavigationController () <UINavigationControllerDelegate>

/** 记录当前的interactivePopGestureRecognizer.delegate */
@property (nonatomic, strong) id popDelegate;

@end

@implementation NNNavigationController

/**
 * 当第一次使用这个类的时候会调用一次
 */
+ (void)initialize {
    UINavigationBar *bar = [UINavigationBar appearance];
    bar.translucent = NO;
    [bar setBackgroundImage:[UIImage nnh_imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    [bar setTitleTextAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:18],
                       NSForegroundColorAttributeName : [UIConfigManager colorNaviBarTitle]}];
    
    // 设置item
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    
    // UIControlStateNormal
    NSMutableDictionary *itemAttrs = [NSMutableDictionary dictionary];
    itemAttrs[NSForegroundColorAttributeName] = [UIConfigManager colorNaviBarTitle];
    itemAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:18];
    [item setTitleTextAttributes:itemAttrs forState:UIControlStateNormal];
    
    // UIControlStateDisabled
    NSMutableDictionary *itemDisabledAttrs = [NSMutableDictionary dictionary];
    itemDisabledAttrs[NSForegroundColorAttributeName] = [UIConfigManager colorNaviBarTitle];
    [item setTitleTextAttributes:itemDisabledAttrs forState:UIControlStateDisabled];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NNHWeakSelf(self)
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.delegate =  weakself;
    }
    
    self.popDelegate = self.interactivePopGestureRecognizer.delegate;
}

/**
 * 可以在这个方法中拦截所有push进来的控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.childViewControllers.count > 0) { // 如果push进来的不是第一个控制器
        UIImage *backImage = [[UIImage imageNamed:[viewController isKindOfClass:[NNKLineViewController class]]?@"ic_nav_back_light": @"ic_nav_back"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backImage style:UIBarButtonItemStyleDone target:self action:@selector(back)];
        // 隐藏tabbar
        viewController.hidesBottomBarWhenPushed = YES;
        
        self.interactivePopGestureRecognizer.delegate = nil;
    }
    // 这句super的push要放在后面, 让viewController可以覆盖上面设置的leftBarButtonItem
    [super pushViewController:viewController animated:animated];
    // iphonex push tabbar上移问题
    if (self.tabBarController && isiPhoneX) {
        CGRect frame = self.tabBarController.tabBar.frame;
        frame.origin.y = SCREEN_HEIGHT - frame.size.height;
        self.tabBarController.tabBar.frame = frame;
    }
}

- (void)back
{
    // 取消所有未完成的请求
    [[YTKNetworkAgent sharedAgent] cancelAllRequests];
    [SVProgressHUD dismiss];
    [self popViewControllerAnimated:YES];
}

- (UIViewController *)childViewControllerForStatusBarStyle
{
    return self.visibleViewController;
}


@end
