//
//  NNTradingDetailLogsViewController.m
//  SuperWallet
//
//  Created by 牛牛 on 2018/8/15.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import "NNTradingDetailLogsViewController.h"
#import "NNTradingDetailLogHeaderView.h"
#import "NNTradingDetailLogCell.h"
#import "NNTradingEntrustModel.h"

@interface NNTradingDetailLogsViewController ()<UITableViewDelegate, UITableViewDataSource>

/** 列表 */
@property (nonatomic, strong) UITableView *tableView;
/** 币种模型 */
@property (nonatomic, strong) NNTradingEntrustModel *logsModel;

@end

@implementation NNTradingDetailLogsViewController

#pragma mark - Life Cycle Methods
- (instancetype)initWithCoinTradingDetailModel:(NNTradingEntrustModel *)model
{
    self = [super init];
    if (self) {
        _logsModel = model;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"成交明细";
    self.view.backgroundColor = [UIConfigManager colorThemeColorForVCBackground];
    
    [self setupChildView];
}

#pragma mark - Initial Methods
- (void)setupChildView
{
    // 头部view
    NNTradingDetailLogHeaderView *logHeaderView = [[NNTradingDetailLogHeaderView alloc] init];
    logHeaderView.tradingEntrustModel = self.logsModel;
    [self.view addSubview:logHeaderView];
    [logHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(NNHLineH);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@110);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logHeaderView.mas_bottom).offset(NNHMargin_10);
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.logsModel.logs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NNTradingDetailLogCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NNTradingDetailLogCell class])];
    
    NNTradingLogModel *tradingLogModel = self.logsModel.logs[indexPath.row];
    tradingLogModel.type = self.logsModel.type;
    cell.tradingLogModel = self.logsModel.logs[indexPath.row];
    return cell;
}

#pragma mark - Lazy Loads
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [UITableView nnhTableViewPlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 140;
        [_tableView registerClass:[NNTradingDetailLogCell class] forCellReuseIdentifier:NSStringFromClass([NNTradingDetailLogCell class])];
    }
    return _tableView;
}

@end
