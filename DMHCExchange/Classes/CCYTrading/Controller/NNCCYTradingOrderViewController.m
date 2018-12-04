//
//  NNCCYTradingOrderViewController.m
//  SuperWallet
//
//  Created by 牛牛 on 2018/9/13.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import "NNCCYTradingOrderViewController.h"
#import "NNCCYTradingOrderDetailViewController.h"
#import "NNCoinTradingMarketModel.h"
#import "NNCCYTradingOrderCell.h"
#import "NNHAPITradingTool.h"
#import "NNCCYTradingModel.h"

@interface NNCCYTradingOrderViewController ()<UITableViewDelegate, UITableViewDataSource>

/** 列表 */
@property (nonatomic, strong) UITableView *tableView;
/** 数据源数组 */
@property (nonatomic, strong) NSMutableArray *dataSource;
/** 币种模型 */
@property (nonatomic, strong) NNCoinTradingMarketModel *coinTradingMarketModel;
/** 数据请求定时器 */
@property (nonatomic, strong) NSTimer *timer;
/** 记录当前刷新时间 */
@property (nonatomic, copy) NSString *refreshTime;

@end

@implementation NNCCYTradingOrderViewController

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
    
    //[self loadListDataRefresh:YES];
}

- (void)setupRefresh {
    NNHWeakSelf(self)
    self.tableView.mj_header = [NNRefreshHeader headerWithRefreshingBlock:^{
        // 获取第一条数据并重制刷新时间
        NNCCYTradingModel *firstRewardDetailModel = [weakself.dataSource firstObject];
        weakself.refreshTime= firstRewardDetailModel.time;
        
        [weakself loadListDataRefresh:YES];
    }];
    
    self.tableView.mj_footer = [NNRefreshFooter footerWithRefreshingBlock:^{
        
        // 获取当前最后一条数据并重制刷新时间
        NNCCYTradingModel *lastRewardDetailModel = [weakself.dataSource lastObject];
        weakself.refreshTime= lastRewardDetailModel.time;
        
        [weakself loadListDataRefresh:NO];
    }];
}

/** 请求数据 */
- (void)loadListDataRefresh:(BOOL)isRefresh {
    NNHWeakSelf(self)
    NNHAPITradingTool *tradingTool = [[NNHAPITradingTool alloc] initHistoryEntrustListWithCoinName:self.coinTradingMarketModel.symbol ccy:self.coinTradingMarketModel.ccy ctime:self.refreshTime pullRefresh:isRefresh];
    [tradingTool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
        if (isRefresh) {
            NSArray *newRecordLists = [NNCCYTradingModel mj_objectArrayWithKeyValuesArray:responseDic[@"data"]];
            // 将新数据插入到旧数据的最前面
            NSRange range = NSMakeRange(0, newRecordLists.count);
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
            [weakself.dataSource insertObjects:newRecordLists atIndexes:indexSet];
            
            // 重新刷新表格
            [weakself.tableView reloadData];
            // 让刷新控件停止刷新（恢复默认的状态）
            [weakself.tableView.mj_header endRefreshing];
            // 重置所有状态
            [weakself.tableView.mj_footer resetNoMoreData];
            
        }else{
            // 获得最新的微博frame数组
            NSArray *newRecordLists = [NNCCYTradingModel mj_objectArrayWithKeyValuesArray:responseDic[@"data"]];
            
            if (newRecordLists.count == 0) {
                [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
            
            // 将新数据插入到旧数据的最后面
            [weakself.dataSource addObjectsFromArray:newRecordLists];
            
            // 重新刷新表格
            [weakself.tableView reloadData];
            
            // 让刷新控件停止刷新（恢复默认的状态）
            [weakself.tableView.mj_footer endRefreshing];
        }
        
    } failBlock:^(NNHRequestError *error) {
        [weakself.tableView.mj_header endRefreshing];
        [weakself.tableView.mj_footer endRefreshing];
    } isCached:NO];
}

#pragma mark - Initial Methods
- (void)setupChildView {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NNCCYTradingOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NNCCYTradingOrderCell class])];
    cell.ccyTradingModel = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark --
#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NNCCYTradingOrderDetailViewController *vc = [[NNCCYTradingOrderDetailViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

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
        _tableView.rowHeight = 110;
        [_tableView setupEmptyDataText:@"暂无委托记录" emptyImage:ImageName(@"ic_order_none") tapBlock:nil];
        [_tableView registerClass:[NNCCYTradingOrderCell class] forCellReuseIdentifier:NSStringFromClass([NNCCYTradingOrderCell class])];
    }
    return _tableView;
}

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
        
        for (NSInteger i = 0; i < 50; i++) {
            NNCCYTradingModel *model = [[NNCCYTradingModel alloc] init];
            model.username = [NSString stringWithFormat:@"周%zd",i];
            model.symbol = @"USDT";
            model.statusText = @"交易完成";
            model.time = @"1533090663";
            model.buy = i % 2 == 0;
            model.market = @"6.88";
            model.vol = @"20";
            model.volScale = @"99";
            model.min = @"100";
            model.max = @"50000";
            model.num = [NSString stringWithFormat:@"%zd",i+1];
            [_dataSource addObject:model];
        }
    }
    return _dataSource;
}
@end
