//
//  NNHWalletTableHeaderView.m
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/24.
//  Copyright © 2018 超级钱包. All rights reserved.
//

#import "NNHWalletTableHeaderView.h"
#import "NNHCycleScrollView.h"
#import "UIButton+NNImagePosition.h"

@interface NNHWalletTableHeaderView ()

/** 文字按钮 */
@property (nonatomic, strong) UIButton *messageButton;
/** 资产文字 */
@property (nonatomic, strong) UILabel *totalAmountLabel;
/** 搜索框 */
@property (nonatomic, strong) UITextField *searchTextField;
/** 资产总额 */
@property (nonatomic, copy) NSString *amount;
/** 资产标题 */
@property (nonatomic, weak) UILabel *titleLabel;

@end

@implementation NNHWalletTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIConfigManager colorThemeWhite];
        [self setupcChildView];
    }
    return self;
}

- (void)setupcChildView
{
    UIImageView *bgImageView = [[UIImageView alloc] init];
    bgImageView.image = [UIImage imageNamed:@"wallet-bg"];
    [self addSubview:bgImageView];
    bgImageView.userInteractionEnabled = YES;
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(NNHMargin_15);
        make.bottom.equalTo(self).offset(-NNHNormalViewH - 15);
        make.left.equalTo(self).offset(NNHMargin_15);
        make.width.equalTo(@(SCREEN_WIDTH - 30));
    }];
    
    UILabel *titleLabel = [UILabel NNHWithTitle:@"总资产估值（元）" titleColor:[UIConfigManager colorThemeWhite] font:[UIConfigManager fontThemeTextTip]];
    [bgImageView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgImageView).offset(30);
        make.top.equalTo(bgImageView).offset(30);
    }];
    
    [bgImageView addSubview:self.messageButton];
    [self.messageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLabel);
        make.left.equalTo(titleLabel.mas_right).offset(NNHMargin_5);
    }];
    
    [bgImageView addSubview:self.totalAmountLabel];
    [self.totalAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgImageView).offset(30);
        make.top.equalTo(titleLabel.mas_bottom).offset(NNHMargin_10);
    }];
    
    [self addSubview:self.searchTextField];
    [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(40);
        make.width.equalTo(@(SCREEN_WIDTH - 50));
        make.top.equalTo(bgImageView.mas_bottom).offset(NNHMargin_15);
        make.bottom.equalTo(self);
    }];
    
    UIImageView *searchIcomImage = [[UIImageView alloc] init];
    searchIcomImage.contentMode = UIViewContentModeCenter;
    searchIcomImage.image = [UIImage imageNamed:@"ic_search_coin"];
    [self addSubview:searchIcomImage];
    [searchIcomImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.searchTextField.mas_left).offset(-NNHMargin_5);
        make.centerY.equalTo(self.searchTextField).offset(-3);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    [self addSubview:lineView];
    lineView.backgroundColor = [UIConfigManager colorThemeColorForVCBackground];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.bottom.equalTo(self);
        make.height.equalTo(@(NNHLineH));
    }];
}

- (void)configAmount:(NSString *)amount amountUnit:(NSString *)amountUnit
{
    self.amount = amount;
    self.totalAmountLabel.text = amount;
    
    if (self.messageButton.selected) {
        self.totalAmountLabel.text = @"******";
    }else {
        self.totalAmountLabel.text = self.amount;
    }
    
    self.titleLabel.text = [NSString stringWithFormat:@"总资产估值（%@）",amountUnit];
}

- (void)messageButtonAction:(UIButton *)button
{
    button.selected = !button.selected;
    if (button.selected) {
        self.totalAmountLabel.text = @"******";
    }else {
        self.totalAmountLabel.text = self.amount;
    }
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (self.searchTextBlock) {
        self.searchTextBlock(textField.text);
    }
}

#pragma mark - Lazy Loads

- (UILabel *)totalAmountLabel
{
    if (_totalAmountLabel == nil) {
        _totalAmountLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorThemeWhite] font:[UIFont boldSystemFontOfSize:30]];
    }
    return _totalAmountLabel;
}

- (UIButton *)messageButton
{
    if (_messageButton == nil) {
        _messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _messageButton.adjustsImageWhenHighlighted = NO;
        [_messageButton addTarget:self action:@selector(messageButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_messageButton setImage:[UIImage imageNamed:@"ic_visible"] forState:UIControlStateNormal];
        [_messageButton setImage:[UIImage imageNamed:@"ic_invisible"] forState:UIControlStateSelected];
    }
    return _messageButton;
}

- (UITextField *)searchTextField
{
    if (_searchTextField == nil) {
        _searchTextField = [[UITextField alloc] init];
        _searchTextField.placeholder = @"搜索币种";
        _searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchTextField.font = [UIConfigManager fontThemeTextDefault];
        [_searchTextField setValue:[UIConfigManager fontThemeTextTip] forKeyPath:@"_placeholderLabel.font"];
        [_searchTextField setValue:[UIConfigManager colorTextLightGray] forKeyPath:@"_placeholderLabel.textColor"];
        [_searchTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _searchTextField;
}

@end

