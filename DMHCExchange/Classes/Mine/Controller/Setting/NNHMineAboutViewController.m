//
//  NNHMineAboutViewController.m
//  SuperWallet
//
//  Created by 牛牛 on 2018/3/6.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import "NNHMineAboutViewController.h"
#import "NNAPIMineTool.h"

@interface NNHMineAboutViewController ()

@end

@implementation NNHMineAboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIConfigManager colorThemeColorForVCBackground];
    self.navigationItem.title = @"关于我们";
    
    [self requestAbountDataSource];
}

- (void)requestAbountDataSource
{
    NNHWeakSelf(self)
    NNAPIMineTool *tool = [[NNAPIMineTool alloc] initAbout];
    [tool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
        
        [weakself setupChildViewWithDataSource:responseDic[@"data"]];
        
    } failBlock:^(NNHRequestError *error) {
        
    } isCached:NO];
}

- (void)setupChildViewWithDataSource:(NSDictionary *)responseDic
{
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
    }];
    
    UIImageView *iconView = [[UIImageView alloc] initWithImage:ImageName(@"ic_logo_about")];
    [topView addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView).offset(40);
        make.centerX.equalTo(topView);
    }];
    
    UILabel *versionLabel = [UILabel NNHWithTitle:[NSString stringWithFormat:@"v%@",[NNHProjectControlCenter sharedControlCenter].currentVersion] titleColor:[UIConfigManager colorThemeDark] font:[UIFont boldSystemFontOfSize:14]];
    [topView addSubview:versionLabel];
    [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconView.mas_bottom).offset(20);
        make.centerX.equalTo(topView);
        make.bottom.equalTo(topView).offset(-40);
    }];
    
    UIView *telView = [self createViewWithLeftTitle:responseDic[@"contacts"][@"title"] rightTitle:responseDic[@"contacts"][@"content"]];
    [self.view addSubview:telView];
    [telView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom).offset(10);
        make.left.right.equalTo(topView);
        make.height.equalTo(@60);
    }];
    
    UIView *wechatView = [self createViewWithLeftTitle:responseDic[@"wechat"][@"title"] rightTitle:responseDic[@"wechat"][@"content"]];
    [self.view addSubview:wechatView];
    [wechatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(telView.mas_bottom).offset(0.5);
        make.left.right.equalTo(topView);
        make.height.equalTo(telView);
    }];
    
    UIView *emailView = [self createViewWithLeftTitle:responseDic[@"email"][@"title"] rightTitle:responseDic[@"email"][@"content"]];
    [self.view addSubview:emailView];
    [emailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wechatView.mas_bottom).offset(0.5);
        make.left.right.equalTo(topView);
        make.height.equalTo(telView);
    }];
    
    
    UILabel *promptLabel = [UILabel NNHWithTitle:responseDic[@"copyRight"] titleColor:[UIConfigManager colorTextLightGray] font:[UIConfigManager fontThemeTextTip]];
    [self.view addSubview:promptLabel];
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-40);
        make.centerX.equalTo(topView);
    }];
}

- (UIView *)createViewWithLeftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *leftLabel = [UILabel NNHWithTitle:leftTitle titleColor:[UIConfigManager colorThemeDark] font:[UIConfigManager fontThemeTextMain]];
    [view addSubview:leftLabel];
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.left.equalTo(view).offset(15);
    }];
    
    UILabel *rightLabel = [UILabel NNHWithTitle:rightTitle titleColor:[UIConfigManager colorTextLightGray] font:[UIConfigManager fontThemeTextDefault]];
    [view addSubview:rightLabel];
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.right.equalTo(view).offset(-15);
    }];
    
    return view;
}

@end
