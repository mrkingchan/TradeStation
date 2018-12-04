//
//  NNMineNoticeViewController.m
//  DMHCExchange
//
//  Created by 牛牛 on 2018/10/25.
//  Copyright © 2018年 超级钱包. All rights reserved.
//

#import "NNMineNoticeViewController.h"
#import "NNWebViewController.h"
#import "NNMineNoticeCell.h"
#import "NNMineNoticeModel.h"
#import "NNAPIMineTool.h"

@interface NNMineNoticeViewController ()<UITableViewDelegate, UITableViewDataSource>

/** 列表 */
@property (nonatomic, strong) UITableView *tableView;
/** 模型 */
@property (nonatomic, strong) NSMutableArray <NNMineNoticeModel *> *notices;

@end

@implementation NNMineNoticeViewController
{
    NSUInteger _page;
}

#pragma mark - Life Cycle Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"公告";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupChildView];
    [self setupRefresh];
    [self requestNoticeDataRefresh:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

#pragma mark - Initial Methods
- (void)setupChildView
{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)setupRefresh
{
    NNHWeakSelf(self)
    self.tableView.mj_header = [NNRefreshHeader headerWithRefreshingBlock:^{
        [weakself requestNoticeDataRefresh:YES];
    }];
    self.tableView.mj_footer = [NNRefreshFooter footerWithRefreshingBlock:^{
        [weakself requestNoticeDataRefresh:NO];
    }];
}

- (void)requestNoticeDataRefresh:(BOOL)refresh
{
    NNHWeakSelf(self)
    _page = refresh ? 1 : _page + 1;
    NNAPIMineTool *tool = [[NNAPIMineTool alloc] initNoticeDataSource];
    [tool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
        
        NNHStrongSelf(self)
        if (refresh) {
            [strongself loadCoinListData:responseDic];
        }else{
            // 数据转化
            if (responseDic[@"data"][@"list"] == nil) return;
            [strongself.notices addObjectsFromArray:[NNMineNoticeModel mj_objectArrayWithKeyValuesArray:responseDic[@"data"][@"list"]]];
            [strongself.tableView reloadData];
            
            if ([responseDic[@"data"][@"total"] integerValue] == strongself.notices.count) {
                [strongself.tableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
            // 结束刷新
            [strongself.tableView.mj_footer endRefreshing];
        }
        
    } failBlock:^(NNHRequestError *error) {
        [weakself.tableView.mj_header endRefreshing];
        [weakself.tableView.mj_footer endRefreshing];
    } isCached:NO];
}

- (void)loadCoinListData:(NSDictionary *)responseDic
{
    self.notices = [NNMineNoticeModel mj_objectArrayWithKeyValuesArray:responseDic[@"data"][@"list"]];
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    
    if ([responseDic[@"data"][@"total"] integerValue] == self.notices.count) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    // 重置刷新状态
    [self.tableView.mj_footer resetNoMoreData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.notices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NNMineNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NNMineNoticeCell class])];
    cell.noticeModel = self.notices[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NNMineNoticeModel *noticeModel = self.notices[indexPath.row];
    NNWebViewController *vc = [[NNWebViewController alloc] init];
    vc.url = noticeModel.url;
    vc.backHome = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Lazy Loads
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [UITableView nnhTableViewPlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 80;
        [_tableView setupEmptyDataText:@"暂无公告" emptyImage:ImageName(@"ic_order_none") tapBlock:nil];
        [_tableView registerClass:[NNMineNoticeCell class] forCellReuseIdentifier:NSStringFromClass([NNMineNoticeCell class])];
    }
    return _tableView;
}

- (NSMutableArray<NNMineNoticeModel *> *)notices
{
    if (_notices == nil) {
        _notices = [NSMutableArray array];
    }
    return _notices;
}

@end
