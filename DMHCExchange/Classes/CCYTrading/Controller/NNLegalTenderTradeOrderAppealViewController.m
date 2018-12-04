//
//  NNLegalTenderTradeOrderAppealViewController.m
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/26.
//  Copyright © 2018 超级钱包. All rights reserved.
//

#import "NNLegalTenderTradeOrderAppealViewController.h"
#import "NNLegalTenderTradeOrderAppealResultViewController.h"
#import "NNTextView.h"
#import "NNHUploadPictureView.h"
#import "NNUploadImageTool.h"
#import "NNImagePickerViewController.h"
#import "NNAPILegalTenderTool.h"
#import "NNHPictureBrowseView.h"

@interface NNLegalTenderTradeOrderAppealViewController () <UITextViewDelegate, NNHUploadPictureViewDelegate>
/** scrollView */
@property (nonatomic, strong) UIScrollView *scrollView;
/** 申诉内容 */
@property (nonatomic, strong) UIView *titleView;
/** 申诉凭证 */
@property (nonatomic, strong) UIView *contentView;
/** 客服回复内容 */
@property (nonatomic, strong) UIView *messageView;
/** 回复内容 */
@property (nonatomic, strong) UILabel *replyMessageLabel;
/** textView */
@property (nonatomic, strong) NNTextView *textView;
/** 上传图片控件 */
@property (nonatomic, strong) NNHUploadPictureView *pictureView;
/** 图片浏览 */
@property (nonatomic, strong) NNHPictureBrowseView *pictureBrowseView;
/** 提交按钮 */
@property (nonatomic, strong) UIButton *submitButton;
/** 订单id */
@property (nonatomic, copy) NSString *orderID;

@end

@implementation NNLegalTenderTradeOrderAppealViewController

#pragma mark -
#pragma mark ---------Life Cycle
- (void)dealloc
{
    NNHLog(@"-------%s------",__func__);
}
- (instancetype)initWithOrderID:(NSString *)orderID
{
    self = [super init];
    if (self) {
        _orderID = orderID;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"我要申诉";
    self.view.backgroundColor = [UIConfigManager colorThemeColorForVCBackground];
    
    [self setupChildView];
    
    [self requestAppeaLContentData];
}

- (void)setupChildView
{
    [self.view addSubview:self.submitButton];
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-(NNHBottomSafeHeight) - 10);
        make.left.equalTo(self.view).offset(NNHMargin_15);
        make.height.equalTo(@44);
        make.width.equalTo(@(SCREEN_WIDTH - 30));
    }];
    
    [self.view addSubview:self.scrollView];
    
    [self.view addSubview:self.titleView];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(NNHMargin_10);
        make.left.equalTo(self.titleView);
        make.width.equalTo(@(SCREEN_WIDTH));
    }];
}

#pragma mark -
#pragma mark ---------UserAction
- (void)submitAction
{
    if (self.textView.text.length == 0) {
        [SVProgressHUD showMessage:@"申诉内容不能为空"];
        return;
    }
    
    NNHWeakSelf(self)
    if (self.pictureView.pictureArray.count) {
        [SVProgressHUD showWithStatus:@"提交中"];
        [NNUploadImageTool uploadImageArray:self.pictureView.pictureArray completeArray:^(NSArray *imageArray) {
            
            NSString *string = [imageArray componentsJoinedByString:@","];
            
            [weakself uplaodAppealDataWithImageString:string];
        }];
    }else {
        [self uplaodAppealDataWithImageString:@""];
    }
}

#pragma mark - Network Methods
/** 请求申诉内容 */
- (void)requestAppeaLContentData
{
    NNHWeakSelf(self)
    NNAPILegalTenderTool *networkTool = [[NNAPILegalTenderTool alloc] initOrderAppleContentDataWithOrderID:self.orderID];
    [networkTool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
        [weakself hanldeAppealData:responseDic];
    } failBlock:^(NNHRequestError *error) {
        
    } isCached:NO];
}

- (void)hanldeAppealData:(NSDictionary *)responseDic
{
    NSString *content = responseDic[@"data"][@"content"];
    NSArray *imgArray = responseDic[@"data"][@"img"];
    NSString *replyContent = responseDic[@"data"][@"replycontent"];
    NSString *replytime = responseDic[@"data"][@"replytime"];
    
    if (content.length) {
        //上传过申诉
        self.submitButton.hidden = YES;
        self.textView.userInteractionEnabled = NO;
        self.textView.text = content;
        [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        if (imgArray.count) {
            
            [self.scrollView addSubview:self.contentView];
            [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.titleView.mas_bottom).offset(NNHMargin_10);
                make.left.equalTo(self.scrollView);
                make.width.equalTo(@(SCREEN_WIDTH));
            }];

            NSInteger totalPageNum = (imgArray.count  +  2) / 3;
            CGFloat pictureHeight = (SCREEN_WIDTH - 50) / 3 * totalPageNum;

            [self.contentView addSubview:self.pictureBrowseView];
            self.pictureBrowseView.imageUrlArray = imgArray;
            [self.pictureBrowseView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView).offset(NNHNormalViewH);
                make.left.equalTo(self.contentView);
                make.width.equalTo(@(SCREEN_WIDTH));
                make.height.mas_equalTo(@(pictureHeight));
                make.bottom.equalTo(self.contentView).offset(-NNHMargin_15);
            }];

            if (replyContent.length) {
                [self.scrollView addSubview:self.messageView];
                [self.messageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.scrollView);
                    make.top.equalTo(self.contentView.mas_bottom).offset(NNHMargin_10);
                    make.width.equalTo(@(SCREEN_WIDTH));
                    make.bottom.equalTo(self.scrollView).offset(-NNHMargin_20);
                }];
            }
        }else {
            if (replyContent.length) {
                
                self.replyMessageLabel.text = replyContent;
                [self.replyMessageLabel nnh_addLineSpaceWithLineSpace:5];
                
                [self.scrollView addSubview:self.messageView];
                [self.messageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.scrollView);
                    make.top.equalTo(self.titleView.mas_bottom).offset(NNHMargin_10);
                    make.width.equalTo(@(SCREEN_WIDTH));
                    make.bottom.equalTo(self.scrollView).offset(-NNHMargin_20);
                }];
            }
        }
        
        self.replyMessageLabel.text = [NSString stringWithFormat:@"%@\n%@",replyContent,replytime];
        [self.replyMessageLabel nnh_addLineSpaceWithLineSpace:5];
        
    }else {
        //未上传申诉
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.view);
            make.bottom.equalTo(self.submitButton.mas_top).offset(-NNHMargin_10);
        }];
        self.submitButton.hidden = NO;
        self.textView.userInteractionEnabled = YES;

        [self.scrollView addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleView.mas_bottom).offset(NNHMargin_10);
            make.left.equalTo(self.scrollView);
            make.width.equalTo(@(SCREEN_WIDTH));
        }];

        CGFloat pictureHeight = (SCREEN_WIDTH - 50) / 3 * 2 + 10;
        [self.contentView addSubview:self.pictureView];
        [self.pictureView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(NNHNormalViewH);
            make.left.equalTo(_contentView);
            make.width.equalTo(@(SCREEN_WIDTH));
            make.height.mas_equalTo(@(pictureHeight));
            make.bottom.equalTo(_contentView).offset(-NNHMargin_15);
        }];
    }
}

/** 上传图片 */
- (void)uplaodAppealDataWithImageString:(NSString *)imageString
{
    NNHWeakSelf(self)
    NNAPILegalTenderTool *networkTool = [[NNAPILegalTenderTool alloc] initSubmitAppealDataWithTradeID:self.orderID content:self.textView.text imgs:imageString];
    [networkTool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
        [SVProgressHUD dismiss];
        
        if (weakself.reloadDataBlock) {
            weakself.reloadDataBlock();
        }
        
        NNLegalTenderTradeOrderAppealResultViewController *resultVc = [[NNLegalTenderTradeOrderAppealResultViewController alloc] init];
        [weakself.navigationController pushViewController:resultVc animated:YES];
        
    } failBlock:^(NNHRequestError *error) {
        
    } isCached:NO];
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.submitButton.enabled = textView.hasText;
}

#pragma mark -
#pragma mark ---------NNHUploadPictureViewDelegate
/** 点击了最后一张图片 */
- (void)didSelectedLastImageAtPictureView:(NNHUploadPictureView *)pictureView
{
    NNImagePickerViewController *imagePickerVc = [[NNImagePickerViewController alloc] initWithMaxImagesCount:5 delegate:nil];
    // 你可以通过block或者代理，来得到用户选择的照片.
    imagePickerVc.naviBgColor = [UIColor blackColor];
    imagePickerVc.naviTitleColor = [UIConfigManager colorNaviBarTitle];
    imagePickerVc.barItemTextColor = [UIConfigManager colorNaviBarTitle];
    imagePickerVc.naviTitleFont = [UIConfigManager fontNaviTitle];
    imagePickerVc.barItemTextFont = [UIConfigManager fontNaviBarButtonTitle];
    NNHWeakSelf(self)
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos,NSArray *assets,BOOL isSelectOriginalPhoto) {
        [weakself.pictureView addPictureFromArray:photos];
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark -
#pragma mark ---------Getters & Setters

- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIView *)titleView
{
    if (_titleView == nil) {
        _titleView = [[UIView alloc] init];
        _titleView.backgroundColor = [UIConfigManager colorThemeWhite];
        
        UILabel *titleLabel = [UILabel NNHWithTitle:@"申诉内容" titleColor:[UIConfigManager colorThemeBlack] font:[UIConfigManager fontThemeTextMain]];
        [_titleView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleView).offset(NNHMargin_15);
            make.top.equalTo(_titleView);
            make.height.equalTo(@(NNHNormalViewH));
        }];
        
        [_titleView addSubview:self.textView];
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleView).offset(13);
            make.top.equalTo(titleLabel.mas_bottom);
            make.height.equalTo(@80);
            make.width.equalTo(@(SCREEN_WIDTH - 26));
            make.bottom.equalTo(_titleView).offset(-NNHMargin_10);
        }];
    }
    return _titleView;
}

- (NNTextView *)textView
{
    if (_textView == nil) {
        _textView = [[NNTextView alloc] init];
        _textView.delegate = self;
        _textView.placeholder = @"最多输入100字";
        _textView.placeholderColor = [UIConfigManager colorTextLightGray];
    }
    return _textView;
}

- (UIView *)contentView
{
    if (_contentView == nil) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIConfigManager colorThemeWhite];
        
        UILabel *titleLabel = [UILabel NNHWithTitle:@"申诉凭证（最多5张）" titleColor:[UIConfigManager colorThemeBlack] font:[UIConfigManager fontThemeTextMain]];
        [_contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_contentView).offset(NNHMargin_15);
            make.top.equalTo(_contentView);
            make.height.equalTo(@(NNHNormalViewH));
        }];
    }
    return _contentView;
}

- (NNHUploadPictureView *)pictureView
{
    if (_pictureView == nil) {
        _pictureView = [[NNHUploadPictureView alloc] initWithMaxImageCount:5];
        _pictureView.delegate = self;
    }
    return _pictureView;
}

- (NNHPictureBrowseView *)pictureBrowseView
{
    if (_pictureBrowseView == nil) {
        _pictureBrowseView = [[NNHPictureBrowseView alloc] init];
    }
    return _pictureBrowseView;
}

- (UIButton *)submitButton
{
    if (_submitButton == nil) {
        _submitButton = [UIButton NNHOperationBtnWithTitle:@"提交" target:self action:@selector(submitAction) operationButtonType:NNHOperationButtonTypeRed isAddCornerRadius:YES];
        _submitButton.nn_acceptEventInterval = 1;
    }
    return _submitButton;
}

- (UIView *)messageView
{
    if (_messageView == nil) {
        _messageView = [[UIView alloc] init];
        _messageView.backgroundColor = [UIConfigManager colorThemeWhite];
        UILabel *titleLabel = [UILabel NNHWithTitle:@"申诉已处理" titleColor:[UIConfigManager colorThemeBlack] font:[UIConfigManager fontThemeTextMain]];
        [_messageView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_messageView).offset(NNHMargin_15);
            make.top.equalTo(_messageView);
            make.height.equalTo(@(NNHNormalViewH));
        }];
        
        UIView *contentView = [[UIView alloc] init];
        contentView.backgroundColor = [UIConfigManager colorThemeColorForVCBackground];
        [_messageView addSubview:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_messageView).offset(NNHNormalViewH);
            make.left.equalTo(_messageView).offset(NNHMargin_15);
            make.width.equalTo(@(SCREEN_WIDTH - 30));
            make.bottom.equalTo(_messageView).offset(-NNHMargin_10);
        }];
        
        [contentView addSubview:self.replyMessageLabel];
        [self.replyMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentView).offset(NNHMargin_10);
            make.left.equalTo(contentView).offset(NNHMargin_10);
            make.right.equalTo(contentView).offset(-NNHMargin_10);
            make.bottom.equalTo(contentView).offset(-NNHMargin_5);
        }];
    }
    return _messageView;
}

- (UILabel *)replyMessageLabel
{
    if (_replyMessageLabel == nil) {
        _replyMessageLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorThemeBlack] font:[UIConfigManager fontThemeTextDefault]];
        _replyMessageLabel.backgroundColor = [UIConfigManager colorThemeColorForVCBackground];
        _replyMessageLabel.numberOfLines = 0;
    }
    return _replyMessageLabel;
}

@end
