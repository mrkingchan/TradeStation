//
//  NNCoinSearchHistoryHeaderView.m
//  DMHCExchange
//
//  Created by 牛牛 on 2018/11/6.
//  Copyright © 2018年 超级钱包. All rights reserved.
//

#import "NNCoinSearchHistoryHeaderView.h"

@interface NNCoinSearchHistoryHeaderView ()

/** 历史搜索 */
@property (nonatomic, strong) UILabel *searchTitleLabel;
/** 清空历史button */
@property (nonatomic, strong) UIButton *removeAllButton;

@end

@implementation NNCoinSearchHistoryHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIConfigManager colorThemeWhite];
        [self setupChildView];
    }
    return self;
}

- (void)setupChildView
{
    [self.contentView addSubview:self.searchTitleLabel];
    [self.contentView addSubview:self.removeAllButton];
    [self.searchTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(NNHMargin_15);
    }];
    [self.removeAllButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.width.equalTo(@44);
    }];
    
    UIView *lineView = [UIView lineView];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.equalTo(@(NNHLineH));
    }];
}

- (void)removeAllbuttonAction
{
    if (self.removeAllOperationBlock) {
        self.removeAllOperationBlock();
    }
}

- (UILabel *)searchTitleLabel
{
    if (_searchTitleLabel == nil) {
        _searchTitleLabel = [UILabel NNHWithTitle:@"历史搜索" titleColor:[UIConfigManager colorThemeDark] font:[UIFont boldSystemFontOfSize:14]];
    }
    return _searchTitleLabel;
}

- (UIButton *)removeAllButton
{
    if (_removeAllButton == nil) {
        _removeAllButton = [UIButton NNHBtnImage:@"ic_search_delete" target:self action:@selector(removeAllbuttonAction)];
        [_removeAllButton addTarget:self action:@selector(removeAllbuttonAction) forControlEvents:UIControlEventTouchUpInside];
        _removeAllButton.adjustsImageWhenHighlighted = NO;
    }
    return _removeAllButton;
}

@end
