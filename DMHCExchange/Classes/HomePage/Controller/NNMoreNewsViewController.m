//
//  NNMoreNewsViewController.m
//  DMHCExchange
//
//  Created by 云笈 on 2018/10/25.
//  Copyright © 2018年 超级钱包. All rights reserved.
//

#import "NNMoreNewsViewController.h"
#import "NNNewsModel.h"
#import "NNNewsCell.h"
#import "NNWebViewController.h"
#import "NNHAPIHomeTool.h"

@interface NNMoreNewsViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray <NNNewsModel *> *dataArray;

@end

@implementation NNMoreNewsViewController

#pragma mark -  viewController's view's lifeCircle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"资讯";
    [self setUpChildViews];
}

#pragma mark - setUpChildViews
- (void)setUpChildViews {
    [self loadData];
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)loadData {
    [[[NNHAPIHomeTool alloc] initWithNewsList]  nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
        [self.dataArray addObjectsFromArray:[NNNewsModel mj_objectArrayWithKeyValuesArray:responseDic[@"data"][@"list"]]];
        [self.tableView reloadData];
    } failBlock:^(NNHRequestError *error) {
        
    } isCached:NO];
}

#pragma mark - lazy Load
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView nnhTableViewPlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 90;
        NNHWeakSelf(self);
        [_tableView setupEmptyDataText:@"暂无记录" emptyImage:ImageName(@"ic_order_none") tapBlock:^ {
            NNHStrongSelf(self);
            [strongself loadData];
        }];
        [_tableView registerClass:[NNNewsCell class] forCellReuseIdentifier:NSStringFromClass([NNNewsCell class])];
    }
    return _tableView;
}

- (NSMutableArray  <NNNewsModel *> *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

#pragma mark - UITableViewDataSource & delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    NNNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NNNewsCell class])];
    [cell setNewsModel:_dataArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NNWebViewController *webVC = [NNWebViewController new];
    webVC.url =  ((NNNewsModel *)_dataArray[indexPath.row]).url;
    [self.navigationController pushViewController:webVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 115;
}

#pragma mark - memory management

-(void)dealloc {
    if (_tableView) {
        _tableView.dataSource = nil;
        _tableView.delegate = nil;
        _tableView = nil;
    }
    if (_dataArray) {
        _dataArray = nil;
    }
}
@end
