//
//  NNSlideCapchaView.m
//  DMHCExchange
//
//  Created by 牛牛 on 2018/11/5.
//  Copyright © 2018年 超级钱包. All rights reserved.
//

#import "NNSlideCapchaView.h"
#import "NNSlider.h"

@interface NNSlideCapchaView ()<CAAnimationDelegate>

/// 滑块
@property (nonatomic ,strong) NNSlider *slider;
///提示
@property (nonatomic ,strong) UILabel *promptLabel;

@end

@implementation NNSlideCapchaView

- (instancetype)init
{
    if (self = [super init]) {
        
        self.frame = [UIApplication sharedApplication].keyWindow.bounds;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.65];
        
        // 初始化子view
        [self setupChildView];
        
        [self setupKVO];
    }
    return self;
}

- (void)showSlideCapchaView
{
    // 添加到窗口
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)setupChildView
{
    // 容器
    CGFloat viewX = 25;
    CGFloat ViewW = SCREEN_WIDTH - 50;
    CGFloat viewH = ViewW * 4 / 5;
    CGFloat viewY = (SCREEN_HEIGHT - viewH) *0.5;
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(viewX, viewY, ViewW, viewH)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    
    // 滑动验证view
    NSString *imageStr = [NSString stringWithFormat:@"login_pic_0%zd.png",[self getRandomNumber:1 to:5]];
    _captchaView = [[DWSlideCaptchaView alloc] initWithFrame:CGRectMakeWithPointAndSize(CGPointMake(15, 15), CGSizeMake(ViewW - 30, (ViewW - 30) * 3 / 5)) bgImage:DWImage(imageStr)];
    [contentView addSubview:_captchaView];
    
    // 刷新
    UIButton *refreshButton = [UIButton NNHBtnImage:@"ic_refresh_login" target:self action:@selector(refreshCaptchaView)];
    [_captchaView addSubview:refreshButton];
    [refreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(_captchaView);
        make.width.equalTo(@44);
        make.height.equalTo(@44);
    }];
    
    // slider
    _slider = [[NNSlider alloc] initWithFrame:CGRectMake(CGRectGetMinX(_captchaView.frame), CGRectGetMaxY(_captchaView.frame) + 10, _captchaView.frame.size.width, 40)];
    [contentView addSubview:_slider];
    
    // 提示
    _promptLabel = [UILabel NNHWithTitle:@"向右拖动滑块填充拼图" titleColor:[UIConfigManager colorTextLightGray] font:[UIConfigManager fontThemeTextDefault]];
    _promptLabel.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:_promptLabel];
    [_promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_slider);
    }];
}

- (void)refreshCaptchaView
{
    NSString *imageStr = [NSString stringWithFormat:@"login_pic_0%zd.png",[self getRandomNumber:1 to:5]];
    [self.captchaView beginConfiguration];
    self.captchaView.bgImage = DWImage(imageStr);
    [self.captchaView commitConfiguration];
}

// 获取一个随机整数，范围在[from,to），包括from，不包括to
-(NSInteger)getRandomNumber:(NSInteger)from to:(NSInteger)to
{
    return (NSInteger)(from + (arc4random() % (to - from + 1)));
}

- (void)setupKVO
{
    ///为了获取slider结束拖动使用KVO
    [self addObserver:self forKeyPath:@"slider.tracking" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
    
    ///为了改变验证视图的时使用通知观察slider的数值
    [self.slider addTarget:self action:@selector(sliderValueChange) forControlEvents:(UIControlEventValueChanged)];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    
    if ([keyPath isEqualToString:@"slider.tracking"]) {
        
        self.promptLabel.hidden = YES;
        
        if ([change[@"new"] integerValue] == 0 && [change[@"old"] integerValue] == 1) {///silder结束拖动，开始验证
            if (!self.captchaView.isSuccessed) {
                [self.captchaView indentifyWithAnimated:YES result:^(BOOL success) {
                    if (self.indentifyCompletion) {
                        self.indentifyCompletion(success);
                    }
                }];
            }
        } else if ([change[@"new"] integerValue] == 0 && [change[@"old"] integerValue] == 0) { ///slider归位
            
            self.promptLabel.hidden = NO;
            
            if (self.slider.value) {
                self.slider.value = 0;
            }
        }
    }
}

-(void)sliderValueChange
{
    if (!self.captchaView.isIndentified) {
        [self.captchaView setValue:self.slider.value animated:NO];
    }
}

-(void)dw_CaptchaView:(DWSlideCaptchaView *)captchaView animationCompletionWithSuccess:(BOOL)success
{
    if (!success) {
        [self.captchaView setValue:0 animated:YES];
        [self.captchaView hideThumbWithAnimated:YES];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}

-(void)dealloc
{
    [self removeObserver:self forKeyPath:@"slider.tracking"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
