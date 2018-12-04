//
//  NNMineViewController.m
//  SuperWallet
//
//  Created by 牛牛 on 2018/3/2.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import "NNMineViewController.h"
#import "NNHMyBankCardController.h"
#import "NNLoginViewController.h"
#import "NNHMineAboutViewController.h"
#import "NNMineQrCodeViewController.h"
#import "NNMineNoticeViewController.h"
#import "NNMineAccountSecurityViewController.h"
#import "NNRealNameAuthenticationViewController.h"
#import "NNMineInformationViewController.h"
#import "NNHMyHeaderView.h"
#import "NNMineCell.h"
#import "NNHMyGroup.h"
#import "NNHMyItem.h"
#import "NNMineModel.h"
#import "NNAPIMineTool.h"

@interface NNMineViewController ()

/** 头部view */
@property (nonatomic, strong) NNHMyHeaderView *myHeaderView;
/** 会员模型 */
@property (nonatomic, strong) NNMineModel *mineModel;

@end

@implementation NNMineViewController
#pragma mark -
#pragma mark ---------Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    [self requestMyDataSource];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"个人中心";
    
    // 设置tableview
    [self setupTableview];
    
    // 设置数据
    [self setupGroups];
    
    // 通知
    [self setupNotice];
}

- (void)setupTableview
{
    self.tableView.backgroundColor = [UIConfigManager colorThemeColorForVCBackground];
    self.tableView.tableHeaderView = self.myHeaderView;
    self.tableView.rowHeight = 60;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[NNMineCell class] forCellReuseIdentifier:NSStringFromClass([NNMineCell class])];
}

- (void)setupNotice
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backHomeNotice) name:NNH_NotificationBackHome object:nil];
}

- (void)backHomeNotice
{
    self.tabBarController.selectedIndex = 0;
}

- (void)setupGroups
{
    [self setupGroup];
    
    [self.tableView reloadData];
}

- (void)setupGroup
{
    // 1.创建组
    NNHMyGroup *group = [NNHMyGroup group];
    [self.groups addObject:group];
    
    NNHMyItem *item0 = [NNHMyItem itemWithTitle:@"收款方式" icon:nil itemAccessoryViewType:NNHItemAccessoryViewTypeCustomView];
    NNHMyItem *item1 = [NNHMyItem itemWithTitle:@"推荐返佣" icon:nil itemAccessoryViewType:NNHItemAccessoryViewTypeCustomView];
    NNHMyItem *item2 = [NNHMyItem itemWithTitle:@"安全中心" icon:nil itemAccessoryViewType:NNHItemAccessoryViewTypeCustomView];
    NNHMyItem *item3 = [NNHMyItem itemWithTitle:@"平台公告" icon:nil itemAccessoryViewType:NNHItemAccessoryViewTypeCustomView];
    NNHMyItem *item4 = [NNHMyItem itemWithTitle:@"关于我们" icon:nil itemAccessoryViewType:NNHItemAccessoryViewTypeCustomView];
    
    item0.customRightView = [[UIImageView alloc] initWithImage:ImageName(@"ic_center_payment")];
    item1.customRightView = [[UIImageView alloc] initWithImage:ImageName(@"ic_center_rebates")];
    item2.customRightView = [[UIImageView alloc] initWithImage:ImageName(@"ic_center_security")];
    item3.customRightView = [[UIImageView alloc] initWithImage:ImageName(@"ic_center_notice")];
    item4.customRightView = [[UIImageView alloc] initWithImage:ImageName(@"ic_center_about")];
    
    item0.destVcClass = [NNHMyBankCardController class];
    item1.destVcClass = [NNMineQrCodeViewController class];
    item3.destVcClass = [NNMineNoticeViewController class];
    item4.destVcClass = [NNHMineAboutViewController class];
    NNHWeakSelf(self)
    item2.operation = ^{
        if (![[NNHProjectControlCenter sharedControlCenter] loginStatus:YES]) return;
        NNMineAccountSecurityViewController *vc = [[NNMineAccountSecurityViewController alloc] init];
        vc.logoutSuccessBlock = ^{
            weakself.mineModel.userModel.mtoken = @"";
            weakself.myHeaderView.mineModel = weakself.mineModel;
            weakself.tabBarController.selectedIndex = 0;
        };
        [weakself.navigationController pushViewController:vc animated:YES];
    };
    
    // 2.设置组的所有行数据
    group.items = @[item0, item1, item2, item3, item4];
    
}

- (void)requestMyDataSource {
    NNHWeakSelf(self)
    NNAPIMineTool *tool = [[NNAPIMineTool alloc] initMemberDataSource];
    tool.noJumpLogin = YES;
    [tool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
        weakself.mineModel = [NNMineModel mj_objectWithKeyValues:responseDic[@"data"]];
        
        // 保存用户资料
        [[NNHProjectControlCenter sharedControlCenter] userControl_saveUserDataWithUserInfo:weakself.mineModel.userModel];
        weakself.myHeaderView.mineModel = weakself.mineModel;
        
        [weakself.tableView reloadData];
        
    } failBlock:^(NNHRequestError *error) {
        weakself.myHeaderView.mineModel = weakself.mineModel;
    } isCached:NO];
}

#pragma mark -
#pragma mark ---------UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NNMineCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NNMineCell class])];
    NNHMyGroup *group = self.groups[indexPath.section];
    cell.myItem = group.items[indexPath.row];
    
    return cell;
}

#pragma mark -
#pragma mark ---------UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NNHMyGroup *group = self.groups[indexPath.section];
    NNHMyItem *item = group.items[indexPath.row];
    
    if ([item.destVcClass isSubclassOfClass:[NNHMyBankCardController class]] ||
        [item.destVcClass isSubclassOfClass:[NNMineQrCodeViewController class]]) {
        if (![[NNHProjectControlCenter sharedControlCenter] loginStatus:YES]) return;
    }
    
    // 是否有跳转控制器
    if (item.destVcClass) {
        UIViewController *destVC = [[item.destVcClass alloc] init];
        destVC.title = item.title;
        [self.navigationController pushViewController:destVC animated:YES];
    }
    
    // 是否有想做的事情
    if (item.operation) {
        item.operation();
    }
}

#pragma mark -
#pragma mark ---------Getters & Setters
- (NNHMyHeaderView *)myHeaderView
{
    if (_myHeaderView == nil) {
        _myHeaderView = [[NNHMyHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
        NNHWeakSelf(self)
        _myHeaderView.headerViewJumpBlock = ^(NNHMyHeaderViewJumpType type){
            NNHStrongSelf(self)
            if (type == NNHMyHeaderViewJumpTypeRealName) {
                NNRealNameAuthenticationViewController *vc = [[NNRealNameAuthenticationViewController alloc] init];
                [strongself.navigationController pushViewController:vc animated:YES];
            }else if (type == NNHMyHeaderViewJumpTypeInformation) {
                NNMineInformationViewController *vc = [[NNMineInformationViewController alloc] init];
                [strongself.navigationController pushViewController:vc animated:YES];
            }else{
                [NNLoginViewController presentInViewController:strongself completion:nil];
            }
        };
    }
    return _myHeaderView;
}
@end
