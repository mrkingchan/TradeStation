//
//  NNDropListView.h
//  DMHCExchange
//
//  Created by 云笈 on 2018/10/26.
//  Copyright © 2018年 超级钱包. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NNDropListView : UIView

@property(nonatomic,copy)void ((^complete) (NSString *,NSInteger));


+ (instancetype)nnDropListViewWithArray:(NSArray *)titles
                               complete:(void (^)(NSString *subStr,NSInteger index))complete;
                                                                     
@end

NS_ASSUME_NONNULL_END
