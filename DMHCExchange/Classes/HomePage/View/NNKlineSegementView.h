//
//  NNKlineSegementView.h
//  DMHCExchange
//
//  Created by 云笈 on 2018/10/26.
//  Copyright © 2018年 超级钱包. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NNKlineSegementView : UIView

@property(nonatomic,copy)void ((^complete) (NSInteger));

+ (instancetype)nKlineSegementViewWithArray:(NSArray *)titleArray
                                   complete:(void (^) (NSInteger index))complete;

- (void)replaceTagWithContent:(NSString *)contentStr index:(NSInteger)index;

- (void)setSelectedIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
