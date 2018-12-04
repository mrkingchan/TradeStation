//
//  NNMineQrCodeViewController.m
//  SuperWallet
//
//  Created by 牛牛 on 2018/3/20.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import "NNMineQrCodeViewController.h"
#import "NNMineShareRewardViewController.h"
#import "NNAPIMineTool.h"

@interface NNMineQrCodeViewController ()

/** 平台号 */
@property (nonatomic, strong) UILabel *nnhNumberLabel;
/** 二维码 */
@property (nonatomic, strong) UIImageView *qrCodeView;

@end

@implementation NNMineQrCodeViewController

#pragma mark -
#pragma mark ---------Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"推荐返佣";
    self.view.backgroundColor = [UIConfigManager colorThemeColorForVCBackground];
    
    [self requestDataSource];
}

- (void)requestDataSource
{
    NNAPIMineTool *tool = [[NNAPIMineTool alloc] initMyQrCode];
    NNHWeakSelf(self)
    [tool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
        
        [weakself setupChildViewWithResponseDic:responseDic[@"data"]];

    } failBlock:^(NNHRequestError *error) {
        
    } isCached:NO];
}

- (void)setupChildViewWithResponseDic:(NSDictionary *)responseDic
{
    // 内容背景
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    NNHViewRadius(contentView, 5.0)
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(40);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
    }];

    UILabel *nickLabel = [UILabel NNHWithTitle:[NNHProjectControlCenter sharedControlCenter].userControl_currentUserModel.nickname titleColor:[UIConfigManager colorThemeDark] font:[UIConfigManager fontThemeTextImportant]];
    [contentView addSubview:nickLabel];
    [nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(40);
        make.centerX.equalTo(contentView);
    }];

    NSString *codeStr = responseDic[@"content"];
    NSString *codeContentStr = [NSString stringWithFormat:@"邀请码 %@",codeStr];
    UILabel *codeLabel = [UILabel NNHWithTitle:codeContentStr titleColor:[UIConfigManager colorThemeDark] font:[UIConfigManager fontThemeTextImportant]];
    if (codeStr) {
        codeLabel.attributedText = [NSMutableAttributedString nn_changeFontAndColor:[UIConfigManager fontThemeTextImportant] Color:[UIConfigManager colorThemeRed] TotalString:codeContentStr SubStringArray:@[codeStr]];
    }
    [contentView addSubview:codeLabel];
    [codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.top.equalTo(nickLabel.mas_bottom).offset(15);
    }];
    
    // 二维码
    [self.qrCodeView sd_setImageWithURL:[NSURL URLWithString:responseDic[@"url"]]];
    [contentView addSubview:self.qrCodeView];
    [self.qrCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(codeLabel.mas_bottom).offset(25);
        make.centerX.equalTo(contentView);
        make.size.mas_equalTo(CGSizeMake(200, 200));
    }];
    
    // 保存
    UIButton *saveButton = [UIButton NNHOperationBtnWithTitle:@"保存图片" target:self action:@selector(savePhontAction) operationButtonType:NNHOperationButtonTypeRed isAddCornerRadius:YES];
    [contentView addSubview:saveButton];
    [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.qrCodeView.mas_bottom).offset(30);
        make.left.equalTo(contentView).offset(50);
        make.right.equalTo(contentView).offset(-50);
        make.height.equalTo(@44);
    }];
    
    // 返佣记录
    UIButton *recordButton = [UIButton NNHOperationBtnWithTitle:@"返佣记录" target:self action:@selector(recordAction) operationButtonType:NNHOperationButtonTypeRed isAddCornerRadius:YES];
    [contentView addSubview:recordButton];
    [recordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(saveButton.mas_bottom).offset(15);
        make.left.right.equalTo(saveButton);
        make.height.equalTo(saveButton);
        make.bottom.equalTo(contentView).offset(-40);
    }];
}

#pragma mark -
#pragma mark ---------UserAction
- (void)savePhontAction
{
    UIImage *image = self.qrCodeView.image;
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error) {
        [SVProgressHUD showMessage:@"保存成功"];
    }
}

- (void)recordAction
{
    NNMineShareRewardViewController *vc = [[NNMineShareRewardViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
#pragma mark ---------Getters & Setters
- (UIImageView *)qrCodeView
{
    if (_qrCodeView == nil) {
        _qrCodeView = [[UIImageView alloc] init];
    }
    return _qrCodeView;
}

@end
