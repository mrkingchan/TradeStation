//
//  NNLegalTenderTradeOrderReasonView.m
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/11/12.
//  Copyright © 2018 超级钱包. All rights reserved.
//

#import "NNLegalTenderTradeOrderReasonView.h"

@interface NNLegalTenderTradeOrderReasonView ()

/** 状态 */
@property (nonatomic, strong) UILabel *titleLabel;

/** 内容label */
@property (nonatomic, strong) UILabel *messageLabel;

@end

@implementation NNLegalTenderTradeOrderReasonView

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
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(NNHMargin_15);
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.messageLabel];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(130);
    }];
}

- (void)setMessage:(NSString *)message
{
    _message = message;
    self.messageLabel.text = message;
}

#pragma mark - Lazy Loads

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [UILabel NNHWithTitle:@"违规原因" titleColor:[UIConfigManager colorTextLightGray] font:[UIConfigManager fontThemeTextDefault]];
    }
    return _titleLabel;
}

- (UILabel *)messageLabel
{
    if (_messageLabel == nil) {
        _messageLabel = [UILabel NNHWithTitle:@"买家超时未付款" titleColor:[UIConfigManager colorThemeBlack] font:[UIConfigManager fontThemeTextDefault]];
    }
    return _messageLabel;
}

@end



