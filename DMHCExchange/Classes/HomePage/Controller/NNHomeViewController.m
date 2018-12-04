//
//  ViewController.m
//  SuperWallet
//
//  Created by 牛牛 on 2018/3/2.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import "NNHomeViewController.h"
#import "NNNewsCell.h"
#import "NNWebViewController.h"
#import "NNHCycleScrollView.h"
#import "NNMoreNewsViewController.h"
#import "AutoScrollLabel.h"
#import "NNHAPIHomeTool.h"
#import "NNMineNoticeViewController.h"
#import "NNHomeTradeCoinCell.h"
#import "NNHExchangeMainViewController.h"
#import "NNCoinTradingMarketModel.h"

@interface NNHomeViewController () <UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;  //数据源

@property (nonatomic, strong) UIView *newsHeaderView; //资讯头部view

@property (nonatomic, strong) UIView *tradeHeaderView;  //交易头部view

@property (nonatomic, strong) NNHCycleScrollView *bannerView;  //轮播图

@property (nonatomic, strong) UIView *tableHeaderView;  //头部view

@property (nonatomic, strong) AutoScrollLabel *scrollNews; //上下轮播文字

@property (nonatomic, strong) NSDictionary  *dataDic;

@end

@implementation NNHomeViewController

#pragma mark - viewController's view's lifeCircle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIConfigManager colorThemeWhite];
    [self loadData];
    [self setupChildView];
}

#pragma mark - loadData
- (void)loadData {
    NNHWeakSelf(self);
    [SVProgressHUD nn_showWithStatus:@"努力加载中..."];
    [[[NNHAPIHomeTool alloc]initWithHomeData] nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
        [SVProgressHUD nn_dismiss];
        NNHStrongSelf(self);
       strongself.tableView.tableHeaderView = strongself.tableHeaderView;
        strongself.dataDic = responseDic;
        //banner
        NSArray <NSDictionary *> *bannerArray = responseDic[@"data"][@"banner"];
        strongself.bannerView.imageURLStringsGroup = [bannerArray valueForKeyPath:@"thumb"];
        [strongself.scrollNews setcontentArray:responseDic[@"data"][@"announcement"] autoScrollUp:YES clickBlock:^(NSInteger scrollId) {
            [strongself.navigationController pushViewController:[NNMineNoticeViewController new] animated:YES];
        }];
        [strongself.dataArray removeAllObjects];
        [strongself.dataArray addObject:[NNNewsModel mj_objectArrayWithKeyValuesArray:responseDic[@"data"][@"newarticle"]]];
        [strongself.dataArray addObject:[NNCoinTradingMarketModel mj_objectArrayWithKeyValuesArray:responseDic[@"data"][@"symbollist"]]];
        [strongself.tableView reloadData];
        [strongself.tableView.mj_header endRefreshing];
    } failBlock:^(NNHRequestError *error) {
        [weakself.tableView.mj_header endRefreshing];
    } isCached:NO];
}

#pragma mark - lazy Load
- (UIView *)tableHeaderView{
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 22 + 40 + 15 + 172.5 + 50)];
        _tableHeaderView.backgroundColor = [UIColor whiteColor];
       //头部logo
        UIImageView *logo = [UIImageView new];
        logo.image = [UIImage imageNamed:@"ic_home_nav_logo"];
        [_tableHeaderView addSubview:logo];
        [logo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_tableHeaderView.mas_top).offset(22);
            make.left.equalTo(_tableHeaderView.mas_left).offset(15);
            make.height.equalTo(@40);
            make.width.equalTo(@135);
        }];
        //轮播图
        [_tableHeaderView addSubview:self.bannerView];
        [_bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(logo.mas_bottom).offset(15);
            make.right.equalTo(_tableHeaderView.mas_right).offset(-15);
            make.left.equalTo(logo);
            make.height.equalTo(@172.5);
        }];
        //用来装公告上下滚动的容器view
        UIView *containerView = [UIView new];
        [_tableHeaderView addSubview:containerView];
        [ containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_bannerView);
            make.right.equalTo(_bannerView);
            make.top.equalTo(_bannerView.mas_bottom);
            make.height.equalTo(@50);
        }];
        
        //小图标
        UIImageView *imageView = [UIImageView new];
        imageView.image = [UIImage imageNamed:@"ic_home_notice"];
        [containerView addSubview:imageView];
        [imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(containerView);
            make.left.equalTo(containerView);
        }];
        
        //公告上下滚动文字
        _scrollNews = [[AutoScrollLabel alloc] initWithFrame:CGRectMake(23, 10, SCREEN_WIDTH - 60, 30)];
        _scrollNews.font = [UIFont systemFontOfSize:14];
        [containerView addSubview:_scrollNews];
    }
    return _tableHeaderView;
}

#pragma mark - 轮播图
- (NNHCycleScrollView *)bannerView{
    if (!_bannerView) {
        _bannerView = [NNHCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:nil];
        _bannerView.pageControlDotSize = CGSizeMake(15, 3);
        _bannerView.pageDotImage = [UIImage imageNamed:@"ic_home_dot_n"];
        _bannerView.currentPageDotImage = [UIImage imageNamed:@"ic_home_dot_s"];
    }
    return _bannerView;
}

#pragma mark - 资讯头部view
- (UIView *)newsHeaderView{
    if (!_newsHeaderView) {
        _newsHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
        _newsHeaderView.backgroundColor = [UIColor whiteColor];
        //最新资讯
        UILabel *latest = [UILabel NNHWithTitle:@"最新资讯" titleColor:[UIColor akext_colorWithHex:@"#333333"] font:[UIFont boldSystemFontOfSize:18]];
        [_newsHeaderView addSubview:latest];
        [latest mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_newsHeaderView.mas_left).offset(15);
            make.centerY.equalTo(_newsHeaderView);
        }];
        //更多
        UIButton *more = [UIButton NNHBtnTitle:@"更多" titileFont:[UIFont systemFontOfSize:13] backGround:[UIColor whiteColor] titleColor:[UIColor akext_colorWithHex:@"f0252a"]];
        [_newsHeaderView addSubview:more];
        [more addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        more.tag = 2000;
        [more mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_newsHeaderView.mas_right).offset(-15);
            make.centerY.equalTo(_newsHeaderView);
            make.width.equalTo(@50);
        }];
    }
    return _newsHeaderView;
}

#pragma mark - 交易行情头部view
- (UIView *)tradeHeaderView{
    if (!_tradeHeaderView) {
        _tradeHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60)];
        _tradeHeaderView.backgroundColor = [UIColor whiteColor];
        //热门行情
        UILabel *latest = [UILabel NNHWithTitle:@"热门行情" titleColor:[UIColor akext_colorWithHex:@"#333333"] font:[UIFont boldSystemFontOfSize:17]];
        [_tradeHeaderView addSubview:latest];
        [latest mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_tradeHeaderView.mas_left).offset(15);
            make.centerY.equalTo(_tradeHeaderView);
        }];
        
        //更多
        UIButton *more = [UIButton NNHBtnTitle:@"更多" titileFont:[UIFont systemFontOfSize:13] backGround:[UIColor whiteColor] titleColor:[UIColor akext_colorWithHex:@"f0252a"]];
        [more addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        more.tag = 2001;
        [_tradeHeaderView addSubview:more];
        [more mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_tradeHeaderView.mas_right).offset(-15);
            make.width.equalTo(@50);
            make.centerY.equalTo(_tradeHeaderView);
        }];
    }
    return _tradeHeaderView;
}

- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [UITableView nnhTableViewGroup];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 90;
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView registerClass:[NNNewsCell class] forCellReuseIdentifier:NSStringFromClass([NNNewsCell class])];
        NNHWeakSelf(self);
        _tableView.mj_header = [NNRefreshHeader headerWithRefreshingBlock:^{
            [weakself loadData];
        }];
        [_tableView registerClass:[NNHomeTradeCoinCell class] forCellReuseIdentifier:NSStringFromClass([NNHomeTradeCoinCell class])];
    }
    return _tableView;
}

#pragma mark - setUpChildView
- (void)setupChildView {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - private Method
- (void)buttonAction:(UIButton *)button {
    if (button.tag == 2000) {
        //资讯更多
        [self.navigationController pushViewController:[NNMoreNewsViewController new] animated:YES];
    } else if (button.tag == 2001) { //交易
        [self.tabBarController setSelectedIndex:1];
    }
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index  {
    NSDictionary <NSString *,NSString *> *bannerData = self.dataDic[@"data"][@"banner"][index];
    if ([bannerData[@"urltype"] integerValue] == 1) { //跳转交易
        NNCoinTradingMarketModel *model = [NNCoinTradingMarketModel new];
        NSArray <NSString *> *items = [bannerData[@"url"] componentsSeparatedByString:@","];
        if (items.count) {
            model.marketcoinid = items[0];
            model.name = items[1];
            model.coinname = [[model.name componentsSeparatedByString:@"/"] firstObject];
            model.unitcoinname = [model.name componentsSeparatedByString:@"/"].lastObject;
            model.lot = items[2];
            model.ccylot = items[3];
        }
        NNHExchangeMainViewController *tradeVC = [[NNHExchangeMainViewController alloc] initWithCoinTradingMarketModel:model];
        [self.navigationController pushViewController:tradeVC animated:YES];
    } else if ([bannerData[@"urltype"] integerValue] == 2) { //跳转资讯
        NNWebViewController *webVC = [NNWebViewController new];
        webVC.url = bannerData[@"url"];
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

#pragma mark - UITableViewDatasource &Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  [self.dataArray[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NNNewsCell *cell = [_tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NNNewsCell class])];
        [cell setNewsModel: ((NSArray *)self.dataArray[0])[indexPath.row]];
        return cell;
    } else if (indexPath.section == 1) {
        NNHomeTradeCoinCell *cell = [_tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NNHomeTradeCoinCell class])];
        [cell setModel: ((NSArray *)_dataArray[1])[indexPath.row]];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? 115: 95;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        //资讯
        NNWebViewController *webVC = [NNWebViewController new];
        webVC.url = ((NNNewsModel *)((NSArray*)_dataArray[0])[indexPath.row]).url;
        [self.navigationController pushViewController:webVC animated:YES];
    } else {
        //交易购买
        NNHExchangeMainViewController *tradeVC = [[NNHExchangeMainViewController alloc] initWithCoinTradingMarketModel:((NNCoinTradingMarketModel *)_dataArray[1][indexPath.row])];
        [self.navigationController pushViewController:tradeVC animated:YES];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return section == 0 ? self.newsHeaderView:self.tradeHeaderView;
}

@end
