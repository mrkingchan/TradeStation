//
//  NNLegalTenderTradeListHeaderView.m
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/30.
//  Copyright © 2018 超级钱包. All rights reserved.
//

#import "NNLegalTenderTradeListHeaderView.h"

@interface NNLegalTenderTradeListHeaderView ()

/** 可用 */
@property (nonatomic, strong) UILabel *availableLabel;
/** 冻结 */
@property (nonatomic, strong) UILabel *freezeLabel;

@end

@implementation NNLegalTenderTradeListHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIConfigManager colorThemeWhite];
        [self setupChildView];
    }
    return self;
}

- (void)setupChildView
{
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor akext_colorWithHex:@"#f7f7f7"];
    contentView.layer.cornerRadius = 5;
    contentView.layer.masksToBounds = YES;
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-NNHMargin_10);
        make.left.equalTo(self).offset(NNHMargin_15);
        make.width.equalTo(@(SCREEN_WIDTH - 30));
        make.top.equalTo(self).offset(NNHMargin_10);
    }];
    
    [contentView addSubview:self.availableLabel];
    [contentView addSubview:self.freezeLabel];
    [self.availableLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(NNHMargin_10);
        make.centerY.equalTo(contentView);
    }];
    [self.freezeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.availableLabel.mas_right).offset(NNHMargin_10);
        make.centerY.equalTo(contentView);
    }];
}

- (void)setAvailableAmount:(NSString *)availableAmount
{
    _availableAmount = availableAmount;
    self.availableLabel.text = [NSString stringWithFormat:@"可用%@：%@",self.coinName,availableAmount];
}

- (void)setFreezeAmount:(NSString *)freezeAmount
{
    _freezeAmount = freezeAmount;
    self.freezeLabel.text = [NSString stringWithFormat:@"冻结%@：%@",self.coinName,freezeAmount];
}


- (UILabel *)availableLabel
{
    if (_availableLabel == nil) {
        _availableLabel = [UILabel NNHWithTitle:@"可用USDT：0" titleColor:[UIConfigManager colorThemeBlack] font:[UIConfigManager fontThemeTextTip]];
    }
    return _availableLabel;
}

- (UILabel *)freezeLabel
{
    if (_freezeLabel == nil) {
        _freezeLabel = [UILabel NNHWithTitle:@"冻结USDT：0" titleColor:[UIConfigManager colorThemeBlack] font:[UIConfigManager fontThemeTextTip]];
    }
    return _freezeLabel;
}

@end
