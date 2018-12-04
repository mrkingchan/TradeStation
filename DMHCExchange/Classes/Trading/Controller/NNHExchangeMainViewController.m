//
//  NNHExchangeMainViewController.m
//  SuperWallet
//
//  Created by 来旭磊 on 2018/3/20.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import "NNHExchangeMainViewController.h"
#import "NNHCurrentEntrustViewController.h"
#import "NNHHistoryEntrustViewController.h"
#import "NNCoinBuySellViewController.h"
#import "NNPageContentView.h"
#import "NNHPageTitleView.h"
#import "NNExchangeChildViewController.h"
#import "NNKLineViewController.h"

@interface NNHExchangeMainViewController ()<NNHPageTitleViewDelegate, NNHPageContentViewDelegare>

/**  包含控制前视图 */
@property (nonatomic, strong) NNPageContentView *pageContentView;
/** 头部菜单 */
@property (nonatomic, strong) NNHPageTitleView *pageTitleView;
/** 币种模型 */
@property (nonatomic, strong) NNCoinTradingMarketModel *coinTradingMarketModel;
/** 控制器容器 */
@property (nonatomic, strong) NSMutableArray *controllerArray;
/** 导航下面横线 */
@property (nonatomic, weak) UIView *navLineView;

@end

@implementation NNHExchangeMainViewController

#pragma mark - Life Cycle Methods

- (instancetype)initWithCoinTradingMarketModel:(NNCoinTradingMarketModel *)model
{
    if (self = [super init]) {
        _coinTradingMarketModel = model;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIConfigManager colorThemeColorForVCBackground];

    [self setupNav];
    [self setupChildView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

#pragma mark - Initial Methods
- (void)setupNav
{
    self.navigationItem.title = self.coinTradingMarketModel.name;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(pushChartControllerAction) image:@"ic_trade_kline" highImage:@"ic_trade_kline"];
}

- (void)setupChildView
{
    NSArray *titleArray = @[@"买入", @"卖出", @"当前委托", @"历史委托"];
    
    self.pageTitleView = [NNHPageTitleView pageTitleViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NNHNormalViewH) delegate:self titleNames:titleArray];
    self.pageTitleView.backgroundColor = [UIColor whiteColor];
    self.pageTitleView.titleFont = [UIFont boldSystemFontOfSize:15];
    self.pageTitleView.titleColorStateNormal = [UIConfigManager colorThemeDarkGray];
    self.pageTitleView.titleColorStateSelected = [UIConfigManager colorThemeRed];
    self.pageTitleView.indicatorColor = [UIConfigManager colorThemeRed];
    self.pageTitleView.indicatorStyle = NNHIndicatorTypeEqual;

    [self.view addSubview:self.pageTitleView];
    
    // 买入
    NNCoinBuySellViewController *buyVC = [[NNCoinBuySellViewController alloc] initWithCoinTradingType:NNHCoinTradingOrderType_buyIn coinTradingMarketModel:self.coinTradingMarketModel];
    [self.controllerArray addObject:buyVC];
    
    // 卖出
    NNCoinBuySellViewController *sellVC = [[NNCoinBuySellViewController alloc] initWithCoinTradingType:NNHCoinTradingOrderType_soldOut coinTradingMarketModel:self.coinTradingMarketModel];
    [self.controllerArray addObject:sellVC];
    
    // 当前委托
    NNHCurrentEntrustViewController *entrustVC = [[NNHCurrentEntrustViewController alloc] initWithCoinTradingMarketModel:self.coinTradingMarketModel];
    [self.controllerArray addObject:entrustVC];
    
    // 历史委托
    NNHHistoryEntrustViewController *historyVC = [[NNHHistoryEntrustViewController alloc] initWithCoinTradingMarketModel:self.coinTradingMarketModel];
    [self.controllerArray addObject:historyVC];
    
    CGFloat contentViewHeight = self.view.nnh_height - self.pageTitleView.nnh_height - (NNHNavBarViewHeight);
    
    self.pageContentView = [[NNPageContentView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.pageTitleView.frame), self.view.frame.size.width, contentViewHeight) parentVC:self childVCs:self.controllerArray];
    self.pageContentView.pageContentViewDelegate = self;
    self.pageContentView.scrollEnabled = NO;
    [self.view addSubview:self.pageContentView];
    
    //默认选中界面
    self.pageTitleView.selectedIndex = self.index;
    [self.pageContentView setPageCententViewCurrentIndex:self.index];
}

- (void)pushChartControllerAction
{
    NNKLineViewController *klineVC = [NNKLineViewController new];
    klineVC.model = self.coinTradingMarketModel;
    NNHWeakSelf(self)
    klineVC.backSaleTradingBlock = ^{
        weakself.pageTitleView.selectedIndex = 1;
        [weakself.pageContentView setPageCententViewCurrentIndex:1];
    };
    [self.navigationController pushViewController:klineVC animated:YES];
}

#pragma mark - NNHPageTitleViewDelegate
- (void)nnh_pageTitleView:(NNHPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex
{
    [self.pageContentView setPageCententViewCurrentIndex:selectedIndex];
    
    if (self.controllerArray.count == 4) {
        NNExchangeChildViewController *childVC = self.controllerArray[selectedIndex];
        [childVC updateCurrentData];
    }
}

#pragma mark - NNHPageContentViewDelegare
- (void)nnh_pageContentView:(NNPageContentView *)pageContentView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex
{
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}

#pragma mark - Lazy Loads
- (NSMutableArray *)controllerArray
{
    if (_controllerArray == nil) {
        _controllerArray = [NSMutableArray array];
    }
    return _controllerArray;
}

@end
