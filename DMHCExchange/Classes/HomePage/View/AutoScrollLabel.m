//
//  AutoScrollLabel.m
//  DMHCExchange
//
//  Created by 云笈 on 2018/10/25.
//  Copyright © 2018年 超级钱包. All rights reserved.
//


#import "AutoScrollLabel.h"

@implementation AutoScrollLabel

//memory management
- (void)dealloc {
    if (_timer) {
        [_timer setFireDate:[NSDate distantFuture]];
        _timer = nil;
    }
}

// initialize Method
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return self;
}

// label文字自动向上滚动，
- (void)setcontentArray:(NSArray *)contentArray autoScrollUp:(BOOL)scrollUp clickBlock:(void(^)(NSInteger scrollId))clickBlock {
    if (!contentArray.count) {
        return;
    }
    _clickBlock = clickBlock;
    _index = 0;
    _contentArray = contentArray;
    if ([_contentArray[_index] isKindOfClass:[NSAttributedString class]]) {
        self.attributedText = _contentArray[_index];
    } else {
        self.text = _contentArray[_index];
    }
    _position = self.frame.origin;
    _scrollUp = scrollUp;
    _scrollTime = 5.0;
    if (!_timer) {
        // 初始化计时器
        _timer = [NSTimer scheduledTimerWithTimeInterval:_scrollTime target:self selector:@selector(startPlayAD) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:UITrackingRunLoopMode];
    }
}

#pragma mark - 播放与停止
// 重新播放
- (void)startPlayAD {
    if (![_timer isValid]) {
        [_timer  setFireDate:[NSDate date]];
    }
    [UIView animateWithDuration:0.15 animations:^{
        self.frame = CGRectMake(_position.x, _scrollUp ? _position.y - self.frame.size.height : _position.y + self.frame.size.height , self.frame.size.width, self.frame.size.height);
        self.alpha = 0.1;
    } completion:^(BOOL finished) {
        if (_index < _contentArray.count - 1) {
            _index++;
        } else {
            _index = 0;
        }
        if ([_contentArray[_index] isKindOfClass:[NSAttributedString class]]) {
            self.attributedText = _contentArray[_index];
        } else {
            self.text = _contentArray[_index];
        }
        self.alpha = 1.0;
        self.frame = CGRectMake(_position.x, _position.y, self.frame.size.width, self.frame.size.height);
    }];
}

// 停止播放
- (void)stopPlayAD {
    [_timer  setFireDate:[NSDate distantFuture]];
}

// 手势控制
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
   /* UITouch *touch = [touches anyObject];
    //touch.gestureRecognizers
    CGPoint point = [touch locationInView:self];
    */
    if (_clickBlock) {
        _clickBlock(_index);
    }
}

@end

