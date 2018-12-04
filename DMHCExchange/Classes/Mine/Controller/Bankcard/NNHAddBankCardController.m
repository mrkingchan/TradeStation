//
//  NNHAddBankCardController.m
//  NNCivetCat
//
//  Created by 来旭磊 on 17/3/28.
//  Copyright © 2017年 灵猫. All rights reserved.
//

#import "NNHAddBankCardController.h"
#import "NNHAddBankCardCell.h"
#import "NNHBankCardItem.h"
#import "NNHBankCardModel.h"
#import "NNHAlertTool.h"
#import "NNAPIMineTool.h"

@interface NNHAddBankCardController ()<UITableViewDelegate, UITableViewDataSource>

/** 列表 */
@property (nonatomic, strong) UITableView *tableView;
/** 数组 */
@property (nonatomic, strong) NSMutableArray *dataSource;
/** 银行卡模型 */
@property (nonatomic, strong) NNHBankCardModel *cardModel;
/** 列表尾部 */
@property (nonatomic, strong) UIView *footerView;

@end

@implementation NNHAddBankCardController

#pragma mark -
#pragma mark -------- Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"添加银行卡";
    self.view.backgroundColor = [UIConfigManager colorThemeColorForVCBackground];
    
    self.cardModel = [[NNHBankCardModel alloc] init];
    self.cardModel.cardType = @"1";
    [self createItems];
    [self setupChildView];
}

#pragma mark -
#pragma mark --------- PrivateMethod
- (void)setupChildView
{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)createItems
{
    //    NNHBankCardItem *item0 = [NNHBankCardItem itemWithName:@"选择账户类型" itemRightText:@"个人"];
    //    item0.hasArrow = YES;
    //    NSMutableArray * array0 = [NSMutableArray array];
    //    [array0 addObject:item0];
    //    [self.dataSource addObject:array0];
    
    NNHBankCardItem *item1 = [NNHBankCardItem itemWithName:@"银行开户名" itemPlaceHolder:@"请输入姓名"];
    NNHBankCardItem *item2 = [NNHBankCardItem itemWithName:@"银行卡号" itemPlaceHolder:@"请输入银行卡号"];
    NNHBankCardItem *item3 = [NNHBankCardItem itemWithName:@"开户银行" itemPlaceHolder:@""];
    NNHBankCardItem *item4 = [NNHBankCardItem itemWithName:@"支行名称" itemPlaceHolder:@"开户行支行"];
//    NNHBankCardItem *item5 = [NNHBankCardItem itemWithName:@"手机号" itemPlaceHolder:@"银行预留手机号"];
    
    NSMutableArray * array1 = [NSMutableArray arrayWithObjects:item1, item2, item3, item4, nil];
    [self.dataSource addObject:array1];
    
    // 个人用户如果有真实姓名，则填写真实姓名
    NNUserModel *userModel = [NNHProjectControlCenter sharedControlCenter].userControl_currentUserModel;
    item1.itemText = @"";
    if (userModel.realname && ![userModel.realname isEqualToString:@""]) {
        item1.itemText = userModel.realname;
    }
    self.cardModel.cardUserName = item1.itemText;
}

- (void)setBankCardModelItemWithTitle:(NSString *)title indexPath:(NSIndexPath *)index
{
    if (index.row == 0) {
        self.cardModel.cardUserName = title;
    }
    
    if (index.row == 1) {
        self.cardModel.cardNum = title;
    }
    
    if (index.row == 2) {
        self.cardModel.cardBankName = title;
    }
    
    if (index.row == 3) {
        self.cardModel.cardBankSubName = title;
    }
    
    if (index.row == 4) {
        self.cardModel.cardMobile = title;
    }
}

/** 识别银行名称根据银行卡号 */
- (void)recognizeBankNameWithBankNum:(NSString *)bankNum
{
    self.cardModel.cardNum = bankNum;
    
    //长度大于等于6时 去验证银行名称
    if (bankNum.length >= 6) {
        NNHWeakSelf(self)
        NNAPIMineTool *cardTool = [[NNAPIMineTool alloc] initGetBankNameWithPreBankCardNum:bankNum];
        [cardTool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
            NSString *bankName = responseDic[@"data"];
            weakself.cardModel.cardBankName = bankName;
            
            NSMutableArray *array = weakself.dataSource[0];
            NNHBankCardItem *item = array[2];
            item.itemText = bankName;
            
            [weakself.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:2 inSection:0],nil] withRowAnimation:UITableViewRowAnimationNone];
            
        } failBlock:^(NNHRequestError *error) {
            
        } isCached:NO];
    }
}

#pragma mark -
#pragma mark --------- PublicMethod

#pragma mark -
#pragma mark --------- RequestNetData

#pragma mark -
#pragma mark --------- UserActions
- (void)addBankCardAction
{
    if (!self.cardModel.cardUserName || [self.cardModel.cardUserName isEqualToString:@""]) {
        if ([self.cardModel.cardType isEqualToString:@"1"]) {
            [SVProgressHUD showMessage:@"请输入姓名"];
            return;
        }
        if ([self.cardModel.cardType isEqualToString:@"2"]) {
            [SVProgressHUD showMessage:@"请输入公司名称"];
            return;
        }
    }
    
    if (!self.cardModel.cardBankName) {
        [SVProgressHUD showMessage:@"请选择开户银行名称"];
        return;
    }
    
    if (!self.cardModel.cardNum) {
        [SVProgressHUD showMessage:@"请输入银行卡号"];
        return;
    }
    
    if (!self.cardModel.cardBankSubName) {
        [SVProgressHUD showMessage:@"请输入开户行支行名称"];
        return;
    }
    
    NNHWeakSelf(self)
    NNAPIMineTool *cardTool = [[NNAPIMineTool alloc] initAddNewBankCardWithAccountType:self.cardModel.cardType account_name:self.cardModel.cardUserName account_number:self.cardModel.cardNum bank_type_name:self.cardModel.cardBankName branch:self.cardModel.cardBankSubName mobile:@""];
    [cardTool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
        NNHStrongSelf(self)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD showMessage:@"添加成功"];
            
            // 修改状态并保存
            NNUserModel *userModel = [NNHProjectControlCenter sharedControlCenter].userControl_currentUserModel;
            userModel.banknumber = @"1";
            [[NNHProjectControlCenter sharedControlCenter] userControl_saveUserDataWithUserInfo:userModel];
            
            [strongself.navigationController popViewControllerAnimated:YES];
            
        });
    } failBlock:^(NNHRequestError *error) {
    } isCached:NO];
}

#pragma mark -
#pragma mark --------- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = self.dataSource[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NNHAddBankCardCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NNHAddBankCardCell class])];
    cell.currentIndexPath = indexPath;
    cell.cardCellItem = self.dataSource[indexPath.section][indexPath.row];
    NNHWeakSelf(self)
    cell.didChangedTextFieldBlock = ^(NSString *text, NSIndexPath *index){
        if (index.row == 1 && [self.cardModel.cardType isEqualToString:@"1"]) {
            //只有个人用户才去识别银行卡号
            [weakself recognizeBankNameWithBankNum:text];
        }else {
            [weakself setBankCardModelItemWithTitle:text indexPath:index];
        }
    };
    return cell;
}

#pragma mark -
#pragma mark --------- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NNHWeakSelf(self)
//    if (indexPath.section == 0 && indexPath.row == 0) {
//        dispatch_async(dispatch_get_main_queue(),^{
//            
//            [[NNHAlertTool shareAlertTool] showActionSheet:self title:nil message:nil acttionTitleArray:@[@"个人账户", @"公司账户"] confirm:^(NSInteger index) {
//                if (index == 0) {
//                    NNUserModel *userModel = [NNHProjectControlCenter sharedControlCenter].userControl_currentUserModel;
//                    weakself.cardModel.cardType = @"1";
//                    NSMutableArray *array = self.dataSource[indexPath.section];
//                    NNHBankCardItem *item = array[indexPath.row];
//                    item.itemRightText = @"个人";
//                    
//                    NSMutableArray *array1 = self.dataSource[1];
//                    NNHBankCardItem *item0 = array1[0];
//                    item0.itemPlaceHolder = @"请输入姓名";
//                    item0.itemText = @"";
//                    if (userModel.realname && ![userModel.realname isEqualToString:@""]) {
//                        item0.itemText = userModel.realname;
//                    }
//                    weakself.cardModel.cardUserName = item0.itemText;
//                    
//                }else{
//                    weakself.cardModel.cardType = @"2";
//                    NSMutableArray *array = self.dataSource[indexPath.section];
//                    NNHBankCardItem *item = array[indexPath.row];
//                    item.itemRightText = @"公司账户";
//                    
//                    NSMutableArray *array1 = self.dataSource[1];
//                    NNHBankCardItem *item0 = array1[0];
//                    item0.itemPlaceHolder = @"请输入公司名称";
//                    item0.itemText = @"";
//                    weakself.cardModel.cardUserName = @"";
//                }
//                [weakself.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
//                [weakself.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
//            } cancle:^{
//                
//            }];
//        });
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return NNHMargin_10;
}

#pragma mark -
#pragma mark --------- UITextFieldDelegate

#pragma mark -
#pragma mark --------- Getter && Setter

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [UITableView nnhTableViewPlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = NNHNormalViewH;
        [_tableView registerClass:[NNHAddBankCardCell class] forCellReuseIdentifier:NSStringFromClass([NNHAddBankCardCell class])];
        _tableView.scrollEnabled = NO;
        _tableView.tableFooterView = self.footerView;
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

- (UIView *)footerView
{
    if (_footerView == nil) {
        _footerView = [[UIView alloc] init];
        _footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 120);
        _footerView.backgroundColor = [UIConfigManager colorThemeColorForVCBackground];
        UIButton *submitButton = [UIButton NNHOperationBtnWithTitle:@"确定" target:self action:@selector(addBankCardAction) operationButtonType:NNHOperationButtonTypeRed isAddCornerRadius:YES];
        submitButton.nn_acceptEventInterval = NNHAcceptEventInterval;
        [_footerView addSubview:submitButton];
        submitButton.nn_acceptEventInterval = NNHAcceptEventInterval;
        [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_footerView);
            make.bottom.equalTo(_footerView).offset(-NNHMargin_15);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 30, NNHNormalViewH));
        }];
    }
    return _footerView;
}

@end
