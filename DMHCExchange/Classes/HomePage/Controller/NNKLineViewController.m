//
//  NNKLineViewController.m
//  DMHCExchange
//
//  Created by 云笈 on 2018/10/26.
//  Copyright © 2018年 超级钱包. All rights reserved.
//

#import "NNKLineViewController.h"
#import "Y_StockChartView.h"
#import "Y_KLineGroupModel.h"
#import "UIColor+Y_StockChart.h"
#import "NNTradeDetailView.h"
#import "NNDropListView.h"
#import "AFNetworking.h"
#import "NNHAPIHomeTool.h"
#import "NNCoinBuySellViewController.h"
#import "NNCoinTradingMarketModel.h"

#define kKlineBackColor [UIColor colorWithRed:21/255.0 green:31/255.0 blue:47/255.0 alpha:1.0]

@interface NNKLineViewController () <Y_StockChartViewDataSource>

@property (nonatomic, strong) Y_StockChartView *chartView;  // K线图

@property (nonatomic, strong) NNTradeDetailView *tradeDetailView;  //顶部数据详情图

@property (nonatomic, strong) NSMutableDictionary<NSString *,Y_KLineGroupModel *> *modelsDic;  //k线图数据源

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, strong) NSTimer *timer;  //定时器 刷新k线图数据

@property (nonatomic, strong) NSDictionary *responseDic; //拉下来的json 用于更新价格

@property (nonatomic, strong) UIView *navigationTopView;  //导航栏上的view

@end

@implementation NNKLineViewController

#pragma mark - viewController's view's lifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor backgroundColor];
    [self setUpChildViews];
    self.navigationItem.title = _model.name;
    self.type = @"1day";
    _timer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                              target:self
                                            selector:@selector(reloadData)
                                            userInfo:nil
                                             repeats:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    /*[self.navigationController.navigationBar setBackgroundImage:[UIImage nnh_imageWithColor:kKlineBackColor] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar  setTitleTextAttributes:@{NSFontAttributeName : [UIConfigManager fontNaviTitle],
                                                                          NSForegroundColorAttributeName : [UIColor whiteColor]}];
     */
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    /*[self.navigationController.navigationBar setBackgroundImage:[UIImage nnh_imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar  setTitleTextAttributes:@{NSFontAttributeName : [UIConfigManager fontNaviTitle],
                                                                       NSForegroundColorAttributeName : [UIConfigManager colorNaviBarTitle]}];
     */
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self removeCurrentDropView];
    //销毁定时器
    if (_timer) {
        [_timer  invalidate];
        _timer = nil;
    }
}

- (void)setUpChildViews {
    [self.view addSubview:self.navigationTopView];
    [_navigationTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@(NNHNavBarViewHeight));
    }];
    
    [self.view addSubview:self.tradeDetailView];
    [_tradeDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(_navigationTopView.mas_bottom);
        make.height.equalTo(@90);
    }];
    [self.view addSubview:self.chartView];
    //买入卖出
    for (int i = 0 ; i < 2; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont  systemFontOfSize:14];
        [button setTitleColor: [UIColor akext_colorWithHex:@"#ffffff"] forState:UIControlStateNormal];
        [button setBackgroundColor:i == 0 ?[UIColor akext_colorWithHex:@"#3fbe72"]:[UIColor akext_colorWithHex:@"#f0252a"] forState:UIControlStateNormal];
        [button setTitle:[NSString stringWithFormat:@"%@%@",i == 0 ? @"买入":@"卖出",_model.name] forState:UIControlStateNormal];
        [button  addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.textAlignment = 1;
        button.tag = 201810 + i;
        [self.view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).offset(i == 0 ? 0:SCREEN_WIDTH /2);
            make.width.equalTo(@(SCREEN_WIDTH/2.0));
            make.bottom.equalTo(self.view.mas_bottom).offset(isiPhoneX? -34:0);
            make.height.equalTo(@40);
        }];
    }
}

#pragma mark - private Method
- (void)buttonAction:(UIButton *)button {
    
    // 返回交易区域
    if (button.tag == 201811) {
        if (self.backSaleTradingBlock) {
            self.backSaleTradingBlock();
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - lazy Load

- (UIView *)navigationTopView{
    if (!_navigationTopView) {
        _navigationTopView = [UIView new];
        _navigationTopView.backgroundColor = kKlineBackColor;
        //返回按钮
        UIButton *back = [UIButton NNHBtnImage:@"ic_nav_back_light" target:self action:@selector(buttonAction:)];
        [_navigationTopView addSubview:back];
        [back mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_navigationTopView.mas_left).offset(5);
            make.top.equalTo(_navigationTopView).offset(STATUSBAR_HEIGHT);
            make.width.height.equalTo(@44);
        }];
        
        //标题
        UILabel *title = [UILabel NNHWithTitle:_model.name titleColor:[UIColor whiteColor] font:[UIConfigManager fontNaviTitle]];
        title.textAlignment = 1;
        [_navigationTopView addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_navigationTopView);
            make.centerY.equalTo(back);
        }];
    }
    return _navigationTopView;
}
- (NSMutableDictionary <NSString *,Y_KLineGroupModel *> *)modelsDic{
    if (!_modelsDic) {
        _modelsDic = @{}.mutableCopy;
    }
    return _modelsDic;
}

- (Y_StockChartView *)chartView{
    if (!_chartView) {
        _chartView = [Y_StockChartView new];
        [self.view addSubview:_chartView];
        _chartView.dataSource = self;
        _chartView.itemModels = @[
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"指标" type:Y_StockChartcenterViewTypeOther],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"分时" type:Y_StockChartcenterViewTypeTimeLine],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"1分" type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"5分" type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"15分" type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"30分" type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"60分" type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"4小时" type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"日线" type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"周线" type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"月线" type:Y_StockChartcenterViewTypeKline],
                                       ];
        [_chartView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.tradeDetailView.mas_bottom);
            if (isiPhoneX) {
                make.bottom.equalTo(self.view.mas_bottom).offset(-64);
            } else {
                make.bottom.equalTo(self.view.mas_bottom).offset(-40);
            }
        }];
    }
    return _chartView;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self removeCurrentDropView];
}

- (void)removeCurrentDropView {
    [[UIApplication sharedApplication].keyWindow.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NNDropListView class]]) {
            [obj removeFromSuperview];
        }
    }];
}

- (NNTradeDetailView *)tradeDetailView{
    if (!_tradeDetailView) {
        _tradeDetailView = [NNTradeDetailView new];
    }
    return _tradeDetailView;
}

#pragma mark - Y_StockChartViewDataSource
- (id)stockDatasWithIndex:(NSInteger)index {
    NSString *type;
    switch (index) {
        case 0:
            type = @"1min";
            break;
        case 1:
            type = @"1min";
            break;
        case 2:
            type = @"1min";
            break;
        case 3:
            type = @"5min";
            break;
        case 4:
            type = @"15min";
            break;
        case 5:
            type = @"30min";
            break;
        case 6:
            type = @"1hour";
            break;
        case 7:
            type = @"4hour";
            break;
        case 8:
            type = @"1day";
            break;
        case 9:
            type = @"1week";
            break;
        default:
            type = @"1day";
            break;
    }
    self.currentIndex = index;
    self.type = type;
    if(![self.modelsDic objectForKey:type]) {
        [self reloadData];
    } else {
        return [self.modelsDic objectForKey:type].models;
    }
    return nil;
}

#pragma mark - load k_Line data
- (void)reloadData {
   /*NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"type"] = self.type;
    param[@"market"] = @"btc_usdt";
    param[@"size"] = @"10000";
    [[AFHTTPSessionManager manager] GET:@"http://api.bitkk.com/data/v1/kline" parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        Y_KLineGroupModel *groupModel = [Y_KLineGroupModel objectWithArray:responseObject[@"data"]];
        [self.modelsDic setObject:groupModel forKey:self.type];
        NSLog(@"%@",groupModel);
        [self.chartView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    
    }];
    */
    
    NSString *period = @"";
    switch (self.currentIndex) {
        case 0:
            period = @"1";
            break;
        case 1:
            period = @"1";
            break;
        case 2:
            period = @"1";
            break;
        case 3:
            period = @"5";
            break;
        case 4:
            period = @"15";
            break;
        case 5:
            period = @"30";
            break;
        case 6:
            period = @"60";
            break;
        case 7:
            period = @"240";
            break;
        case 8:
            period = @"1440";
            break;
        case 9:
            period = @"10080";
            break;
        default:
            break;
    }
    NNHWeakSelf(self);
    [[[NNHAPIHomeTool alloc] initWithMarketCoinID:_model.marketcoinid period:period] nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
        [weakself.tradeDetailView refreshWithData:responseDic[@"data"][@"coin_price"]];
        if ([responseDic[@"data"][@"list"] count] > 1) {
            weakself.responseDic = responseDic;
            Y_KLineGroupModel *groupModel = [Y_KLineGroupModel objectWithArray:responseDic[@"data"][@"list"]];
            [weakself.modelsDic setObject:groupModel forKey:self.type];
            [weakself.chartView reloadData];
        }
    } failBlock:^(NNHRequestError *error) {
        
    } isCached:NO];
}

#pragma mark - memory management
-(void)dealloc {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    if (_chartView) {
        _chartView.dataSource = nil;
        _chartView = nil;
    }
    if (_tradeDetailView) {
        _tradeDetailView = nil;
    }
    if (_modelsDic) {
        _modelsDic = nil;
    }
    if (_type) {
        _type = nil;
    }
}
@end
