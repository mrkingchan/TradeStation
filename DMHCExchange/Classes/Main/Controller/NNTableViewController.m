//
//  NNTableViewController.m
//  SuperWallet
//
//  Created by 牛牛 on 2018/3/20.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import "NNTableViewController.h"

@interface NNTableViewController ()

@end

@implementation NNTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 适配
    nn_adjustsScrollViewInsets_NO(self.tableView, self);
    self.tableView.backgroundColor = [UIConfigManager colorThemeColorForVCBackground];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
}
@end
