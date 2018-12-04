//
//  NNTabBarController.m
//  SuperWallet
//
//  Created by 牛牛 on 2018/3/16.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import "NNTabBarController.h"
#import "NNHomeViewController.h"
#import "NNTradingMainViewController.h"
#import "NNWalletViewController.h"
#import "NNMineViewController.h"
#import "NNNavigationController.h"
#import "NNLegalTenderTradeMainViewController.h"

@interface NNTabBarController () <UITabBarControllerDelegate>

@end

@implementation NNTabBarController

+ (void)initialize {
    // 通过appearance统一设置所有UITabBar属性
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    [UITabBar appearance].translucent = NO;
    
    // 去掉横线
    //    [[UITabBar appearance] setBackgroundImage:[UIImage new]];
    //    [[UITabBar appearance] setShadowImage:[UIImage new]];
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIConfigManager fontThemeTextMinTip];

    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = attrs[NSFontAttributeName];
    selectedAttrs[NSForegroundColorAttributeName] = [UIConfigManager colorThemeRed];

    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;

    // 添加子控制器
    [self setupChildVc:[[NNHomeViewController alloc] init] title:@"首页" image:@"ic_tab_home_default" selectedImage:@"ic_tab_home_pressed"];
    [self setupChildVc:[[NNTradingMainViewController alloc] init] title:@"交易" image:@"ic_tab_deal_default" selectedImage:@"ic_tab_deal_pressed"];
    [self setupChildVc:[[NNLegalTenderTradeMainViewController alloc] init] title:@"C2C" image:@"ic_tab_legal_tender_default" selectedImage:@"ic_tab_legal_tender_pressed"];
    [self setupChildVc:[[NNWalletViewController alloc] init] title:@"资产" image:@"ic_tab_wallet_default" selectedImage:@"ic_tab_wallet_pressed"];
    [self setupChildVc:[[NNMineViewController alloc] init] title:@"我的" image:@"ic_tab_mine_default" selectedImage:@"ic_tab_mine_pressed"];
}

/**
 * 初始化子控制器
 */
- (void)setupChildVc:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置文字和图片
    vc.navigationItem.title = title;
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 包装一个导航控制器, 添加导航控制器为tabbarcontroller的子控制器
    NNNavigationController *nav = [[NNNavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    NNNavigationController *nav = (NNNavigationController *)viewController;
    if ([nav.topViewController isKindOfClass:[NNWalletViewController class]] || [nav.topViewController isKindOfClass:[NNLegalTenderTradeMainViewController class]]) {
        NNHWeakSelf(self)
        if ([[NNHProjectControlCenter sharedControlCenter] loginStatus:YES complete:^{
            [weakself setSelectedViewController:viewController];
        }]) { // 登录中
            return YES;
        }else{
            return NO;
        }
    }
    return YES;
}

@end
