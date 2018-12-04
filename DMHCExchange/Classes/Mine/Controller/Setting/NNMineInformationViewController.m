//
//  NNMineInformationViewController.m
//  DMHCExchange
//
//  Created by 牛牛 on 2018/10/30.
//  Copyright © 2018年 超级钱包. All rights reserved.
//

#import "NNMineInformationViewController.h"
#import "NNNickNameViewController.h"

@interface NNMineInformationViewController ()

@property (nonatomic, strong) NNHMyItem *nicknameItem;

@end

@implementation NNMineInformationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIConfigManager colorThemeColorForVCBackground];
    self.navigationItem.title = @"个人资料";
    
    self.tableView.rowHeight = 60;
    
    [self setupGroups];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.nicknameItem.rightTitle = [NNHProjectControlCenter sharedControlCenter].userControl_currentUserModel.nickname;
}

- (void)setupGroups
{
    [self setupGroup0];
    [self.tableView reloadData];
}

- (void)setupGroup0
{
    // 1.创建组
    NNHMyGroup *group = [NNHMyGroup group];
    [self.groups addObject:group];
    
    // 2.设置组的所有行数据
    self.nicknameItem = [NNHMyItem itemWithTitle:@"昵称" itemAccessoryViewType:NNHItemAccessoryViewTypeRightView];
    NNHMyItem *realnameItem = [NNHMyItem itemWithTitle:@"真实姓名" itemAccessoryViewType:NNHItemAccessoryViewTypeRightLabel];
    NNHMyItem *accountItem = [NNHMyItem itemWithTitle:@"账号" itemAccessoryViewType:NNHItemAccessoryViewTypeRightLabel];
    NNHMyItem *uidItem = [NNHMyItem itemWithTitle:@"UID" itemAccessoryViewType:NNHItemAccessoryViewTypeRightLabel];
    NNHMyItem *areaItem = [NNHMyItem itemWithTitle:@"国家地区" itemAccessoryViewType:NNHItemAccessoryViewTypeRightLabel];
    NNHMyItem *idcardItem = [NNHMyItem itemWithTitle:@"身份证号" itemAccessoryViewType:NNHItemAccessoryViewTypeRightLabel];
    
    NNUserModel *userModel = [NNHProjectControlCenter sharedControlCenter].userControl_currentUserModel;
    realnameItem.rightTitle = userModel.realname;
    accountItem.rightTitle = userModel.username;
    uidItem.rightTitle = userModel.uid;
    areaItem.rightTitle = userModel.area;
    idcardItem.rightTitle = userModel.idnumber;
    
    self.nicknameItem.destVcClass = [NNNickNameViewController class];
    
    group.items = @[self.nicknameItem,realnameItem,accountItem,uidItem,areaItem,idcardItem];
}

@end
