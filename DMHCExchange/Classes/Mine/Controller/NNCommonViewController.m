//
//  NNHCommonViewController.m
//  NNHPlatform
//
//  Created by 牛牛 on 2017/2/28.
//  Copyright © 2017年 Smile intl. All rights reserved.
//

#import "NNCommonViewController.h"
#import "NNHCommonCell.h"

@interface NNCommonViewController ()

@property (nonatomic, strong) UIView *headerView;

@end

static CGFloat const headerFooterViewH = 34;
@implementation NNCommonViewController

#pragma mark -
#pragma mark ---------Life Cycle
// 重写init方法,屏蔽tableview的样式
- (instancetype)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorColor = [UIConfigManager colorThemeSeperatorLightGray];
    self.tableView.rowHeight = 44;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerClass:[NNHCommonCell class] forCellReuseIdentifier:NSStringFromClass([NNHCommonCell class])];
}

#pragma mark -
#pragma mark ---------UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NNHMyGroup *group = self.groups[section];
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NNHCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NNHCommonCell class])];
    NNHMyGroup *group = self.groups[indexPath.section];
    cell.myItem = group.items[indexPath.row];
    return cell;
}

#pragma mark -
#pragma mark ---------UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NNHMyGroup *group = self.groups[indexPath.section];
    NNHMyItem *item = group.items[indexPath.row];
    
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NNHMyGroup *group = self.groups[section];
    if (group.header) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, headerFooterViewH)];
        headerView.backgroundColor = [UIConfigManager colorThemeColorForVCBackground];
        UILabel *promptLabel = [UILabel NNHWithTitle:group.header titleColor:[UIConfigManager colorTextLightGray] font:[UIConfigManager fontThemeTextTip]];
        [headerView addSubview:promptLabel];
        [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(headerView).offset(-5);
            make.left.equalTo(headerView).offset(15);
        }];
        
        return headerView;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    NNHMyGroup *group = self.groups[section];
    if (group.footer) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, headerFooterViewH)];
        footerView.backgroundColor = [UIConfigManager colorThemeColorForVCBackground];
        UILabel *promptLabel = [UILabel NNHWithTitle:group.footer titleColor:[UIConfigManager colorTextLightGray] font:[UIConfigManager fontThemeTextTip]];
        promptLabel.numberOfLines = 2;
        [footerView addSubview:promptLabel];
        [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(footerView).offset(5);
            make.left.equalTo(footerView).offset(15);
            make.right.equalTo(footerView).offset(-15);
        }];
        
        return footerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NNHMyGroup *group = self.groups[section];
    return group.header ? headerFooterViewH : NNHMargin_10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    NNHMyGroup *group = self.groups[section];
    return group.footer ? headerFooterViewH : NNHLineH;
}

#pragma mark -
#pragma mark ---------Getters & Setters
- (NSMutableArray *)groups
{
    if (_groups == nil) {
        _groups = [NSMutableArray array];
    }
    return _groups;
}

@end
