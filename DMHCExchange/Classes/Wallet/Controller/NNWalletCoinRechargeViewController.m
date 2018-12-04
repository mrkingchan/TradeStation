//
//  NNWalletCoinRechargeViewController.m
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/24.
//  Copyright © 2018 超级钱包. All rights reserved.
//

#import "NNWalletCoinRechargeViewController.h"
#import "NNHApiWalletTool.h"
#import "NNWalletCoinRechargeModel.h"

@interface NNWalletCoinRechargeViewController ()

/** scrollView */
@property (nonatomic, strong) UIScrollView *scrollView;
/** 复制地址view */
@property (nonatomic, strong) UIView *bottomView;
/** messageView */
@property (nonatomic, strong) UIView *messageView;
/** 二维码图片 */
@property (nonatomic, strong) UIImageView *codeImageView;
/** 保存按钮 */
@property (nonatomic, strong) UIButton *saveButton;
/** 充值地址 */
@property (nonatomic, strong) UILabel *addressLabel;
/** 复制按钮 */
@property (nonatomic, strong) UIButton *copyButton;
/** 币种id */
@property (nonatomic, copy) NSString *coinID;
/** 币种名称 */
@property (nonatomic, copy) NSString *coinName;
/** 币种充值图片 */
@property (nonatomic, copy) NSString *coinImageUrl;
/** 标签 */
@property (nonatomic, strong) UILabel *memoLabel;
/** 底部信息 */
@property (nonatomic, strong) UILabel *messageLabel;
/** 充值模型 */
@property (nonatomic, strong) NNWalletCoinRechargeModel *rechargeModel;

@end

@implementation NNWalletCoinRechargeViewController

#pragma mark - Life Cycle Methods
- (void)dealloc
{
    
}

- (instancetype)initWithCoinID:(NSString *)coinID coinName:(NSString *)coinName

{
    if (self = [super init]) {
        _coinID = coinID;
        _coinName = coinName;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIConfigManager colorThemeColorForVCBackground];
    
    self.navigationItem.title = [NSString stringWithFormat:@"转入%@",self.coinName];
    
    [self setupChildView];
    
    [self requestCoinInfo];
}


#pragma mark - Initial Methods
- (void)setupChildView
{
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIConfigManager colorThemeWhite];
    backgroundView.layer.cornerRadius = NNHMargin_5;
    backgroundView.layer.masksToBounds = YES;
    [self.scrollView addSubview:backgroundView];
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView).offset(NNHMargin_15);
        make.width.equalTo(@(SCREEN_WIDTH - 30));
        make.height.equalTo(@(SCREEN_WIDTH + 10));
        make.top.equalTo(self.scrollView).offset(15);
    }];
    
    [backgroundView addSubview:self.codeImageView];
    [self.codeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backgroundView);
        make.width.equalTo(@(SCREEN_WIDTH - 165));
        make.height.equalTo(@(SCREEN_WIDTH - 165));
        make.centerY.equalTo(backgroundView).offset(-30);
    }];
    
    [backgroundView addSubview:self.saveButton];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backgroundView);
        make.width.equalTo(@(160));
        make.height.equalTo(@(30));
        make.top.equalTo(self.codeImageView.mas_bottom).offset(40);
    }];
    
    UIView *bottomView = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomView.backgroundColor = [UIConfigManager colorThemeWhite];
    bottomView.layer.cornerRadius = NNHMargin_5;
    bottomView.layer.masksToBounds = YES;
    [self.scrollView addSubview:bottomView];
    self.bottomView = bottomView;
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView).offset(NNHMargin_15);
        make.width.equalTo(@(SCREEN_WIDTH - 30));
        make.top.equalTo(backgroundView.mas_bottom).offset(20);
    }];
    
    [bottomView addSubview:self.addressLabel];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView).offset(NNHMargin_15);
        make.width.equalTo(@(SCREEN_WIDTH - 60));
        make.top.equalTo(bottomView).offset(NNHMargin_15);
    }];
    
    [bottomView addSubview:self.copyButton];
    [self.copyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backgroundView);
        make.width.equalTo(@(160));
        make.height.equalTo(@(30));
        make.top.equalTo(self.addressLabel.mas_bottom).offset(15);
        make.bottom.equalTo(bottomView).offset(-NNHMargin_20);
    }];
    
//    [self.view addSubview:self.messageView];
//    [self.messageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.
//    }];
}

- (void)addressAction
{
    if (self.rechargeModel.address.length == 0) return;
    
    [SVProgressHUD showMessage:@"复制成功!"];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.rechargeModel.address;
}

- (void)copyMemoAction
{
    if (self.rechargeModel.memo.length == 0) return;
    
    [SVProgressHUD showMessage:@"复制成功!"];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.rechargeModel.memo;
}

- (void)saveImageToMobile
{
    /**
     *  将图片保存到iPhone本地相册
     *  UIImage *image            图片对象
     *  id completionTarget       响应方法对象
     *  SEL completionSelector    方法
     *  void *contextInfo
     */
    UIImageWriteToSavedPhotosAlbum(self.codeImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error == nil) {
        
        [SVProgressHUD showMessage:@"已存入手机相册"];
    }else{
        [SVProgressHUD showMessage:@"保存失败"];
    }
}

#pragma mark - Network Methods

- (void)requestCoinInfo
{
    NNHWeakSelf(self)
    NNHApiWalletTool *walletTool = [[NNHApiWalletTool alloc] initWithCoinRechargeAddressDataWithCoinID:self.coinID];
    [walletTool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
        [weakself handleRechargeData:responseDic];
    } failBlock:^(NNHRequestError *error) {

    } isCached:NO];
}

- (void)handleRechargeData:(NSDictionary *)responseDic
{
    self.rechargeModel = [NNWalletCoinRechargeModel mj_objectWithKeyValues:responseDic[@"data"]];
    
    self.addressLabel.text = [NSString stringWithFormat:@"%@",self.rechargeModel.address];
    [self.codeImageView sd_setImageWithURL:[NSURL URLWithString:self.rechargeModel.codeUrl]];
    
    if ([self.rechargeModel.cointype isEqualToString:@"4"]) {
        [self.view addSubview:self.messageView];
        [self.messageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.top.equalTo(self.bottomView.mas_bottom).offset(NNHMargin_10);
            make.width.equalTo(@(SCREEN_WIDTH));
        }];
        
        self.memoLabel.text = self.rechargeModel.memo;
        self.messageLabel.text = self.rechargeModel.desc;
        [self.messageLabel nnh_addLineSpaceWithLineSpace:5];
    }
}

#pragma mark - Target Methods

#pragma mark - Public Methods

#pragma mark - Private Methods

#pragma mark - Lazy Loads
- (UIImageView *)codeImageView
{
    if (_codeImageView == nil) {
        _codeImageView = [[UIImageView alloc] init];
        _codeImageView.backgroundColor = [UIConfigManager colorThemeColorForVCBackground];
        
    }
    return _codeImageView;
}

- (UILabel *)addressLabel
{
    if (_addressLabel == nil) {
        _addressLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorThemeBlack] font:[UIConfigManager fontThemeTextDefault]];
        _addressLabel.numberOfLines = 2;
        _addressLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _addressLabel;
}

- (UIButton *)saveButton
{
    if (_saveButton == nil) {
        _saveButton = [UIButton NNHBtnTitle:@"保存二维码" titileFont:[UIConfigManager fontThemeTextDefault] backGround:[UIConfigManager colorThemeRed] titleColor:[UIConfigManager colorThemeWhite]];
        [_saveButton addTarget:self action:@selector(saveImageToMobile) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
}

- (UIButton *)copyButton
{
    if (_copyButton == nil) {
        _copyButton = [UIButton NNHBtnTitle:@"复制地址" titileFont:[UIConfigManager fontThemeTextDefault] backGround:[UIConfigManager colorThemeWhite] titleColor:[UIConfigManager colorThemeRed]];
        [_copyButton addTarget:self action:@selector(addressAction) forControlEvents:UIControlEventTouchUpInside];
        _copyButton.layer.borderColor = [UIConfigManager colorThemeRed].CGColor;
        _copyButton.layer.borderWidth = NNHLineH;
    }
    return _copyButton;
}

- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIView *)messageView
{
    if (_messageView == nil) {
        _messageView = [[UIView alloc] init];
        
        UILabel *memoLabel = [UILabel NNHWithTitle:@"memo" titleColor:[UIConfigManager colorThemeBlack] font:[UIConfigManager fontThemeTextDefault]];
        [_messageView addSubview:memoLabel];
        [memoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_messageView).offset(NNHMargin_15);
            make.top.equalTo(_messageView);
            make.height.equalTo(@(NNHNormalViewH));
        }];
        
        UIButton *copyButton = [UIButton NNHBtnTitle:@"复制" titileFont:[UIConfigManager fontThemeTextDefault] backGround:[UIColor clearColor] titleColor:[UIConfigManager colorThemeBlack]];
        [copyButton addTarget:self action:@selector(copyMemoAction) forControlEvents:UIControlEventTouchUpInside];
        [_messageView addSubview:copyButton];
        [copyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(memoLabel);
            make.height.equalTo(@(NNHNormalViewH));
            make.width.equalTo(@(60));
            make.right.equalTo(_messageView);
        }];

        [_messageView addSubview:self.memoLabel];
        [self.memoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(memoLabel);
            make.centerX.equalTo(_messageView);
        }];

        [_messageView addSubview:self.messageLabel];
        [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_messageView).offset(NNHMargin_15);
            make.top.equalTo(memoLabel.mas_bottom).offset(NNHMargin_20);
            make.width.equalTo(@(SCREEN_WIDTH - 30));
            make.bottom.equalTo(_messageView).offset(-NNHMargin_20);
        }];
    }
    return _messageView;
}

- (UILabel *)memoLabel
{
    if (_memoLabel == nil) {
        _memoLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorThemeRed] font:[UIConfigManager fontThemeTextDefault]];
    }
    return _memoLabel;
}


- (UILabel *)messageLabel
{
    if (_messageLabel == nil) {
        _messageLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorThemeRed] font:[UIConfigManager fontThemeTextTip]];
        _messageLabel.numberOfLines = 2;
    }
    return _messageLabel;
}



@end
