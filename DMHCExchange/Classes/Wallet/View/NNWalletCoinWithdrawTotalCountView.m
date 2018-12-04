//
//  NNWalletCoinWithdrawTotalCountView.m
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/24.
//  Copyright © 2018 超级钱包. All rights reserved.
//

#import "NNWalletCoinWithdrawTotalCountView.h"

@interface NNWalletCoinWithdrawTotalCountView ()

/** 可提数量 */
@property (nonatomic, strong) UILabel *totalCountLabel;
/** 标题 */
@property (nonatomic, weak) UILabel *titleLabel;

@end

@implementation NNWalletCoinWithdrawTotalCountView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIConfigManager colorThemeWhite];
        [self setupChildView];
    }
    return self;
}

- (void)setupChildView
{
    UILabel *titleLabel = [UILabel NNHWithTitle:@"可用" titleColor:[UIConfigManager colorThemeBlack] font:[UIConfigManager fontThemeTextDefault]];
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(NNHMargin_15);
        make.top.equalTo(self);
        make.height.equalTo(@(NNHNormalViewH));
    }];
    
    [self addSubview:self.totalCountLabel];
    [self.totalCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(titleLabel.mas_bottom);
    }];
}

- (void)configCoinName:(NSString *)coinName count:(NSString *)count
{
    self.titleLabel.text = [NSString stringWithFormat:@"可用%@",coinName];
    if (count.length) {
        self.totalCountLabel.text = count;
    }else {
        self.totalCountLabel.text = @"0";
    }
}


#pragma mark - Lazy Loads

- (UILabel *)totalCountLabel
{
    if (_totalCountLabel == nil) {
        _totalCountLabel = [UILabel NNHWithTitle:@"0.00" titleColor:[UIConfigManager colorThemeRed] font:[UIFont systemFontOfSize:30]];
    }
    return _totalCountLabel;
}

@end
