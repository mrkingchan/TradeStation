//
//  NNHAdView.m
//  NNHPlatform
//
//  Created by 牛牛 on 2017/9/20.
//  Copyright © 2017年 超级钱包. All rights reserved.
//

#import "NNAdView.h"

@interface NNAdView ()

/** 广告图片 */
@property (nonatomic, strong) UIImageView *adImageView;
/** 跳过按钮 */
@property (nonatomic, strong) UIButton *skipButton;

@end

@implementation NNAdView

- (instancetype)init
{
    if (self) {
        self = [super init];
        
        _timeout = 5.0;
        
        [self addSubview:self.adImageView];
        [self.adImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self.adImageView addSubview:self.skipButton];
        [self.skipButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.adImageView).offset(NNHMargin_20 *2);
            make.right.equalTo(self.adImageView).offset(-NNHMargin_15);
            make.size.mas_equalTo(CGSizeMake(50, 23));
        }];
    }
    
    return self;
}

- (void)show
{
    // 开启倒计时
    [self startCoundown];
    
    // 获得最上面的窗口
    UIWindow *window = [UIView currentWindow];
    
    // 添加自己到窗口上
    [window addSubview:self];
    
    // 设置尺寸
    self.frame = window.bounds;
}

// 点击广告界面调用
- (void)tap
{
    if (self.adJumpBlock) {
        
        self.adJumpBlock();
        
        // 移除view
        [self removeFromSuperview];
        
    }
    
}

// 点击跳过
- (void)clickSkip
{    
    [self removeAdView];
}

- (void)removeAdView
{
    NNHWeakSelf(self)
    [UIView animateWithDuration:.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakself.adImageView.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
        weakself.adImageView.alpha = 0;
    } completion:^(BOOL finished) {
        [weakself removeFromSuperview];
    }];
}

// GCD倒计时
- (void)startCoundown {
    
    NNHWeakSelf(self)
    _timeout += 1; //倒计时时间 + 1
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(weakself.timeout <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakself removeAdView];
                
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself.skipButton setTitle:[NSString stringWithFormat:@"跳过%zd",weakself.timeout] forState:UIControlStateNormal];
            });
            weakself.timeout--;
        }
    });
    
    dispatch_resume(_timer);
}

- (void)setFilePath:(NSString *)filePath
{
    _filePath = filePath;
    
    [self .adImageView sd_setImageWithURL:[NSURL URLWithString:filePath]];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *result = [super hitTest:point withEvent:event];
    CGPoint buttonPoint = [self.skipButton convertPoint:point fromView:self.adImageView];
    if ([self.skipButton pointInside:buttonPoint withEvent:event]) {
        return self.skipButton;
    }
    return result;
}

- (UIImageView *)adImageView
{
    if (_adImageView == nil) {
        _adImageView = [[UIImageView alloc] init];
        _adImageView.userInteractionEnabled = YES;
        _adImageView.contentMode = UIViewContentModeScaleAspectFill;
        _adImageView.clipsToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [_adImageView addGestureRecognizer:tap];
    }
    return _adImageView;
}

- (UIButton *)skipButton
{
    if (_skipButton == nil) {
        _skipButton = [UIButton NNHBtnTitle:@"" titileFont:[UIConfigManager fontThemeTextTip] backGround:[[UIColor whiteColor] colorWithAlphaComponent:0.8] titleColor:[UIColor whiteColor]];
        [_skipButton addTarget:self action:@selector(clickSkip) forControlEvents:UIControlEventTouchUpInside];
        _skipButton.layer.cornerRadius = 23*0.5;
        _skipButton.clipsToBounds = YES;
    }
    return _skipButton;
}

@end
