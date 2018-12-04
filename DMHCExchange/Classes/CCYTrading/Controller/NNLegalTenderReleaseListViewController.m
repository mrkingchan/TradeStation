//
//  NNLegalTenderReleaseListViewController.m
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/25.
//  Copyright © 2018 超级钱包. All rights reserved.
//

#import "NNLegalTenderReleaseListViewController.h"
#import "NNCoinTradingMarketModel.h"
#import "NNLegalTenderReleaseListCell.h"
#import "NNAPILegalTenderTool.h"
#import "NNLegalTenderTradeReleaseOrderListModel.h"
#import "NNHAlertTool.h"

@interface NNLegalTenderReleaseListViewController ()<UITableViewDelegate, UITableViewDataSource, NNLegalTenderTradeReloadDataProtocol>

/** 列表 */
@property (nonatomic, strong) UITableView *tableView;
/** 数据源数组 */
@property (nonatomic, strong) NSMutableArray *dataSource;
/** 币种id */
@property (nonatomic, strong) NSString *coinID;
@end

@implementation NNLegalTenderReleaseListViewController
{
    NSInteger _page;
}

#pragma mark - Life Cycle Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIConfigManager colorThemeColorForVCBackground];
    
    [self setupChildView];
    
    [self setupRefresh];
}

- (void)setupRefresh
{
    NNHWeakSelf(self)
    self.tableView.mj_header = [NNRefreshHeader headerWithRefreshingBlock:^{
        [weakself loadOrderListDataRefresh:YES];
    }];
    
    self.tableView.mj_footer = [NNRefreshFooter footerWithRefreshingBlock:^{
        [weakself loadOrderListDataRefresh:NO];
    }];
}

#pragma mark - Network Methods

//请求数据
- (void)loadOrderListDataRefresh:(BOOL)isRefresh
{
    NNHWeakSelf(self)
    _page = isRefresh ? 1 : _page + 1;
    NNAPILegalTenderTool *tradeTool = [[NNAPILegalTenderTool alloc] initWithReleaseOrderListDataWithCoinID:self.coinID page:_page];
    [tradeTool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
        
        NNHStrongSelf(self)
        if (isRefresh) {
            [strongself loadCoinListData:responseDic];
        }else{
            // 数据转化
            if (responseDic[@"data"][@"list"] == nil) return;
            NSArray *array = [NNLegalTenderTradeReleaseOrderListModel mj_objectArrayWithKeyValuesArray:responseDic[@"data"][@"list"]];
            [strongself.dataSource addObjectsFromArray:array];
            [strongself.tableView reloadData];
            
            if ([responseDic[@"data"][@"total"] integerValue] == self.dataSource.count) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
            // 结束刷新
            [strongself.tableView.mj_footer endRefreshing];
        }
        [weakself.tableView reloadData];
    } failBlock:^(NNHRequestError *error) {
        NNHStrongSelf(self)
        [strongself.tableView.mj_header endRefreshing];
        [strongself.tableView.mj_footer endRefreshing];
    } isCached:NO];
}

- (void)loadCoinListData:(NSDictionary *)responseDic
{
    self.dataSource = [NNLegalTenderTradeReleaseOrderListModel mj_objectArrayWithKeyValuesArray:responseDic[@"data"][@"list"]];
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    
    if ([responseDic[@"data"][@"total"] integerValue] == self.dataSource.count) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    // 重置刷新状态
    [self.tableView.mj_footer resetNoMoreData];
}

/** 撤销订单 */
- (void)cancleOrderWithOrderID:(NSString *)orderID
{
    NNHWeakSelf(self)
    [[NNHAlertTool shareAlertTool] showAlertView:self title:@"确认撤销交易单？" message:nil cancelButtonTitle:@"取消" otherButtonTitle:@"确定" confirm:^{
        NNAPILegalTenderTool *tradeTool = [[NNAPILegalTenderTool alloc] initCancleReleaseOrderWithOrderID:orderID coinID:self.coinID];
        [tradeTool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
            [weakself reloadNetworkData];
        } failBlock:^(NNHRequestError *error) {
            
        } isCached:NO];
    } cancle:^{
        
    }];
}

#pragma mark - NNLegalTenderTradeReloadDataProtocol

- (void)reloadCoinListDataWithCoinID:(NSString *)coinID coinName:(nonnull NSString *)coinName
{
    self.coinID = coinID;
    [self reloadNetworkData];
}

- (void)reloadNetworkData
{
    [self loadOrderListDataRefresh:YES];
}

#pragma mark - Initial Methods
- (void)setupChildView
{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NNLegalTenderReleaseListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NNLegalTenderReleaseListCell class])];
    NNLegalTenderTradeReleaseOrderListModel *orderModel = self.dataSource[indexPath.row];
    cell.orderModel = orderModel;
    NNHWeakSelf(self)
    cell.cancleOperationBlock = ^{
        [weakself cancleOrderWithOrderID:orderModel.tradeid];
    };
    return cell;
}

#pragma mark --
#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 8;
}

#pragma mark - Lazy Loads
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [UITableView nnhTableViewGroup];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 130;
        [_tableView setupEmptyDataText:@"暂无记录" emptyImage:ImageName(@"ic_order_none") tapBlock:nil];
        [_tableView registerClass:[NNLegalTenderReleaseListCell class] forCellReuseIdentifier:NSStringFromClass([NNLegalTenderReleaseListCell class])];
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
