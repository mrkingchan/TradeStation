//
//  NNHCurrentEntrustViewController.m
//  SuperWallet
//
//  Created by 来旭磊 on 2018/3/20.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import "NNHCurrentEntrustViewController.h"
#import "NNCoinTradingMarketModel.h"
#import "NNHCurrentEntrustCell.h"
#import "NNHAPITradingTool.h"
#import "NNTradingEntrustModel.h"
#import "NNHAlertTool.h"

@interface NNHCurrentEntrustViewController ()<UITableViewDelegate, UITableViewDataSource>

/** 列表 */
@property (nonatomic, strong) UITableView *tableView;
/** 数据源数组 */
@property (nonatomic, strong) NSMutableArray *dataSource;
/** 币种模型 */
@property (nonatomic, strong) NNCoinTradingMarketModel *coinTradingMarketModel;
/** 数据请求定时器 */
@property (nonatomic, strong) NSTimer *timer;
/** 滑动列表时是否添加数据 */
@property (nonatomic, assign) BOOL pauseRequestDataFlag;

@end

@implementation NNHCurrentEntrustViewController
{
    NSInteger _page;
}

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
    
    [self startTimer];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - Initial Methods
- (void)setupChildView
{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(NNHLineH);
        make.left.bottom.right.equalTo(self.view);
    }];
}

/** 开启定时器 */
- (void)startTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(updateCurrentData) userInfo:nil repeats:YES];
}

- (void)updateCurrentData
{
    if (self.pauseRequestDataFlag) return;
    [self loadAllEntrustListDatasource];
}

- (void)loadAllEntrustListDatasource
{
    NNHWeakSelf(self)
    NNHAPITradingTool *tradingTool = [[NNHAPITradingTool alloc] initCurrentEntrustListWithCoinID:self.coinTradingMarketModel.marketcoinid];
    tradingTool.noJumpLogin = YES;
    [tradingTool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
        weakself.dataSource = [NNTradingEntrustModel mj_objectArrayWithKeyValuesArray:responseDic[@"data"]];
        [weakself.tableView reloadData];
    } failBlock:^(NNHRequestError *error) {
        
    } isCached:NO];
}

- (void)cancleOrderWithOrderno:(NSString *)orderno
{
    NNHWeakSelf(self)
    [[NNHAlertTool shareAlertTool] showAlertView:self title:@"确认撤单？" message:nil cancelButtonTitle:@"取消" otherButtonTitle:@"确认" confirm:^{
        NNHStrongSelf(self)
        NNHAPITradingTool *tradingTool = [[NNHAPITradingTool alloc] initCancelOrderWithOrderno:orderno];
        [tradingTool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
            [SVProgressHUD nn_dismiss];
            [SVProgressHUD showMessage:@"撤单成功"];
            [strongself loadAllEntrustListDatasource];
        } failBlock:^(NNHRequestError *error) {
            
        } isCached:NO];
    } cancle:^{
        
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NNHCurrentEntrustCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NNHCurrentEntrustCell class])];
    cell.tradingEntrustModel = self.dataSource[indexPath.row];
    NNHWeakSelf(self)
    cell.cancleBlock = ^(NSString *ID) {
        [weakself cancleOrderWithOrderno:ID];
    };
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat contentOffset = scrollView.contentOffset.y;
    if (contentOffset > SCREEN_WIDTH) {
        self.pauseRequestDataFlag = YES;
    }else {
        self.pauseRequestDataFlag = NO;
    }
}

#pragma mark - Lazy Loads

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [UITableView nnhTableViewPlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 110;
        [_tableView setupEmptyDataText:@"暂无委托记录" emptyImage:ImageName(@"ic_order_none") tapBlock:nil];
        [_tableView registerClass:[NNHCurrentEntrustCell class] forCellReuseIdentifier:NSStringFromClass([NNHCurrentEntrustCell class])];
    }
    return _tableView;
}

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
