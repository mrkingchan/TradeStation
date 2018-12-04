//
//  NNCountDownButton.m
//  SuperWallet
//
//  Created by 牛牛 on 2018/3/16.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import "NNCountDownButton.h"
#import "NNSlideCapchaView.h"

@interface NNCountDownButton ()

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) UILabel *lbTitle;

/** 开始计时前显示title **/
@property (nonatomic, copy) NSString *titleBeforeCounting;
/** 第一次计时结束之后显示title **/
@property (nonatomic, copy) NSString *titleAfterCounting;
/** 数字之后跟着的titles **/
@property (nonatomic, copy) NSString *titleCoutingExceptSecs;

@property (nonatomic, copy) void(^blockClicked)(NNCountDownButton *countBtn);

@property (nonatomic, strong) UIActivityIndicatorView *loadingView;

@end

@implementation NNCountDownButton
{
    BOOL _isCounting;
}

- (void)dealloc
{
    NNHLog(@"countDownButtonRelease");
}

- (instancetype)initWithTotalTime:(NSUInteger)totalTime titleBefre:(NSString *)titleBefore titleConting:(NSString *)titleCounting titleAfterCounting:(NSString *)titleAfter clickAction:(void(^)(NNCountDownButton *countBtn))clickAction
{
    if (self = [super init]) {
        
        self.adjustsImageWhenHighlighted = NO;
        _titleBeforeCounting = titleBefore;
        _titleCoutingExceptSecs = titleCounting;
        _titleAfterCounting = titleAfter;
        _totalSec = totalTime;
        _blockClicked = clickAction;
        
        // 背景色
        [self setBackgroundColor:[UIConfigManager colorThemeRed] forState:UIControlStateNormal];
        // 不可点击状态
        [self setBackgroundColor:[UIConfigManager colorThemeRed] forState:UIControlStateDisabled];
        
        // 点击获取验证码后的文字颜色
        _lbCountingColor = [UIConfigManager colorThemeWhite];
        // 文字颜色
        _lbNormalColor = [UIConfigManager colorThemeWhite];
        
        [self buildUI];
    }
    return self;
}

- (void)setBgNormalColor:(UIColor *)bgNormalColor
{
    _bgNormalColor = bgNormalColor;
    [self setBackgroundColor:bgNormalColor forState:UIControlStateNormal];
}

- (void)setBgCountingColor:(UIColor *)bgCountingColor
{
    _bgCountingColor = bgCountingColor;
    [self setBackgroundColor:bgCountingColor forState:UIControlStateDisabled];
}

- (void)setLbNormalColor:(UIColor *)lbNormalColor
{
    _lbNormalColor = lbNormalColor;
    self.lbTitle.textColor = lbNormalColor;
}

- (void)buildUI
{
    UILabel *lbtitle = [[UILabel alloc] init];
    lbtitle.backgroundColor = [UIColor clearColor];
    lbtitle.textAlignment = NSTextAlignmentCenter;
    lbtitle.textColor = _lbNormalColor;
    lbtitle.font = [UIConfigManager fontThemeTextTip];
    [self addSubview:lbtitle];
    self.lbTitle = lbtitle;
    
    _curSec = _totalSec;
    self.lbTitle.text = _titleBeforeCounting;
    
    [lbtitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self addTarget:self action:@selector(actionClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)actionClicked:(NNCountDownButton *)sender
{
    // 正在获取验证码
    if (_isCounting) return;
    
    // 通知调用者点击了按钮 可以处理其他事情
    if (self.clickButtonBlock) {
        self.clickButtonBlock();
    }
    
    if (self.isSlideCapchaView) {
        NNSlideCapchaView *slideCapchaView = [[NNSlideCapchaView alloc] init];
        NNHWeakSelf(self)
        NNHWeakSelf(slideCapchaView)
        slideCapchaView.indentifyCompletion = ^(BOOL success) {
            if (success) {
                [weakslideCapchaView removeFromSuperview];
                [weakself startLoadingView];
            }else {
                [weakslideCapchaView.captchaView reset];
            }
        };
        [slideCapchaView showSlideCapchaView];
    }else{
        [self startLoadingView];
    }
}

- (void)startLoadingView
{
    if (_loadingView == nil) {
        [self addSubview:self.loadingView];
        [_loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.equalTo(@30);
            make.height.equalTo(@30);
        }];
    }
    [self.loadingView startAnimating];
    
    self.enabled = NO;
    self.lbTitle.hidden = YES;
    
    if (self.blockClicked) {
        self.blockClicked(self);
    }
}

- (void)startCounting
{
    if (_isCounting) return;
    
    if (_loadingView) {
        [self.loadingView stopAnimating];
    }
    
    _lbTitle.hidden = NO;
    _isCounting = YES;
    
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(actionOnTimer) userInfo:nil repeats:YES];
    [[NSRunLoop  currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    [_timer fire];
    
    self.backgroundColor = self.bgCountingColor;
    self.lbTitle.textColor = self.lbCountingColor;
    
}

- (void)actionOnTimer
{
    _curSec--;
    if (_curSec == 0) {
        [self resetButton];
        return;
    }
    
    self.lbTitle.text = [NSString stringWithFormat:@"%lu秒",(unsigned long)_curSec];
}

- (void)resetButton
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    
    if (_loadingView) {
        [_loadingView stopAnimating];
        [_loadingView removeFromSuperview];
        _loadingView = nil;
    }
    
    _isCounting = NO;
    self.enabled = YES;
    _lbTitle.hidden = NO;
    _curSec = _totalSec;
    
    self.lbTitle.text = _titleAfterCounting;
    self.lbTitle.textColor = self.lbNormalColor;
    self.backgroundColor = self.bgNormalColor;
}

- (UIActivityIndicatorView *)loadingView
{
    if (_loadingView == nil) {
        _loadingView = [[UIActivityIndicatorView alloc] init];
        _loadingView.color = [UIColor whiteColor];
        if (_activityColor) {
            _loadingView.color = _activityColor;
        }
        _loadingView.hidesWhenStopped = YES;
    }
    return _loadingView;
}

@end
