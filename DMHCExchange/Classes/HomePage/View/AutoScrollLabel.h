//
//  AutoScrollLabel.h
//  DMHCExchange
//
//  Created by 云笈 on 2018/10/25.
//  Copyright © 2018年 超级钱包. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AutoScrollLabel  : UILabel {
    NSTimer *_timer;
    NSArray *_contentArray;
    NSArray *_idArray;
    CGPoint _position;
    NSInteger _index;
    BOOL _scrollUp;
    CGFloat _scrollTime;
}

@property (nonatomic, copy) void (^clickBlock)(NSInteger index);

// label文字自动向上滚动，
- (void)setcontentArray:(NSArray *)contentArray autoScrollUp:(BOOL)scrollUp clickBlock:(void(^)(NSInteger scrollId))clickBlock;

@end

NS_ASSUME_NONNULL_END
