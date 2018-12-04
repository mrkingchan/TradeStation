//
//  NNLegalTenderTradeOrderAppealResultViewController.m
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/26.
//  Copyright © 2018 超级钱包. All rights reserved.
//

#import "NNLegalTenderTradeOrderAppealResultViewController.h"

@interface NNLegalTenderTradeOrderAppealResultViewController ()

@end

@implementation NNLegalTenderTradeOrderAppealResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIConfigManager colorThemeColorForVCBackground];
    self.navigationItem.title = @"提交成功";
    
    UIImage *backImage = [[UIImage imageNamed:@"ic_nav_back"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backImage style:UIBarButtonItemStyleDone target:self action:@selector(leftItemClick)];
    
    [self setupChildView];
}

- (void)leftItemClick
{
    NSArray *array = self.navigationController.viewControllers;
    UIViewController *viewController = array[array.count - 3];
    
    [self.navigationController popToViewController:viewController animated:YES];
}

- (void)setupChildView
{
    UIView *contentViw = [[UIView alloc] init];
    [self.view addSubview:contentViw];
    contentViw.backgroundColor = [UIConfigManager colorThemeWhite];
    [contentViw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
    }];
    
    UIImageView *statusImageView = [[UIImageView alloc] init];
    [contentViw addSubview:statusImageView];
    statusImageView.image = [UIImage imageNamed:@"ic_audit_succeed"];
    [statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentViw);
        make.top.equalTo(contentViw).offset(60);
    }];
    
    UILabel *titleLabel = [UILabel NNHWithTitle:@"提交成功" titleColor:[UIConfigManager colorThemeBlack] font:[UIConfigManager fontThemeTextDefault]];
    [contentViw addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentViw);
        make.top.equalTo(statusImageView.mas_bottom).offset(40);
    }];
    
    UILabel *messageLabel = [UILabel NNHWithTitle:@"我们会在24小时内与您联系，请耐心等候!" titleColor:[UIConfigManager colorThemeDarkGray] font:[UIConfigManager fontThemeTextDefault]];
    [contentViw addSubview:messageLabel];
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentViw);
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
        make.bottom.equalTo(contentViw).offset(-60);
    }];
}

@end
