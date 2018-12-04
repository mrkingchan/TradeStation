//
//  NNHMyBankCardController.m
//  NNCivetCat
//
//  Created by 来旭磊 on 17/3/28.
//  Copyright © 2017年 灵猫. All rights reserved.
//

#import "NNHMyBankCardController.h"
#import "NNAddPaymentCodeViewController.h"
#import "NNHBankCardCell.h"
#import "NNHAddBankCardController.h"
#import "NNAPIMineTool.h"
#import "NNHBankCardModel.h"
#import "NNHAlertTool.h"

@interface NNHMyBankCardController ()<UITableViewDelegate, UITableViewDataSource>
/** 银行卡列表 */
@property (nonatomic, strong) UITableView *tableView;
/** 地址数组 */
@property (nonatomic, strong) NSMutableArray *dataSource;
/** 管理按钮 */
@property (nonatomic, strong) UIButton *manageButton;
/** 添加按钮 */
@property (nonatomic, strong) UIButton *addButton;
/** 记录当前选种行 */
@property (nonatomic, strong) NSIndexPath *currentIndex;

@end

@implementation NNHMyBankCardController

#pragma mark -
#pragma mark -------- Lifecycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self requestBankListData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIConfigManager colorThemeColorForVCBackground];
    [self setupNavItem];
    [self setupChildView];
}

- (void)setupNavItem
{
    self.navigationItem.title = @"我的银行卡";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.manageButton];
}

- (void)setupChildView
{
    [self.view addSubview:self.addButton];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-NNHNormalViewH - (NNHBottomSafeHeight));
    }];
    
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-(NNHBottomSafeHeight));
        make.top.equalTo(self.tableView.mas_bottom);
    }];
}

#pragma mark -
#pragma mark --------- RequestNetData
- (void)requestBankListData
{
    NNHWeakSelf(self)
    NNAPIMineTool *cardTool = [[NNAPIMineTool alloc] initBankCardList];
    [cardTool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
        weakself.dataSource = [NNHBankCardModel mj_objectArrayWithKeyValuesArray:responseDic[@"data"][@"list"]];
        [weakself.tableView reloadData];
    } failBlock:^(NNHRequestError *error) {
        
    } isCached:NO];
}

#pragma mark -
#pragma mark --------- UserActions
- (void)manageButtonClick:(UIButton *)button
{
    if (self.dataSource.count == 0) {
        self.manageButton.selected = NO;
        [self.addButton setTitle:@"添加" forState:UIControlStateNormal];
        return;
    }
    
    button.selected = !button.selected;
    [self.tableView reloadData];
    self.currentIndex = nil;
    if (button.selected) {
        [self.addButton setTitle:@"解绑" forState:UIControlStateNormal];
    }else {
        [self.addButton setTitle:@"添加" forState:UIControlStateNormal];
    }
    [self.tableView reloadData];
}

- (void)clickAddButton
{
    if (self.manageButton.selected) {
        if (!self.currentIndex) {
            [SVProgressHUD showMessage:@"请选择要解绑的账户"];
        }else {
            NNHWeakSelf(self);
            NNHBankCardModel *cardModel = self.dataSource[self.currentIndex.row];
            NNAPIMineTool *cardTool = [[NNAPIMineTool alloc] initUnBankWithCardID:cardModel.cardID];
            [cardTool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
                [SVProgressHUD showMessage:@"解绑成功"];
                weakself.currentIndex = nil;
                [weakself requestBankListData];
            } failBlock:^(NNHRequestError *error) {
                
            } isCached:NO];
        }
    }else {
        if (![NNHApplicationHelper sharedInstance].isRealName) return;
        NNHWeakSelf(self)
        [[NNHAlertTool shareAlertTool] showActionSheet:self title:nil message:nil acttionTitleArray:@[@"添加银行卡",@"添加微信／支付宝收款码"] confirm:^(NSInteger index) {
            if (index == 0) {
                NNHAddBankCardController *vc = [[NNHAddBankCardController alloc] init];
                [weakself.navigationController pushViewController:vc animated:YES];
            }else{
                NNAddPaymentCodeViewController *vc = [[NNAddPaymentCodeViewController alloc] init];
                [weakself.navigationController pushViewController:vc animated:YES];
            }
        } cancle:^{
            
        }];
        
        NNHAddBankCardController *addVc = [[NNHAddBankCardController alloc] init];
        [self.navigationController pushViewController:addVc animated:YES];
    }
}

#pragma mark -
#pragma mark --------- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.manageButton.hidden = self.dataSource.count <= 1;
    if (self.dataSource.count <= 1) {
        self.manageButton.selected = NO;
        [self.addButton setTitle:@"添加" forState:UIControlStateNormal];
    }
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NNHBankCardCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NNHBankCardCell class])];
    cell.selectButton.hidden = !self.manageButton.selected;
    cell.selectButton.selected = NO;
    cell.cardModel = self.dataSource[indexPath.row];
    if (self.currentIndex.row == indexPath.row && self.manageButton.selected && self.currentIndex) {
        cell.selectButton.selected = YES;
    }
    return cell;
}

#pragma mark -
#pragma mark --------- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.manageButton.selected) {
        if (self.currentIndex) {
            NNHBankCardCell *oldCell = [tableView cellForRowAtIndexPath:self.currentIndex];
            oldCell.selectButton.selected = NO;
        }
        
        NNHBankCardCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.selectButton.selected = YES;
        self.currentIndex = indexPath;
    }
}

#pragma mark -
#pragma mark ---------Getter && Setter

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [UITableView nnhTableViewPlain];
        _tableView.rowHeight = 100 + NNHMargin_15;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        _tableView.contentInset = UIEdgeInsetsMake(NNHMargin_5, 0, NNHMargin_5, 0);
        [_tableView setupEmptyDataText:@"您还没有绑定账户" emptyImage:ImageName(@"ic_add_card") tapBlock:nil];
        [_tableView registerClass:[NNHBankCardCell class] forCellReuseIdentifier:NSStringFromClass([NNHBankCardCell class])];
    }
    return _tableView;
}

- (UIButton *)manageButton
{
    if (_manageButton == nil) {
        _manageButton = [UIButton NNHBtnTitle:@"管理" titileFont:[UIConfigManager fontThemeTextMain] backGround:[UIColor clearColor] titleColor:[UIConfigManager colorThemeDarkGray]];
        _manageButton.frame = CGRectMake(0, 0, NNHNormalViewH, NNHNormalViewH);
        [_manageButton setTitle:@"取消" forState:UIControlStateSelected];
        [_manageButton addTarget:self action:@selector(manageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _manageButton.hidden = YES;
    }
    return _manageButton;
}

- (UIButton *)addButton
{
    if (_addButton == nil) {
        _addButton = [UIButton NNHOperationBtnWithTitle:@"添加" target:self action:@selector(clickAddButton) operationButtonType:NNHOperationButtonTypeRed isAddCornerRadius:NO];
    }
    return _addButton;
}

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
