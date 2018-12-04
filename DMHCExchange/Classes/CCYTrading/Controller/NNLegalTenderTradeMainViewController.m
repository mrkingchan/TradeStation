//
//  NNLegalTenderTradeMainViewController.m
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/25.
//  Copyright © 2018 超级钱包. All rights reserved.
//

#import "NNLegalTenderTradeMainViewController.h"
#import "NNLegalTenderTradeReleaseOrderViewController.h"
#import "NNLegalTenderTradeListViewController.h"
#import "NNLegalTenderReleaseListViewController.h"
#import "NNLegalTenderTradeOrderListViewController.h"

#import "NNLegalTenderTradeSelectMarketView.h"

#import "NNPageContentView.h"
#import "NNHPageTitleView.h"
#import "UIButton+NNImagePosition.h"
#import "NNAPILegalTenderTool.h"
#import "NNLegalTenderTradeCoinModel.h"

@interface NNLegalTenderTradeMainViewController ()<NNHPageTitleViewDelegate, NNHPageContentViewDelegare>

/**  包含控制前视图 */
@property (nonatomic, strong) NNPageContentView *pageContentView;
/** 头部菜单 */
@property (nonatomic, strong) NNHPageTitleView *pageTitleView;
/** 控制器容器 */
@property (nonatomic, strong) NSMutableArray *controllerArray;
/** 当前价 */
@property (nonatomic, strong) UILabel *currentPriceLabel;
/** 交易区标题 */
@property (nonatomic, strong) UIButton *marketButton;
/** 选择交易对 */
@property (nonatomic, strong) NNLegalTenderTradeSelectMarketView *marketView;
/** 当前选中币种 */
@property (nonatomic, strong) NNLegalTenderTradeCoinModel *selectedCoin;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray <NNLegalTenderTradeCoinModel*>*dataSource;
/** 选中下标 */
@property (nonatomic, assign) NSInteger selectedIndex;
/** 数据请求定时器 */
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation NNLegalTenderTradeMainViewController

#pragma mark - Life Cycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIConfigManager colorThemeColorForVCBackground];
    
    self.navigationItem.title = @"USDT/CNY";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(pushOrderAction) title:@"交易记录"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.currentPriceLabel];
    self.navigationItem.titleView = self.marketButton;
    
    // 发布订单成功后通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedReleaseOrderListAction) name:@"selectedReleaseOrderList" object:nil];
    
    [self setupChildView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self requestCoinListData];
//    [self startTimer];
}

//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    [self.timer invalidate];
//    self.timer = nil;
//}

/** 开启定时器 */
- (void)startTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(reloadListData) userInfo:nil repeats:YES];
}

#pragma mark - Initial Methods
- (void)setupChildView
{
    // 获取所有交易对
    NSArray *titleArray = @[@"购买", @"出售",@"交易单"];
    
    // 布局
    self.pageTitleView = [NNHPageTitleView pageTitleViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NNHNormalViewH) delegate:self titleNames:titleArray];
    self.pageTitleView.backgroundColor = [UIConfigManager colorThemeWhite];
    self.pageTitleView.titleColorStateNormal = [UIConfigManager colorThemeBlack];
    self.pageTitleView.titleColorStateSelected = [UIConfigManager colorThemeRed];
    self.pageTitleView.indicatorColor = [UIConfigManager colorThemeRed];
    self.pageTitleView.indicatorStyle = NNHIndicatorTypeEqual;
    [self.view addSubview:self.pageTitleView];
    
    NNLegalTenderTradeListViewController *buyVC = [[NNLegalTenderTradeListViewController alloc] initWithTradeType:NNLegalTenderTradeType_buy];
    [self.controllerArray addObject:buyVC];
    
    NNLegalTenderTradeListViewController *sellVC = [[NNLegalTenderTradeListViewController alloc] initWithTradeType:NNLegalTenderTradeType_sell];
    [self.controllerArray addObject:sellVC];
    
    NNLegalTenderReleaseListViewController *listVC = [[NNLegalTenderReleaseListViewController alloc] init];
    [self.controllerArray addObject:listVC];
    
    CGFloat contentViewHeight = self.view.nnh_height - self.pageTitleView.nnh_height - (NNHNavBarViewHeight) - (NNHTabBarViewHeight);
    self.pageContentView = [[NNPageContentView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.pageTitleView.frame), self.view.frame.size.width, contentViewHeight) parentVC:self childVCs:self.controllerArray];
    self.pageContentView.pageContentViewDelegate = self;
    [self.view addSubview:self.pageContentView];
    
    // 默认选中界面
    self.pageTitleView.selectedIndex = 0;
    [self.pageContentView setPageCententViewCurrentIndex:0];
    
    // 发布按钮
    UIButton *publishButton = [UIButton NNHBtnImage:@"ic_add" target:self action:@selector(publishAction)];
    publishButton.adjustsImageWhenHighlighted = NO;
    [self.view addSubview:publishButton];
    [publishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-15);
        make.bottom.equalTo(self.view).offset(-20 - (NNHBottomSafeHeight));
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
}

/** 请求首页收据 */
- (void)requestCoinListData
{
    NNHWeakSelf(self)
    NNAPILegalTenderTool *tenderTool = [[NNAPILegalTenderTool alloc] initWithHomeCoinListData];
    [tenderTool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
        [weakself handleCoinListData:responseDic];
    } failBlock:^(NNHRequestError *error) {
        
    } isCached:NO];
}

/** 处理首页数据 */
- (void)handleCoinListData:(NSDictionary *)responseDic
{
    self.dataSource = [NNLegalTenderTradeCoinModel mj_objectArrayWithKeyValuesArray:responseDic[@"data"]];
    self.marketView.dataSource = self.dataSource;
    
    if (self.dataSource.count == 0) return;
    
    if (self.selectedCoin) {
        [self.dataSource enumerateObjectsUsingBlock:^(NNLegalTenderTradeCoinModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.coinid isEqualToString:self.selectedCoin.coinid]) {
                self.selectedCoin = obj;
                *stop = YES;
            }
        }];
    }else {
        self.selectedCoin = [self.dataSource firstObject];
    }
    [self configSelectedCoinModel:self.selectedCoin];
}

- (void)configSelectedCoinModel:(NNLegalTenderTradeCoinModel *)coinModel
{
    self.selectedCoin = coinModel;
    self.currentPriceLabel.text = [NSString stringWithFormat:@"￥%@",coinModel.currentPrice];
    [self.marketButton setTitle:[NSString stringWithFormat:@"%@/CNY",coinModel.coinname] forState:UIControlStateNormal];
    [self.marketButton nn_setImagePosition:NNImagePositionRight spacing:NNHMargin_5];
    [self reloadListData];
}

/** 刷新首页列表数据 */
- (void)reloadListData
{
    if (!self.selectedCoin) return;
    
    id<NNLegalTenderTradeReloadDataProtocol> listVC = [self.controllerArray objectAtIndex:self.selectedIndex];
    if (listVC && [listVC conformsToProtocol:@protocol(NNLegalTenderTradeReloadDataProtocol)]) {
        [listVC reloadCoinListDataWithCoinID:self.selectedCoin.coinid coinName:self.selectedCoin.coinname];
    }
}

- (void)changeMaketAction:(UIButton *)button
{
    NNLegalTenderTradeSelectMarketView *selectedView = [[NNLegalTenderTradeSelectMarketView alloc] init];
    selectedView.dataSource = self.dataSource;
    [selectedView show];
    NNHWeakSelf(self);
    selectedView.selectedMarketCompleteBlock = ^(NNLegalTenderTradeCoinModel * _Nonnull coinModel) {
        [weakself configSelectedCoinModel:coinModel];
    };
}

/** 成交订单记录 */
- (void)pushOrderAction
{
    NNLegalTenderTradeOrderListViewController *vc = [[NNLegalTenderTradeOrderListViewController alloc] initWithCoinID:self.selectedCoin.coinid];
    [self.navigationController pushViewController:vc animated:YES];
}

/** 发布订单 */
- (void)publishAction
{
    if (![[NNHApplicationHelper sharedInstance] isRealName]) return;

    if (![[NNHApplicationHelper sharedInstance] isBindMoible]) return;

    if (![[NNHApplicationHelper sharedInstance] isBindBankCard]) return;

    if (![[NNHApplicationHelper sharedInstance] isSetupPayPassword]) return;
    
    NNHWeakSelf(self)
    [SVProgressHUD show];
    NNAPILegalTenderTool *tradeTool = [[NNAPILegalTenderTool alloc] initUserTradeStatusWithType:nil];
    [tradeTool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
        [SVProgressHUD dismiss];
        NSString *key = responseDic[@"data"][@"key"];
        if (key.length) {
            [SVProgressHUD showMessage:key];
        }else {
            NNLegalTenderTradeReleaseOrderViewController *vc = [[NNLegalTenderTradeReleaseOrderViewController alloc] initWithCoinID:self.selectedCoin.coinid coinName:self.selectedCoin.coinname];
            vc.navigationItem.title = [NSString stringWithFormat:@"(%@/CNY)",self.selectedCoin.coinname];
            [weakself.navigationController pushViewController:vc animated:YES];
        }
    } failBlock:^(NNHRequestError *error) {
        
    } isCached:NO];
}

- (void)selectedReleaseOrderListAction
{
    if (self.controllerArray.count == 3) {
        [self.pageTitleView setSelectedIndex:2];
    }
}

#pragma mark - NNHPageTitleViewDelegate
- (void)nnh_pageTitleView:(NNHPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex
{
    [self.pageContentView setPageCententViewCurrentIndex:selectedIndex];
    self.selectedIndex = selectedIndex;
    
    [self reloadListData];
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

- (UILabel *)currentPriceLabel
{
    if (_currentPriceLabel == nil) {
        _currentPriceLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorThemeDarkGray] font:[UIConfigManager fontThemeTextMain]];
        _currentPriceLabel.frame = CGRectMake(0, 0, 100, 30);
    }
    return _currentPriceLabel;
}

- (UIButton *)marketButton
{
    if (_marketButton == nil) {
        _marketButton = [UIButton NNHBtnTitle:@"" titileFont:[UIConfigManager fontNaviTitle] backGround:[UIColor whiteColor] titleColor:[UIConfigManager colorNaviBarTitle]];
        [_marketButton setImage:[UIImage imageNamed:@"nav_tag_corner_mark"] forState:UIControlStateNormal];
        _marketButton.adjustsImageWhenHighlighted = NO;
        [_marketButton nn_setImagePosition:NNImagePositionRight spacing:NNHMargin_5];
        [_marketButton addTarget:self action:@selector(changeMaketAction:) forControlEvents:UIControlEventTouchUpInside];
        _marketButton.frame = CGRectMake(0, 0, 100, NNHNormalViewH);
    }
    return _marketButton;
}

- (NSMutableArray<NNLegalTenderTradeCoinModel *> *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
