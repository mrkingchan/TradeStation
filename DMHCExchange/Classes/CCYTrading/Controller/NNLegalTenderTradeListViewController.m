//
//  NNLegalTenderTradeListViewController.m
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/25.
//  Copyright © 2018 超级钱包. All rights reserved.
//

#import "NNLegalTenderTradeListViewController.h"
#import "NNLegalTenderTradeActionViewController.h"
#import "NNLegalTenderTradeModel.h"
#import "NNLegalTenderTradeListCell.h"
#import "NNAPILegalTenderTool.h"
#import "NNLegalTenderTradeListHeaderView.h"

@interface NNLegalTenderTradeListViewController ()<UITableViewDelegate, UITableViewDataSource, NNLegalTenderTradeReloadDataProtocol>

/** 列表 */
@property (nonatomic, strong) UITableView *tableView;
/** 头部view */
@property (nonatomic, strong) NNLegalTenderTradeListHeaderView *headerView;
/** 数据源数组 */
@property (nonatomic, strong) NSMutableArray <NNLegalTenderTradeModel *> *dataSource;
/** 交易类型 */
@property (nonatomic, assign) NNLegalTenderTradeType tradeType;
/** 币种id */
@property (nonatomic, strong) NSString *coinID;
/** 币种名称 */
@property (nonatomic, strong) NSString *coinName;
@end

@implementation NNLegalTenderTradeListViewController
{
    NSInteger _page;
}

#pragma mark - Life Cycle Methods

- (instancetype)initWithTradeType:(NNLegalTenderTradeType)tradeType
{
    if (self = [super init]) {
        _tradeType = tradeType;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIConfigManager colorThemeWhite];
    
    [self setupRefresh];
    
    [self setupChildView];
}

#pragma mark - Initial Methods
- (void)setupChildView
{
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.headerView.mas_bottom);
    }];
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
    NNAPILegalTenderTool *tradingTool = [[NNAPILegalTenderTool alloc] initWithMatchOrderListDataWithTradeType:self.tradeType coinID:self.coinID page:_page];
    [tradingTool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
        
        NNHStrongSelf(self)
        if (isRefresh) {
            [strongself loadCoinListData:responseDic];
        }else{
            // 数据转化
            if (responseDic[@"data"][@"list"] == nil) return;
            NSArray *array = [NNLegalTenderTradeModel mj_objectArrayWithKeyValuesArray:responseDic[@"data"][@"list"]];
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
    self.dataSource = [NNLegalTenderTradeModel mj_objectArrayWithKeyValuesArray:responseDic[@"data"][@"list"]];
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    
    self.headerView.coinName = self.coinName;
    self.headerView.availableAmount = responseDic[@"data"][@"coinamount"];
    self.headerView.freezeAmount = responseDic[@"data"][@"fut_coinamount"];
    

    if ([responseDic[@"data"][@"total"] integerValue] == self.dataSource.count) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    // 重置刷新状态
    [self.tableView.mj_footer resetNoMoreData];
}

#pragma mark - NNLegalTenderTradeReloadDataProtocol

- (void)reloadCoinListDataWithCoinID:(NSString *)coinID coinName:(nonnull NSString *)coinName
{
    self.coinID = coinID;
    self.coinName = coinName;
    [self reloadNetworkData];
}

- (void)reloadNetworkData
{
    [self loadOrderListDataRefresh:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NNLegalTenderTradeListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NNLegalTenderTradeListCell class])];
    NNLegalTenderTradeModel *tradeModel = self.dataSource[indexPath.row];
    cell.tradeModel = tradeModel;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NNLegalTenderTradeModel *tradeModel = self.dataSource[indexPath.row];
    
    NNUserModel *userModel = [NNHProjectControlCenter sharedControlCenter].userControl_currentUserModel;
    if ([userModel.uid isEqualToString:tradeModel.userid]) {
        [SVProgressHUD showMessage:@"不能与自己交易"];
        return;
    };
    
    if (![[NNHApplicationHelper sharedInstance] isRealName]) return;
    if (![[NNHApplicationHelper sharedInstance] isBindMoible]) return;
    if (![[NNHApplicationHelper sharedInstance] isBindBankCard]) return;
    if (![[NNHApplicationHelper sharedInstance] isSetupPayPassword]) return;
    
    NNHWeakSelf(self)
    [SVProgressHUD show];
    NNAPILegalTenderTool *tradeTool = [[NNAPILegalTenderTool alloc] initUserTradeStatusWithType:tradeModel.type];
    [tradeTool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
        [SVProgressHUD dismiss];
        NSString *key = responseDic[@"data"][@"key"];
        if (key.length) {
            [SVProgressHUD showMessage:key];
        }else {
            NNLegalTenderTradeActionViewController *vc = [[NNLegalTenderTradeActionViewController alloc] initWithTradeID:tradeModel.orderID];
            [weakself.navigationController pushViewController:vc animated:YES];
        }
    } failBlock:^(NNHRequestError *error) {

    } isCached:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? 5 : 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

#pragma mark - Lazy Loads

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [UITableView nnhTableViewPlain];
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIConfigManager colorThemeWhite];
        _tableView.dataSource = self;
        _tableView.rowHeight = 100;
        _tableView.separatorInset = UIEdgeInsetsMake(0, NNHMargin_15, 0, NNHMargin_15);
        [_tableView setupEmptyDataText:@"暂无记录" emptyImage:ImageName(@"ic_order_none") tapBlock:nil];
        [_tableView registerClass:[NNLegalTenderTradeListCell class] forCellReuseIdentifier:NSStringFromClass([NNLegalTenderTradeListCell class])];
    }
    return _tableView;
}

-(NSMutableArray<NNLegalTenderTradeModel *> *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

-(NNLegalTenderTradeListHeaderView *)headerView
{
    if (_headerView == nil) {
        _headerView = [[NNLegalTenderTradeListHeaderView alloc] init];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, NNHNormalViewH + 10);
    }
    return _headerView;
}

@end
