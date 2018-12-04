//
//  NNTradingViewController.m
//  SuperWallet
//
//  Created by 牛牛 on 2018/3/2.
//  Copyright © 2018年 超级钱包. All rights reserved.
//

#import "NNTradingViewController.h"
#import "NNHCoinTradingMarketCell.h"
#import "NNCoinTradingMarketModel.h"
#import "NNHExchangeMainViewController.h"
#import "NNHAPITradingTool.h"

@interface NNTradingViewController ()<UITableViewDelegate, UITableViewDataSource>

/** 行情列表 */
@property (nonatomic, strong) UITableView *tableView;
/** 数据源数组 */
@property (nonatomic, strong) NSMutableArray <NNCoinTradingMarketModel *> *dataSource;
/** 数据 */
@property (nonatomic, strong) NNCoinTradingMarketModel *coinTradingMarketModel;
/** 头部view */
@property (nonatomic, strong) UIView *headerView;

@end

@implementation NNTradingViewController

#pragma mark - Life Cycle Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIConfigManager colorThemeColorForVCBackground];
    
    [self setupChildView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestTitleMenuListData];
}

#pragma mark - Initial Methods
- (void)setupChildView
{
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@40);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.headerView.mas_bottom);
    }];
}

/** 加载顶部菜单数据 */
- (void)requestTitleMenuListData
{    
    NNHWeakSelf(self)
    NNHAPITradingTool *tradeTool = [[NNHAPITradingTool alloc] initCoinTradingMarketWithCoinType:NNHCoinTradingUnitType_CNY];
    [tradeTool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
        weakself.dataSource = [NNCoinTradingMarketModel mj_objectArrayWithKeyValuesArray:responseDic[@"data"]];
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
    coinTradingMarketModel.ccy = @"CNY";
    NNHExchangeMainViewController *exchangeVC = [[NNHExchangeMainViewController alloc] initWithCoinTradingMarketModel:coinTradingMarketModel coinUnitType:NNHCoinTradingUnitType_CNY];
    [self.navigationController pushViewController:exchangeVC animated:YES];
}

#pragma mark - Lazy Loads
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [UITableView nnhTableViewPlain];
        _tableView.separatorColor = [UIConfigManager colorThemeWhite];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60;
        [_tableView registerClass:[NNHCoinTradingMarketCell class] forCellReuseIdentifier:NSStringFromClass([NNHCoinTradingMarketCell class])];
    }
    return _tableView;
}

- (UIView *)headerView
{
    if (_headerView == nil) {
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = [UIConfigManager colorThemeColorForVCBackground];
        
        UILabel *leftLabel = [UILabel NNHWithTitle:@"名称" titleColor:[UIColor akext_colorWithHex:@"#808080"] font:[UIFont systemFontOfSize:12]];
        [_headerView addSubview:leftLabel];
        [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_headerView);
            make.left.equalTo(_headerView).offset(NNHMargin_15);
            make.width.equalTo(_headerView).multipliedBy(0.3);
        }];
        
        UILabel *middleLabel = [UILabel NNHWithTitle:@"最新价" titleColor:[UIColor akext_colorWithHex:@"#808080"] font:[UIFont systemFontOfSize:12]];
        [_headerView addSubview:middleLabel];
        [middleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_headerView);
            make.left.equalTo(leftLabel.mas_right);
        }];
        
        UILabel *rightLabel = [UILabel NNHWithTitle:@"涨跌" titleColor:[UIColor akext_colorWithHex:@"#808080"] font:[UIFont systemFontOfSize:12]];
        [_headerView addSubview:rightLabel];
        [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_headerView);
            make.right.equalTo(_headerView).offset(-NNHMargin_20);
        }];
    }
    return _headerView;
}

- (NSMutableArray<NNCoinTradingMarketModel *> *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
