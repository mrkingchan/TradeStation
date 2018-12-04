//
//  NNCoinChartViewController.m
//  SuperWallet
//
//  Created by 牛牛 on 2018/3/28.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import "NNCoinChartViewController.h"
#import "NNCoinIntroduceViewController.h"
#import "NNHExchangeMainViewController.h"
#import "NNCoinChartView.h"
#import "NNCoinChartTopView.h"
#import "NNKLineGroupModel.h"
#import "NNHAPITradingTool.h"
#import "NNHCoinPriceModel.h"
#import "NNHApplicationHelper.h"

@interface NNCoinChartViewController () <Y_StockChartViewDataSource>

/** 行情 */
@property (nonatomic, strong) NNCoinChartTopView *topView;
/** 折线图 */
@property (nonatomic, strong) NNCoinChartView *stockChartView;
/** 行情模型 */
@property (nonatomic, strong) NNHCoinPriceModel *coinPriceModel;
/** 折线模型 */
@property (nonatomic, strong) NNKLineGroupModel *groupModel;
/** 折线数据 */
@property (nonatomic, strong) NSMutableDictionary <NSString*, NNKLineGroupModel*> *modelsDict;
/** 买 */
@property (nonatomic, weak) UIButton *buyButton;
/** 卖 */
@property (nonatomic, weak) UIButton *sellButton;
/** 当前默认选中 */
@property (nonatomic, assign) NSInteger currentIndex;
/** 当前默认类型 */
@property (nonatomic, copy) NSString *type;
/** 交易对 */
@property (nonatomic, copy) NSString *coinID;
/** 定时器 */
@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation NNCoinChartViewController

#pragma mark -
#pragma mark ---------Life Cycle
- (void)dealloc
{
    NNHLog(@"------%s-----",__func__);
}

- (instancetype)initWithCoinID:(NSString *)coinID
{
    if (self = [super init]) {
        _coinID = coinID;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage nnh_imageWithColor:NNHRGBColor(33, 33, 45)] forBarMetrics:UIBarMetricsDefault];
    
    // 获取头部数据
    [self requestCoinDataSource];
    
    // 开启定时器
    dispatch_resume(self.timer);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage nnh_imageWithColor:[UIColor akext_colorWithHex:@"#1963CB"]] forBarMetrics:UIBarMetricsDefault];
    
    // 关闭定时器
    dispatch_source_cancel(self.timer);
    self.timer = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIConfigManager colorThemeColorForVCBackground];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(coinIntroduceAction) title:@"简介"];
    
    [self setupChildView];

}

- (void)setupChildView
{
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@120);
    }];
    
    UIButton *buyButton = [UIButton NNHBtnTitle:@"买入" titileFont:[UIConfigManager fontThemeTextDefault] backGround:[UIColor akext_colorWithHex:@"#19ad52"] titleColor:[UIColor whiteColor]];
    buyButton.tag = NNHCoinTradingOrderType_buyIn;
    buyButton.hidden = YES;
    [buyButton addTarget:self action:@selector(tradingAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buyButton];
    _buyButton = buyButton;
    [buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-(NNHBottomSafeHeight));
        make.height.equalTo(@44);
        make.width.equalTo(self.view).multipliedBy(0.5);
    }];
    
    UIButton *sellButton = [UIButton NNHBtnTitle:@"卖出" titileFont:[UIConfigManager fontThemeTextDefault] backGround:[UIColor akext_colorWithHex:@"#eb3736"] titleColor:[UIColor whiteColor]];
    sellButton.tag = NNHCoinTradingOrderType_soldOut;
    sellButton.hidden = YES;
    [sellButton addTarget:self action:@selector(tradingAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sellButton];
    _sellButton = sellButton;
    [sellButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view);
        make.bottom.equalTo(buyButton);
        make.height.equalTo(buyButton);
        make.width.equalTo(buyButton);
    }];
    
    [self.view addSubview:self.stockChartView];
    [self.stockChartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-(NNHBottomSafeHeight));
    }];
}

- (void)requestCoinDataSource
{
    NNHAPITradingTool *tool = [[NNHAPITradingTool alloc] initSingleCoinTradingDataSourceWithCoinID:self.coinID];
    NNHWeakSelf(self)
    [tool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
        weakself.coinPriceModel = [NNHCoinPriceModel mj_objectWithKeyValues:responseDic[@"data"][@"price"]];
        weakself.topView.coinPriceModel = weakself.coinPriceModel;
        
        // 更新ui
        if ([weakself.coinPriceModel.support_trade boolValue]) {
            weakself.buyButton.hidden = weakself.sellButton.hidden = NO;
            [weakself.stockChartView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakself.topView.mas_bottom);
                make.left.right.equalTo(weakself.view);
                make.bottom.equalTo(weakself.buyButton.mas_top);
            }];
        }else{
            weakself.buyButton.hidden = weakself.sellButton.hidden = YES;
            [weakself.stockChartView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakself.topView.mas_bottom);
                make.left.right.equalTo(weakself.view);
                make.bottom.equalTo(weakself.view).offset(-(NNHBottomSafeHeight));
            }];
        }
        
    } failBlock:^(NNHRequestError *error) {
        
    } isCached:NO];
}

#pragma mark -
#pragma mark ---------UserAction
- (void)tradingAction:(UIButton *)button
{
    if (self.getExchangeIndexBlock) {
        self.getExchangeIndexBlock(button.tag);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)coinIntroduceAction
{
    NNCoinIntroduceViewController *vc = [[NNCoinIntroduceViewController alloc] initWithCoinID:self.coinID];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
#pragma mark ---------Y_StockChartViewDataSource
- (id)stockDatasWithIndex:(NSInteger)index
{
    NSString *type;
    switch (index) {
        case 0:{
            type = @"1min";
        }
            break;
        case 1:{
            type = @"1min";
        }
            break;
        case 2:{
            type = @"1min";
        }
            break;
        case 3:{
            type = @"30min";
        }
            break;
        case 4:{
            type = @"1day";
        }
            break;
        case 5:{
            type = @"1week";
        }
            break;
            
        default:
            break;
    }
    
    self.currentIndex = index;
    self.type = type;
    if(![self.modelsDict objectForKey:type]){
        [self reloadData];
    } else {
        return [self.modelsDict objectForKey:type].models;
    }
    return nil;
}

- (void)reloadData
{
//    NNHAPITradingTool *tool = [[NNHAPITradingTool alloc] initCoinChartWithCoin:self.coinID period:self.type];
//    NNHWeakSelf(self)
//    [tool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
//        NSArray *arr = responseDic[@"data"][@"list"];
//        if (arr.count < 7) return;
//        weakself.groupModel = [NNKLineGroupModel objectWithArray:arr];
//        [weakself.modelsDict setObject:weakself.groupModel forKey:weakself.type];
//        [weakself.stockChartView reloadData];
//    } failBlock:^(NNHRequestError *error) {
//        
//    } isCached:NO];
}

#pragma mark -
#pragma mark ---------Getters & Setters
- (NSMutableDictionary<NSString *,NNKLineGroupModel *> *)modelsDict
{
    if (_modelsDict == nil) {
        _modelsDict = [NSMutableDictionary dictionary];
    }
    return _modelsDict;
}

- (NNCoinChartTopView *)topView
{
    if (_topView == nil) {
        _topView = [[NNCoinChartTopView alloc] init];
    }
    return _topView;
}

- (NNCoinChartView *)stockChartView
{
    if(!_stockChartView) {
        _stockChartView = [[NNCoinChartView alloc] init];
        _stockChartView.itemModels = @[
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"指标" type:Y_StockChartcenterViewTypeOther],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"分时" type:Y_StockChartcenterViewTypeTimeLine],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"1分" type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"30分" type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"日线" type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"周线" type:Y_StockChartcenterViewTypeKline]
                                       ];
        _stockChartView.dataSource = self;
    }
    return _stockChartView;
}

- (dispatch_source_t)timer
{
    if (_timer == nil) { // 定时刷新
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 10.0 * NSEC_PER_SEC, 0);
        NNHWeakSelf(self)
        dispatch_source_set_event_handler(_timer, ^{
            [weakself requestCoinDataSource];
            [weakself reloadData];
        });
    }
    return _timer;
}

@end
