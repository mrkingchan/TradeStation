//
//  NNWalletViewController.m
//  SuperWallet
//
//  Created by 牛牛 on 2018/3/2.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import "NNWalletViewController.h"
#import "NNHWalletTableHeaderView.h"
#import "NNWalletTableViewCell.h"
#import "NNWalletPropertyModel.h"
#import "NNWalletPropertyRecordListViewController.h"
#import "NNWalletCoinRechargeViewController.h"
#import "NNHWalletCoinWithdrawViewController.h"
#import "NNHApiWalletTool.h"

@interface NNWalletViewController ()<UITableViewDataSource, UITableViewDelegate>

/** 列表 */
@property (nonatomic, strong) UITableView *tableView;
/** 头部view */
@property (nonatomic, strong) NNHWalletTableHeaderView *tableHeaderView;
/** 关键字 */
@property (nonatomic, copy) NSString *keyword;
/** 数据源数组 */
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation NNWalletViewController

#pragma mark -
#pragma mark ---------Life Cycle
- (void)dealloc
{
    NNHLog(@"-------%s------",__func__);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIConfigManager colorThemeColorForVCBackground];
    
    // 初始化UI
    [self setupChildView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self requesListData];
}

- (void)setupChildView
{
//    self.tableView.tableHeaderView = self.tableHeaderView;
    
    [self.view addSubview:self.tableHeaderView];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.tableHeaderView.mas_bottom).offset(NNHLineH);
    }];
}

#pragma mark -
#pragma mark ---------UserAction

#pragma mark -
#pragma mark ---------UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NNWalletTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NNWalletTableViewCell class])];
    NNHWeakSelf(self)
    NNWalletPropertyModel *propertyModel = self.dataSource[indexPath.row];
    cell.propertyModel = propertyModel;
    cell.walletOperationBlock = ^(NNHWalletOperationType type) {
        [weakself walletCellActionWithOpeartionType:type property:propertyModel];
    };

    return cell;
}

#pragma mark -
#pragma mark ---------UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - Network Methods

- (void)requesListData
{
    NNHWeakSelf(self)
    NNHApiWalletTool *networkTool = [[NNHApiWalletTool alloc] initWithWalletListDataWithKeyword:self.keyword];
    [networkTool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
        weakself.dataSource = [NNWalletPropertyModel mj_objectArrayWithKeyValuesArray:responseDic[@"data"][@"conlist"]];
        [weakself.tableView reloadData];
        
        [weakself.tableHeaderView configAmount:responseDic[@"data"][@"totalamount"] amountUnit:responseDic[@"data"][@"amounttype"]];
        
    } failBlock:^(NNHRequestError *error) {
        
    } isCached:NO];
    
}

#pragma mark - Target Methods

#pragma mark - Public Methods

- (void)walletCellActionWithOpeartionType:(NNHWalletOperationType)operationType property:(NNWalletPropertyModel *)property
{
    if (operationType == NNHWalletOperationType_recharge) {
        NNWalletCoinRechargeViewController *rechargeVC = [[NNWalletCoinRechargeViewController alloc] initWithCoinID:property.coinid coinName:property.coinname];
        [self.navigationController pushViewController:rechargeVC animated:YES];
    }else if (operationType == NNHWalletOperationType_withdraw) {
        if (![[NNHApplicationHelper sharedInstance] isRealName]) return;
        if (![[NNHApplicationHelper sharedInstance] isSetupPayPassword]) return;
        
        NNHWalletCoinWithdrawViewController *withdrawVC = [[NNHWalletCoinWithdrawViewController alloc] initWithCoinID:property.coinid coinName:property.coinname];
        [self.navigationController pushViewController:withdrawVC animated:YES];
    }else {
        NNWalletPropertyRecordListViewController *listVC = [[NNWalletPropertyRecordListViewController alloc] initWithCoinID:property.coinid coinName:property.coinname];
        [self.navigationController pushViewController:listVC animated:YES];
    }
}
#pragma mark - Private Methods

#pragma mark -
#pragma mark ---------Getters & Setters
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [UITableView nnhTableViewPlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 130;
        _tableView.separatorInset = UIEdgeInsetsMake(0, NNHMargin_15, 0, 0);
        _tableView.backgroundColor = [UIConfigManager colorThemeColorForVCBackground];
        [_tableView registerClass:[NNWalletTableViewCell class] forCellReuseIdentifier:NSStringFromClass([NNWalletTableViewCell class])];

    }
    return _tableView;
}

- (NNHWalletTableHeaderView *)tableHeaderView
{
    if (_tableHeaderView == nil) {
        CGFloat headerHeight = (SCREEN_WIDTH - 30) * 240 / 690 + 30 + NNHNormalViewH;
        _tableHeaderView = [[NNHWalletTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, headerHeight)];
        NNHWeakSelf(self)
        _tableHeaderView.searchTextBlock = ^(NSString *searchText) {
            weakself.keyword = searchText;
            [weakself requesListData];
        };
    }
    return _tableHeaderView;
}

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
