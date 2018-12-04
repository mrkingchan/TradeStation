//
//  NNMineShareRewardViewController.m
//  DMHCExchange
//
//  Created by 牛牛 on 2018/10/24.
//  Copyright © 2018年 超级钱包. All rights reserved.
//

#import "NNMineShareRewardViewController.h"
#import "NNMineShareRewardCell.h"
#import "NNMineShareRewardModel.h"
#import "NNAPIMineTool.h"

@interface NNMineShareRewardViewController ()<UITableViewDelegate, UITableViewDataSource>

/** 列表 */
@property (nonatomic, strong) UITableView *tableView;
/** 推荐人数 */
@property (nonatomic, strong) UILabel *numberLabel;
/** 模型 */
@property (nonatomic, strong) NSMutableArray <NNMineShareRewardModel *> *shareRewards;

@end

@implementation NNMineShareRewardViewController
{
    NSUInteger _page;
}

#pragma mark - Life Cycle Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"返佣记录";
    self.view.backgroundColor = [UIConfigManager colorThemeColorForVCBackground];
    
    [self setupChildView];
    [self setupRefresh];
    [self requestDataSourceRefresh:YES];
}

#pragma mark - Initial Methods
- (void)setupChildView
{
    // 头部view
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@100);
    }];
    
    UIImageView *shareContentView = [[UIImageView alloc] initWithImage:ImageName(@"referee_bg")];
    [topView addSubview:shareContentView];
    [shareContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView);
        make.left.equalTo(topView).offset(15);
        make.right.equalTo(topView).offset(-15);
        make.height.equalTo(@80);
    }];
    
    UILabel *sharePromptLabel = [UILabel NNHWithTitle:@"推荐人数" titleColor:[UIColor whiteColor] font:[UIConfigManager fontThemeTextMain]];
    [shareContentView addSubview:sharePromptLabel];
    [sharePromptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(shareContentView);
        make.left.equalTo(shareContentView).offset(15);
    }];
    
    UILabel *numUnitLabel = [UILabel NNHWithTitle:@"人" titleColor:[UIColor whiteColor] font:[UIConfigManager fontThemeTextDefault]];
    [shareContentView addSubview:numUnitLabel];
    [numUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sharePromptLabel.mas_centerY);
        make.right.equalTo(shareContentView).offset(-15);
    }];
    
    [shareContentView addSubview:self.numberLabel];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sharePromptLabel);
        make.right.equalTo(numUnitLabel.mas_left).offset(-3);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom).offset(NNHMargin_10);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (void)setupRefresh
{
    NNHWeakSelf(self)
    self.tableView.mj_header = [NNRefreshHeader headerWithRefreshingBlock:^{
        [weakself requestDataSourceRefresh:YES];
    }];
    self.tableView.mj_footer = [NNRefreshFooter footerWithRefreshingBlock:^{
        [weakself requestDataSourceRefresh:NO];
    }];
}

- (void)requestDataSourceRefresh:(BOOL)refresh
{
    NNHWeakSelf(self)
    _page = refresh ? 1 : _page + 1;
    NNAPIMineTool *tool = [[NNAPIMineTool alloc] initBrokerageWithPage:_page];
    [tool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {

        if (refresh) {
            
            weakself.shareRewards = [NNMineShareRewardModel mj_objectArrayWithKeyValuesArray:responseDic[@"data"][@"list"]];
            weakself.numberLabel.text = responseDic[@"data"][@"count"];
            [weakself.tableView reloadData];
            [weakself.tableView.mj_header endRefreshing];
            
            if ([responseDic[@"data"][@"total"] integerValue] == weakself.shareRewards.count) {
                [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
            // 重置刷新状态
            [weakself.tableView.mj_footer resetNoMoreData];
            
        }else{
            // 数据转化
            if (responseDic[@"data"][@"list"] == nil) return;
            [weakself.shareRewards addObjectsFromArray:[NNMineShareRewardModel mj_objectArrayWithKeyValuesArray:responseDic[@"data"][@"list"]]];
            [weakself.tableView reloadData];
            
            if ([responseDic[@"data"][@"total"] integerValue] == weakself.shareRewards.count) {
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

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.shareRewards.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NNMineShareRewardCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NNMineShareRewardCell class])];
    cell.shareRewardModel = self.shareRewards[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *titleLabel = [UILabel NNHWithTitle:@"    返佣记录" titleColor:[UIConfigManager colorThemeDark] font:[UIFont boldSystemFontOfSize:15]];
    titleLabel.backgroundColor = [UIColor whiteColor];
    return titleLabel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

#pragma mark - Lazy Loads
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [UITableView nnhTableViewPlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 80;
        [_tableView setupEmptyDataText:@"暂无记录" emptyImage:ImageName(@"ic_order_none") tapBlock:nil];
        [_tableView registerClass:[NNMineShareRewardCell class] forCellReuseIdentifier:NSStringFromClass([NNMineShareRewardCell class])];
    }
    return _tableView;
}

- (NSMutableArray<NNMineShareRewardModel *> *)shareRewards
{
    if (_shareRewards == nil) {
        _shareRewards = [NSMutableArray array];        
    }
    return _shareRewards;
}

- (UILabel *)numberLabel
{
    if (_numberLabel == nil) {
        _numberLabel = [UILabel NNHWithTitle:@"0" titleColor:[UIColor whiteColor] font:[UIFont boldSystemFontOfSize:30]];
    }
    return _numberLabel;
}

@end
