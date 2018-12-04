//
//  NNLegalTenderTradeReleaseOrderResultViewController.m
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/29.
//  Copyright © 2018 超级钱包. All rights reserved.
//

#import "NNLegalTenderTradeReleaseOrderResultViewController.h"

@interface NNLegalTenderTradeReleaseOrderResultViewController ()

@end

@implementation NNLegalTenderTradeReleaseOrderResultViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"发布结果";
    self.view.backgroundColor = [UIConfigManager colorThemeColorForVCBackground];
    UIImage *backImage = [[UIImage imageNamed:@"ic_nav_back"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backImage style:UIBarButtonItemStyleDone target:self action:@selector(backAction)];
    [self setupChildView];
}

- (void)setupChildView
{
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIConfigManager colorThemeWhite];
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
    }];
    
    UIImageView *titleImageView = [[UIImageView alloc] init];
    titleImageView.image = [UIImage imageNamed:@"ic_audit_succeed"];
    [contentView addSubview:titleImageView];
    [titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(NNHNormalViewH);
        make.centerX.equalTo(contentView);
    }];
    
    UILabel *titleLabel = [UILabel NNHWithTitle:@"发布成功" titleColor:[UIConfigManager colorThemeBlack] font:[UIConfigManager fontThemeLargerBtnTitles]];
    [contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.top.equalTo(titleImageView.mas_bottom).offset(NNHMargin_20);
        make.bottom.equalTo(contentView).offset(-(NNHNormalViewH));
    }];
    
    // 交易按钮
    UIButton *scanButton = [UIButton NNHOperationBtnWithTitle:@"查看交易单" target:self action:@selector(backAction) operationButtonType:NNHOperationButtonTypeRed isAddCornerRadius:YES];
    [self.view addSubview:scanButton];
    [scanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_bottom).offset(NNHNormalViewH);
        make.left.equalTo(self.view).offset(NNHMargin_15);
        make.width.equalTo(@(SCREEN_WIDTH - 30));
        make.height.equalTo(@44);
    }];
}

#pragma mark - Network Methods

- (void)backAction
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectedReleaseOrderList" object:nil];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end

