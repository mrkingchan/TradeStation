//
//  NNHShovelRecordTableHeaderView.m
//  SuperWallet
//
//  Created by 来旭磊 on 2018/3/20.
//  Copyright © 2018年 超级钱包. All rights reserved.
//

#import "NNHShovelRecordTableHeaderView.h"

@interface NNHShovelRecordTableHeaderView ()

/** label */
@property (nonatomic, strong) UILabel *messageLabel;

@end

@implementation NNHShovelRecordTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor akext_colorWithHex:@"f7f7f7"];
        [self setupChildView];
    }
    return self;
}

- (void)setupChildView
{
    [self addSubview:self.messageLabel];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(NNHMargin_10);
    }];
    
}

- (void)setTotalAmount:(NSString *)totalAmount
{
    _totalAmount = totalAmount;
    self.messageLabel.text = [NSString stringWithFormat:@"累计挖宝奖励：%@ HCoin",totalAmount];
    [self.messageLabel nnh_addAttringTextWithText:totalAmount font:[UIConfigManager fontThemeLargerBtnTitles] color:[UIColor redColor]];
}

#pragma mark - Lazy Loads

- (UILabel *)messageLabel
{
    if (_messageLabel == nil) {
        _messageLabel = [UILabel NNHWithTitle:@"累计挖宝奖励：" titleColor:[UIConfigManager colorThemeBlack] font:[UIConfigManager fontThemeLargerBtnTitles]];
    }
    return _messageLabel;
}

@end
