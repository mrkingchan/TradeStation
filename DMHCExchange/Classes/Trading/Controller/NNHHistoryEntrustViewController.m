//
//  NNHHistoryEntrustViewController.m
//  SuperWallet
//
//  Created by 来旭磊 on 2018/3/20.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import "NNHHistoryEntrustViewController.h"
#import "NNTradingDetailLogsViewController.h"
#import "NNCoinTradingMarketModel.h"
#import "NNHHistoryEntrustCell.h"
#import "NNHAPITradingTool.h"
#import "NNTradingEntrustModel.h"

@interface NNHHistoryEntrustViewController ()<UITableViewDelegate, UITableViewDataSource>

/** 列表 */
@property (nonatomic, strong) UITableView *tableView;
/** 数据源数组 */
@property (nonatomic, strong) NSMutableArray *dataSource;
/** 币种模型 */
@property (nonatomic, strong) NNCoinTradingMarketModel *coinTradingMarketModel;

@end

@implementation NNHHistoryEntrustViewController
{
    NSUInteger _page;
}

#pragma mark - Life Cycle Methods
- (instancetype)initWithCoinTradingMarketModel:(NNCoinTradingMarketModel *)model
{
    self = [super init];
    if (self) {
        _coinTradingMarketModel = model;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIConfigManager colorThemeColorForVCBackground];
    
    [self setupChildView];
    
    [self setupRefresh];
    
    [self loadListDataRefresh:YES];
}

- (void)setupRefresh
{
    NNHWeakSelf(self)
    self.tableView.mj_header = [NNRefreshHeader headerWithRefreshingBlock:^{
        [weakself loadListDataRefresh:YES];
    }];
    
    self.tableView.mj_footer = [NNRefreshFooter footerWithRefreshingBlock:^{
        [weakself loadListDataRefresh:NO];
    }];
}

/** 请求数据 */
- (void)loadListDataRefresh:(BOOL)isRefresh
{
    NNHWeakSelf(self)
    _page = isRefresh ? 1 : _page + 1;
    NNHAPITradingTool *tradingTool = [[NNHAPITradingTool alloc] initHistoryEntrustListWithWithCoinID:self.coinTradingMarketModel.marketcoinid page:_page];
    tradingTool.noJumpLogin = YES;
    [tradingTool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {

        if (isRefresh) {
            
            weakself.dataSource = [NNTradingEntrustModel mj_objectArrayWithKeyValuesArray:responseDic[@"data"][@"list"]];
            
            // 重新刷新表格
            [weakself.tableView reloadData];
            // 让刷新控件停止刷新（恢复默认的状态）
            [weakself.tableView.mj_header endRefreshing];
            
            if ([responseDic[@"data"][@"total"] integerValue] == weakself.dataSource.count) {
                [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
            
            // 重置所有状态
            [weakself.tableView.mj_footer resetNoMoreData];

        }else{ // 数据转化
            
            if (responseDic[@"data"][@"list"] == nil) return;
            [weakself.dataSource addObjectsFromArray:[NNTradingEntrustModel mj_objectArrayWithKeyValuesArray:responseDic[@"data"][@"list"]]];
            [weakself.tableView reloadData];
            
            if ([responseDic[@"data"][@"total"] integerValue] == weakself.dataSource.count) {
                [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
            // 结束刷新
            [weakself.tableView.mj_footer endRefreshing];
        }
        
    } failBlock:^(NNHRequestError *error) {
        [weakself.tableView.mj_header endRefreshing];
        [weakself.tableView.mj_footer endRefreshing];
    } isCached:NO];
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

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NNHHistoryEntrustCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NNHHistoryEntrustCell class])];
    cell.tradingEntrustModel = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark --
#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NNTradingEntrustModel *logsModel = self.dataSource[indexPath.row];
    NNTradingDetailLogsViewController *vc = [[NNTradingDetailLogsViewController alloc] initWithCoinTradingDetailModel:logsModel];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Lazy Loads
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [UITableView nnhTableViewPlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 165;
        [_tableView setupEmptyDataText:@"暂无委托记录" emptyImage:ImageName(@"ic_order_none") tapBlock:nil];
        [_tableView registerClass:[NNHHistoryEntrustCell class] forCellReuseIdentifier:NSStringFromClass([NNHHistoryEntrustCell class])];
    }
    return _tableView;
}

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
