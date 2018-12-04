//
//  NNTradingMainViewController.m
//  SuperWallet
//
//  Created by 牛牛 on 2018/9/7.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import "NNTradingMainViewController.h"
#import "NNNavigationController.h"
#import "NNCoinSearchViewController.h"
#import "NNTradingChildViewController.h"
#import "NNPageContentView.h"
#import "NNHPageTitleView.h"
#import "NNHAPITradingTool.h"

@interface NNTradingMainViewController ()<NNHPageTitleViewDelegate, NNHPageContentViewDelegare>

/**  包含控制前视图 */
@property (nonatomic, strong) NNPageContentView *pageContentView;
/** 头部菜单 */
@property (nonatomic, strong) NNHPageTitleView *pageTitleView;
/** 控制器容器 */
@property (nonatomic, strong) NSMutableArray <NNTradingChildViewController *> *controllerArray;
/** 头部view */
@property (nonatomic, strong) UIView *headerView;
/** 当前交易对ID */
@property (nonatomic, copy) NSString *currentCCYID;

@end

@implementation NNTradingMainViewController

#pragma mark - Life Cycle Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIConfigManager colorThemeColorForVCBackground];
    
    [self setupNav];
    [self requestDataSource];
}

- (void)setupNav
{
    self.navigationItem.title = @"行情交易";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(coinSearchAction) image:@"ic_nav_search" highImage:@"ic_nav_search"];
    
    // 找出导航下划线
    UIView *backgroundView = [self.navigationController.navigationBar subviews].firstObject;
    for (UIView *lineView in backgroundView.subviews) {
        if (CGRectGetHeight(lineView.frame) <= 1) {
            lineView.hidden = YES;
        }
    }
}

#pragma mark - Initial Methods
- (void)requestDataSource
{
    NNHWeakSelf(self)
    NNHAPITradingTool *tradeTool = [[NNHAPITradingTool alloc] initMarketSymbol];
    [tradeTool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {

        [weakself setupChildViewWithDataSource:responseDic[@"data"]];

    } failBlock:^(NNHRequestError *error) {

    } isCached:NO];
}

- (void)setupChildViewWithDataSource:(NSArray *)ccyArray
{
    // 获取所有交易对标题
    NSMutableArray *ccyTitleArray = [NSMutableArray array];
    for (NSDictionary *obj in ccyArray) {
        [ccyTitleArray addObject:obj[@"coinname"]];
    }

    // 布局
    self.pageTitleView = [NNHPageTitleView pageTitleViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NNHNormalViewH) delegate:self titleNames:ccyTitleArray];
    self.pageTitleView.backgroundColor = [UIColor whiteColor];
    self.pageTitleView.titleFont = [UIFont boldSystemFontOfSize:15];
    self.pageTitleView.titleColorStateNormal = [UIConfigManager colorThemeDarkGray];
    self.pageTitleView.titleColorStateSelected = [UIConfigManager colorThemeRed];
    self.pageTitleView.indicatorColor = [UIConfigManager colorThemeRed];
    self.pageTitleView.indicatorStyle = NNHIndicatorTypeEqual;
    [self.view addSubview:self.pageTitleView];
    
    for (NSInteger i = 0; i < ccyTitleArray.count; i++) {
        NNTradingChildViewController *vc = [[NNTradingChildViewController alloc] init];
        vc.ccy = ccyArray[i][@"id"];
        [self.controllerArray addObject:vc];
    }

    CGFloat contentViewHeight = self.view.nnh_height - self.pageTitleView.nnh_height;
    self.pageContentView = [[NNPageContentView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.pageTitleView.frame), self.view.frame.size.width, contentViewHeight) parentVC:self childVCs:self.controllerArray];
    self.pageContentView.pageContentViewDelegate = self;
    [self.view addSubview:self.pageContentView];
    
    // 默认选中界面
    self.pageTitleView.selectedIndex = 0;
    [self.pageContentView setPageCententViewCurrentIndex:0];
}

- (void)coinSearchAction
{
    NNCoinSearchViewController *vc = [[NNCoinSearchViewController alloc] initWithCCYID:self.currentCCYID];
    NNNavigationController *nav = [[NNNavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

#pragma mark - NNHPageTitleViewDelegate
- (void)nnh_pageTitleView:(NNHPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex
{
    [self.pageContentView setPageCententViewCurrentIndex:selectedIndex];
    
    // 取出当前交易对
    NNTradingChildViewController *currentVC = self.controllerArray[selectedIndex];
    self.currentCCYID = currentVC.ccy;
}

#pragma mark - NNHPageContentViewDelegare
- (void)nnh_pageContentView:(NNPageContentView *)pageContentView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex
{
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}

#pragma mark - Lazy Loads
- (NSMutableArray<NNTradingChildViewController *> *)controllerArray
{
    if (_controllerArray == nil) {
        _controllerArray = [NSMutableArray array];
    }
    return _controllerArray;
}

@end
