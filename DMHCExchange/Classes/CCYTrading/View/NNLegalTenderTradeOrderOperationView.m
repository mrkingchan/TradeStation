//
//  NNLegalTenderTradeOrderBottomOperationView.m
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/31.
//  Copyright © 2018 超级钱包. All rights reserved.
//

#import "NNLegalTenderTradeOrderOperationView.h"
#import "NNLegalTenderTradeOrderDetailModel.h"

@interface NNLegalTenderTradeOrderOperationView ()

/** 操作按钮 */
@property (nonatomic, strong) UIButton *operationButton;
/** 操作说明label */
@property (nonatomic, strong) UILabel *messageLabel;
/** 数据请求定时器 */
@property (nonatomic, strong) NSTimer *timer;
/** 总秒数 */
@property (nonatomic, assign) NSInteger totalSecond;
@end

@implementation NNLegalTenderTradeOrderOperationView

- (void)dealloc
{
    if (self.timer.isValid) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupChildView];
    }
    return self;
}

- (void)setupChildView
{
    [self addSubview:self.operationButton];
    [self.operationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self.mas_left).offset(NNHMargin_15);
        make.width.equalTo(@(SCREEN_WIDTH - 30));
    }];
    
    [self.operationButton addSubview:self.messageLabel];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.operationButton);
    }];
}

#pragma mark - Private Methods

- (void)operationButtonAction
{
    if (self.orderOperationBlock) {
        self.orderOperationBlock();
    }
}

- (void)setOrderModel:(NNLegalTenderTradeOrderDetailModel *)orderModel
{
    _orderModel = orderModel;
    self.messageLabel.text = orderModel.actstr;
    [self.messageLabel nnh_addAttringTextWithText:self.orderModel.actstr font:[UIFont systemFontOfSize:16] color:[UIConfigManager colorThemeWhite]];
    if (self.orderModel.last_time.length) {
        self.totalSecond = [orderModel.last_time integerValue];
        [self startTimer];
    }else {
        [self cancleCountDown];
    }
}

- (void)cancleCountDown
{
    if (self.timer.isValid) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

/** 开启定时器 */
- (void)startTimer
{
    if (self.totalSecond == 0) return;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDownAction) userInfo:nil repeats:YES];
    [self.timer fire];
}

- (void)countDownAction
{
    if (self.totalSecond == 0) {
        if (self.endCountdownBlock) {
            self.endCountdownBlock();
        }
        [self cancleCountDown];
        return;
    };
    
    self.totalSecond--;
    
    NSString *lastTime = [self getLastTimeWithTotalCount:self.totalSecond];
    
    self.messageLabel.text = [NSString stringWithFormat:@"%@  %@",self.orderModel.actstr,lastTime];
    [self.messageLabel nnh_addAttringTextWithText:self.orderModel.actstr font:[UIFont systemFontOfSize:16] color:[UIConfigManager colorThemeWhite]];
}

- (NSString *)getLastTimeWithTotalCount:(NSInteger)totalTime
{
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",totalTime/3600];

    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(totalTime%3600)/60];

    NSString *str_second = [NSString stringWithFormat:@"%02ld",totalTime%60];

    NSString *format_time = [NSString stringWithFormat:@"%@时%@分%@秒",str_hour,str_minute,str_second];
    
    return format_time;
}


#pragma mark - Lazy Loads

- (UIButton *)operationButton
{
    if (_operationButton == nil) {
        _operationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_operationButton setBackgroundColor:[UIConfigManager colorThemeRed] forState:UIControlStateNormal];
        [_operationButton setBackgroundColor:[UIConfigManager colorThemeDisable] forState:UIControlStateDisabled];
        [_operationButton addTarget:self action:@selector(operationButtonAction) forControlEvents:UIControlEventTouchUpInside];
        _operationButton.adjustsImageWhenHighlighted = NO;
    }
    return _operationButton;
}

- (UILabel *)messageLabel
{
    if (_messageLabel == nil) {
        _messageLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorThemeWhite] font:[UIConfigManager fontThemeTextDefault]];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        self.messageLabel.userInteractionEnabled = NO;
    }
    return _messageLabel;
}

@end



