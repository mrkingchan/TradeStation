//
//  NNCoinSearchViewController.m
//  DMHCExchange
//
//  Created by 牛牛 on 2018/11/6.
//  Copyright © 2018年 超级钱包. All rights reserved.
//

#import "NNCoinSearchViewController.h"
#import "NNHExchangeMainViewController.h"
#import "NNCoinTextField.h"
#import "NNCoinSearchHistoryHeaderView.h"
#import "NNCoinSearchHelper.h"
#import "NNHAPITradingTool.h"
#import "NNCoinSearchModel.h"
#import "NNCoinTradingMarketModel.h"

@interface NNCoinSearchViewController ()<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

/** 货币ID */
@property (nonatomic, copy) NSString *ccyID;
/** 导航栏搜索框 */
@property (nonatomic, strong) NNCoinTextField *searchField;
/** 历史列表 */
@property (nonatomic, strong) UITableView *tableView;
/** 搜索帮助类 */
@property (nonatomic, strong) NNCoinSearchHelper *searchHelper;
/** 搜索数据 */
@property (nonatomic, strong) NSArray <NNCoinSearchModel *> *searchDataSource;

@end

@implementation NNCoinSearchViewController

#pragma mark -
#pragma mark -------- Lifecycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (instancetype)initWithCCYID:(NSString *)ccyID
{
    if (self = [super init]) {
        _ccyID = ccyID;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIConfigManager colorThemeWhite];
    
    [self setupChildView];
}

#pragma mark -
#pragma mark --------- PrivateMethod
- (void)setupChildView
{
    CGFloat cancelButtonW = 60;
    [self.view addSubview:self.searchField];
    [self.searchField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset((STATUSBAR_HEIGHT) + 6);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-(cancelButtonW));
        make.height.equalTo(@32);
    }];
    
    UIButton *cancelButton = [UIButton NNHBtnTitle:@"取消" titileFont:[UIConfigManager fontThemeTextMain] backGround:[UIColor whiteColor] titleColor:[UIConfigManager colorThemeDark]];
    [cancelButton addTarget:self action:@selector(dissmissAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.searchField);
        make.right.equalTo(self.view);
        make.width.equalTo(@(cancelButtonW));
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(NNHNavBarViewHeight);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (void)dissmissAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark --------- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchDataSource.count > 0) {
        return self.searchDataSource.count;
    }
    return self.searchHelper.historyArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:13];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.searchDataSource.count > 0) {
        NNCoinSearchModel *model = self.searchDataSource[indexPath.row];
        cell.textLabel.text = model.name;
    }else{
        NNCoinSearchModel *model = self.searchHelper.historyArray[indexPath.row];
        cell.textLabel.text = model.name;
    }
    
    return cell;
}

#pragma mark -
#pragma mark ---------UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NNCoinSearchModel *searchModel;
    if (self.searchDataSource.count > 0) {
        searchModel = self.searchDataSource[indexPath.row];
    }else{
        searchModel = self.searchHelper.historyArray[indexPath.row];
    }
    
    // 存储或者改变其位置
    [self.searchHelper addNewHistoryWithSearchModel:searchModel];
    
    NNCoinTradingMarketModel *tradingMarketModel = [[NNCoinTradingMarketModel alloc] init];
    tradingMarketModel.marketcoinid = searchModel.marketcoinid;
    tradingMarketModel.name = searchModel.name;
    tradingMarketModel.coinname = searchModel.coinname;
    tradingMarketModel.unitcoinname = searchModel.unitcoinname;
    tradingMarketModel.lot = searchModel.coin_round;
    tradingMarketModel.ccylot = searchModel.unitcoin_round;
    NNHExchangeMainViewController *vc = [[NNHExchangeMainViewController alloc] initWithCoinTradingMarketModel:tradingMarketModel];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.searchDataSource.count > 0) {
        return nil;
    }else{
        if (self.searchHelper.historyArray.count > 0) {
            NNCoinSearchHistoryHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([NNCoinSearchHistoryHeaderView class])];
            NNHWeakSelf(self)
            headerView.removeAllOperationBlock = ^{
                [weakself.searchHelper removeAllHistorySearchRecord];
                [weakself.tableView reloadData];
            };
            return headerView;
        }
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.searchDataSource.count > 0) {
        return 0.00;
    }else {
        return self.searchHelper.historyArray.count > 0 ? NNHNormalViewH : 0.00;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchHelper deleteHistroySearchRecordAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView reloadData];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

#pragma mark -
#pragma mark --------- UITextFieldDelegate
- (void)textFieldDidChange:(UITextField *)textField
{
    NNHWeakSelf(self)
    NNHAPITradingTool *tool = [[NNHAPITradingTool alloc] initCoinSearchWithCCYID:self.ccyID keyword:textField.text];
    [tool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
        
        weakself.searchDataSource = [NNCoinSearchModel mj_objectArrayWithKeyValuesArray:responseDic[@"data"]];
        [weakself.tableView reloadData];
        
    } failBlock:^(NNHRequestError *error) {
        
    } isCached:NO];
}

#pragma mark -
#pragma mark --------- Getter && Setter
- (NNCoinTextField *)searchField
{
    if (_searchField == nil) {
        _searchField = [[NNCoinTextField alloc] init];
        _searchField.backgroundColor = [UIColor akext_colorWithHex:@"f2f2f3"];
        _searchField.placeholder = @"搜索感兴趣的币种";
        _searchField.font = [UIConfigManager fontThemeTextDefault];
        [_searchField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _searchField.keyboardType = UIKeyboardTypeASCIICapable;
        NNHViewRadius(_searchField, 16)
    }
    return _searchField;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [UITableView nnhTableViewPlain];
        _tableView.backgroundColor = [UIConfigManager colorThemeWhite];
        _tableView.rowHeight = NNHNormalViewH;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setupEmptyDataText:@"暂无历史记录" emptyImage:ImageName(@"ic_order_none") tapBlock:nil];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
        [_tableView registerClass:[NNCoinSearchHistoryHeaderView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([NNCoinSearchHistoryHeaderView class])];
    }
    return _tableView;
}

- (NNCoinSearchHelper *)searchHelper
{
    if (_searchHelper == nil) {
        _searchHelper = [[NNCoinSearchHelper alloc] init];
    }
    return _searchHelper;
}

@end
