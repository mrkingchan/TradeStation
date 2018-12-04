//
//  NNWalletPropertyRecordListViewController.m
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/24.
//  Copyright © 2018 超级钱包. All rights reserved.
//

#import "NNWalletPropertyRecordListViewController.h"
//#import "NNWalletPropertyRecordDetailViewController.h"
#import "NNWalletPropertyRecordModel.h"
#import "NNWalletPropertyRecordCell.h"
#import "NNHApiWalletTool.h"
#import "YBPopupMenu.h"

@interface NNWalletPropertyRecordListViewController ()<UITableViewDelegate, UITableViewDataSource, YBPopupMenuDelegate>

/** 行情列表 */
@property (nonatomic, strong) UITableView *tableView;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray *dataSource;
/** 筛选类型 */
@property (nonatomic, copy) NSString *type;
/** 筛选参数数组 */
@property (nonatomic, strong) NSMutableArray *selectArray;
/** 币种id */
@property (nonatomic, copy) NSString *coinID;
/** 币种id */
@property (nonatomic, copy) NSString *coinName;

@end

@implementation NNWalletPropertyRecordListViewController
{
    NSInteger _page;
}

#pragma mark - Life Cycle Methods

- (instancetype)initWithCoinID:(NSString *)coinID coinName:(NSString *)coinName;
{
    if (self = [super init]) {
        _coinID = coinID;
        _coinName = coinName;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIConfigManager colorThemeColorForVCBackground];
    self.navigationItem.title = [NSString stringWithFormat:@"%@账单",self.coinName];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(rightItemsAction) title:@"筛选"];
    self.type = @"1";
    [self setupChildView];
    
    [self setupRefresh];
    
    [self requestRecoedListWithRefresh:YES];
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
        [weakself requestRecoedListWithRefresh:YES];
    }];

    self.tableView.mj_footer = [NNRefreshFooter footerWithRefreshingBlock:^{
        [weakself requestRecoedListWithRefresh:NO];
    }];
}

#pragma mark - Network Methods

- (void)requestRecoedListWithRefresh:(BOOL)isRefresh
{
    _page = isRefresh ? 1 : _page + 1;
    NNHWeakSelf(self)
    
    NNHApiWalletTool *walletTool = [[NNHApiWalletTool alloc] initWithCoinTransferListDataWithCoinID:self.coinID type:self.type page:_page];

    [walletTool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
        if (isRefresh) {
            [weakself loadOrderDataSource:responseDic];
        }else{
            // 数据转化
            if (responseDic[@"data"] == nil) return;
            NSArray *newsArr = [NNWalletPropertyRecordModel mj_objectArrayWithKeyValuesArray:responseDic[@"data"][@"list"]];
            [weakself.dataSource addObjectsFromArray:newsArr];
            [weakself.tableView reloadData];

            if ([responseDic[@"data"][@"total"] integerValue] == self.dataSource.count) {
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

- (void)loadOrderDataSource:(NSDictionary *)responseDic
{
    self.dataSource = [NNWalletPropertyRecordModel mj_objectArrayWithKeyValuesArray:responseDic[@"data"][@"list"]];
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
    NNWalletPropertyRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NNWalletPropertyRecordCell class])];
    cell.recordModel = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NNWalletPropertyRecordModel *model = self.dataSource[indexPath.row];
//    NNWalletPropertyRecordDetailViewController *vc = [[NNWalletPropertyRecordDetailViewController alloc] initWithWalletPropertyRecordModel:model];
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Private Methods

- (void)rightItemsAction
{
    NSArray *array = [self.selectArray valueForKeyPath:@"name"];
    CGPoint point = CGPointMake(SCREEN_WIDTH - 30, (NNHNavBarViewHeight) - 25);
    [YBPopupMenu showAtPoint:point titles:array icons:nil menuWidth:100 otherSettings:^(YBPopupMenu *popupMenu) {
        popupMenu.dismissOnSelected = NO;
        popupMenu.showMaskView = NO;
        popupMenu.isShowShadow = NO;
        popupMenu.delegate = self;
        popupMenu.offset = NNHMargin_15;
        popupMenu.cornerRadius = 0;
        popupMenu.type = YBPopupMenuTypeDark;
        popupMenu.textColor = [UIColor whiteColor];
        popupMenu.minSpace = 15;
        popupMenu.backColor = [[UIColor akext_colorWithHex:@"#4c5570"] colorWithAlphaComponent:0.9];
        popupMenu.fontSize = 13;
    }];
}

- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index
{
    [ybPopupMenu dismiss];
    
    NSMutableDictionary *params = self.selectArray[index];
    self.type = params[@"type"];
    
    [self requestRecoedListWithRefresh:YES];
}


#pragma mark - Lazy Loads
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [UITableView nnhTableViewPlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 105;
        _tableView.separatorInset = UIEdgeInsetsMake(0, NNHMargin_15, 0, 0);
        [_tableView setupEmptyDataText:@"暂无记录" emptyImage:ImageName(@"ic_order_none") tapBlock:nil];
        [_tableView registerClass:[NNWalletPropertyRecordCell class] forCellReuseIdentifier:NSStringFromClass([NNWalletPropertyRecordCell class])];
    }
    return _tableView;
}

- (NSMutableArray *)selectArray
{
    if (_selectArray == nil) {
        _selectArray = [NSMutableArray array];
        NSArray *nameArray = @[@"全部", @"充币", @"提币"];
        NSArray *typeArray = @[@"1", @"2", @"3"];
        
        for (int i = 0; i < nameArray.count; i ++) {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"name"] = nameArray[i];
            params[@"type"] = typeArray[i];
            [_selectArray addObject:params];
        }
    }
    return _selectArray;
}


@end
