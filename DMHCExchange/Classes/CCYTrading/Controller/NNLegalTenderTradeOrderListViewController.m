//
//  NNLegalTenderTradeOrderListViewController.m
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/25.
//  Copyright © 2018 超级钱包. All rights reserved.
//

#import "NNLegalTenderTradeOrderListViewController.h"
#import "NNLegalTenderTradeOrderDetailViewController.h"
#import "NNLegalTenderTradeOrderCell.h"
#import "NNAPILegalTenderTool.h"
#import "NNLegalTenderTradeOrderListModel.h"
#import "NNHTopToolbar.h"

@interface NNLegalTenderTradeOrderListViewController ()<UITableViewDelegate, UITableViewDataSource, NNHTopToolbarDelegate>

/** 列表 */
@property (nonatomic, strong) UITableView *tableView;
/** 数据源数组 */
@property (nonatomic, strong) NSMutableArray *dataSource;
/** 币种模型 */
@property (nonatomic, copy) NSString *coinID;
/** 选项卡 */
@property (nonatomic, strong) NNHTopToolbar *toolBar;
/** 数据请求定时器 */
@property (nonatomic, strong) NSTimer *timer;
/** 订单列表类型 */
@property (nonatomic, assign) NNLegalTenderTradeOrderListType orderListType;

@end

@implementation NNLegalTenderTradeOrderListViewController
{
    NSInteger _page;
}

#pragma mark - Life Cycle Methods

- (instancetype)initWithCoinID:(NSString *)coinID
{
    self = [super init];
    if (self) {
        _coinID = coinID;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIConfigManager colorThemeColorForVCBackground];
    self.navigationItem.title = @"交易记录";
    [self setupChildView];
    
    [self setupRefresh];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self startTimer];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)setupChildView
{
    [self.view addSubview:self.toolBar];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.top.equalTo(self.toolBar.mas_bottom);
    }];
}

/** 开启定时器 */
- (void)startTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(reloadOrderListData) userInfo:nil repeats:YES];
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

- (void)reloadOrderListData
{
    [self loadOrderListDataRefresh:YES];
}

/** 请求数据 */
- (void)loadOrderListDataRefresh:(BOOL)isRefresh
{
    _page = isRefresh ? 1 : _page + 1;
    NNHWeakSelf(self)
    NNAPILegalTenderTool *tradeTool = [[NNAPILegalTenderTool alloc] initOrderListDataWithOrderType:self.orderListType coinID:self.coinID page:_page];
    [tradeTool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
        
        NNHStrongSelf(self)
        if (isRefresh) {
            [strongself loadCoinListData:responseDic];
        }else{
            // 数据转化
            if (responseDic[@"data"][@"list"] == nil) return;
            NSArray *array = [NNLegalTenderTradeOrderListModel mj_objectArrayWithKeyValuesArray:responseDic[@"data"][@"list"]];
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
    self.dataSource = [NNLegalTenderTradeOrderListModel mj_objectArrayWithKeyValuesArray:responseDic[@"data"][@"list"]];
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    
    if ([responseDic[@"data"][@"total"] integerValue] == self.dataSource.count) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    // 重置刷新状态
    [self.tableView.mj_footer resetNoMoreData];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NNLegalTenderTradeOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NNLegalTenderTradeOrderCell class])];
    NNLegalTenderTradeOrderListModel *orderModel = self.dataSource[indexPath.row];
    cell.orderListModel = orderModel;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NNLegalTenderTradeOrderListModel *orderModel = self.dataSource[indexPath.row];
    NNLegalTenderTradeOrderDetailViewController *vc = [[NNLegalTenderTradeOrderDetailViewController alloc] initWithOrderID:orderModel.orderID];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDelegate
- (void)topToolbar:(NNHTopToolbar *)toolbar didSelectedButton:(UIButton *)button
{
    self.orderListType = button.tag;
    [self.tableView reloadData];
    [self reloadOrderListData];
}

#pragma mark - Lazy Loads
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [UITableView nnhTableViewPlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 100;
        _tableView.separatorInset = UIEdgeInsetsMake(0, NNHMargin_15, 0, NNHMargin_15);
        [_tableView setupEmptyDataText:@"暂无记录" emptyImage:ImageName(@"ic_order_none") tapBlock:nil];
        [_tableView registerClass:[NNLegalTenderTradeOrderCell class] forCellReuseIdentifier:NSStringFromClass([NNLegalTenderTradeOrderCell class])];
    }
    return _tableView;
}

- (NNHTopToolbar *)toolBar
{
    if (_toolBar == nil) {
        _toolBar = [[NNHTopToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NNHTopToolbarH) titles:@[@"未完成",@"已完成",@"已取消"]];
        _toolBar.delegate = self;
    }
    return _toolBar;
}

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
