//
//  NNCCYTradingChildViewController.m
//  SuperWallet
//
//  Created by 牛牛 on 2018/9/12.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import "NNCCYTradingChildViewController.h"
#import "NNBuySellCCYTradingOrderViewController.h"
#import "NNCCYTradingModel.h"
#import "NNCCYTradingListCell.h"
#import "NNHAPITradingTool.h"

@interface NNCCYTradingChildViewController ()<UITableViewDelegate, UITableViewDataSource>

/** 列表 */
@property (nonatomic, strong) UITableView *tableView;
/** 数据源数组 */
@property (nonatomic, strong) NSMutableArray <NNCCYTradingModel *> *dataSource;

@end

@implementation NNCCYTradingChildViewController
{
    NSInteger _page;
}

#pragma mark - Life Cycle Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIConfigManager colorThemeColorForVCBackground];
    
    [self setupChildView];
}

#pragma mark - Initial Methods
- (void)setupChildView
{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)loadAllEntrustListDatasource
{
//    NNHWeakSelf(self)
//    NNHAPITradingTool *tradingTool = [[NNHAPITradingTool alloc] initCurrentEntrustListWithCoinName:self.coinTradingMarketModel.symbol ccy:self.coinTradingMarketModel.ccy];
//    [tradingTool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
//        weakself.dataSource = [NNTradingEntrustModel mj_objectArrayWithKeyValuesArray:responseDic[@"data"]];
//        [weakself.tableView reloadData];
//    } failBlock:^(NNHRequestError *error) {
//
//    } isCached:NO];
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
    NNCCYTradingListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NNCCYTradingListCell class])];
    NNCCYTradingModel *ccyTradingModel = self.dataSource[indexPath.section];
    ccyTradingModel.buy = YES;
    cell.ccyTradingModel = ccyTradingModel;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NNBuySellCCYTradingOrderViewController *vc = [[NNBuySellCCYTradingOrderViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
        _tableView = [UITableView nnhTableViewGroup];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 90;
        [_tableView setupEmptyDataText:@"暂无记录" emptyImage:ImageName(@"ic_order_none") tapBlock:nil];
        [_tableView registerClass:[NNCCYTradingListCell class] forCellReuseIdentifier:NSStringFromClass([NNCCYTradingListCell class])];
    }
    return _tableView;
}

-(NSMutableArray<NNCCYTradingModel *> *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
        for (NSInteger i = 0; i < 50; i++) {
            NNCCYTradingModel *model = [[NNCCYTradingModel alloc] init];
            model.username = [NSString stringWithFormat:@"周%zd",i];
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
