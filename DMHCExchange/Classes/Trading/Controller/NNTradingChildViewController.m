//
//  NNTradingViewController.m
//  SuperWallet
//
//  Created by 牛牛 on 2018/3/2.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import "NNTradingChildViewController.h"
#import "NNHCoinTradingMarketCell.h"
#import "NNCoinTradingMarketModel.h"
#import "NNHExchangeMainViewController.h"
#import "NNHAPITradingTool.h"

@interface NNTradingChildViewController ()<UITableViewDelegate, UITableViewDataSource>

/** 行情列表 */
@property (nonatomic, strong) UITableView *tableView;
/** 数据源数组 */
@property (nonatomic, strong) NSMutableArray <NNCoinTradingMarketModel *> *dataSource;
/** 数据 */
@property (nonatomic, strong) NNCoinTradingMarketModel *coinTradingMarketModel;
/** 定时器 */
@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation NNTradingChildViewController

#pragma mark - Life Cycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIConfigManager colorThemeColorForVCBackground];
    
    [self setupChildView];
    
    [self requestCCYListData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 开启定时器
    dispatch_resume(self.timer);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    dispatch_source_cancel(self.timer);
    self.timer = nil;
}

#pragma mark - Initial Methods
- (void)setupChildView
{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(NNHLineH);
        make.left.bottom.right.equalTo(self.view);
    }];
}

- (void)requestCCYListData
{
    NNHWeakSelf(self)
    NNHAPITradingTool *tradeTool = [[NNHAPITradingTool alloc] initCoinTradingMarketWithCCY:self.ccy];
    [tradeTool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
        weakself.dataSource = [NNCoinTradingMarketModel mj_objectArrayWithKeyValuesArray:responseDic[@"data"][@"list"]];
        [weakself.tableView reloadData];
    } failBlock:^(NNHRequestError *error) {
        
    } isCached:NO];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NNHCoinTradingMarketCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NNHCoinTradingMarketCell class])];
    cell.coinTradingMarketModel = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NNCoinTradingMarketModel *coinTradingMarketModel = self.dataSource[indexPath.row];
    NNHExchangeMainViewController *exchangeVC = [[NNHExchangeMainViewController alloc] initWithCoinTradingMarketModel:coinTradingMarketModel];
    [self.navigationController pushViewController:exchangeVC animated:YES];
}

#pragma mark - Lazy Loads
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [UITableView nnhTableViewPlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 85;
        [_tableView registerClass:[NNHCoinTradingMarketCell class] forCellReuseIdentifier:NSStringFromClass([NNHCoinTradingMarketCell class])];
    }
    return _tableView;
}

- (NSMutableArray<NNCoinTradingMarketModel *> *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (dispatch_source_t)timer
{
    if (_timer == nil) { // 定时刷新
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 5.0 * NSEC_PER_SEC, 0);
        NNHWeakSelf(self)
        dispatch_source_set_event_handler(_timer, ^{
            [weakself requestCCYListData];
        });
    }
    return _timer;
}

@end
