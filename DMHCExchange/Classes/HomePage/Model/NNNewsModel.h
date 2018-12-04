//
//  NNNewsModel.h
//  DMHCExchange
//
//  Created by 云笈 on 2018/10/24.
//  Copyright © 2018年 超级钱包. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NNNewsModel : NSObject

/*内容**/
@property (nonatomic, strong) NSString *title;
/*发布时间**/
@property (nonatomic, strong) NSString *addtime;
/*发布配图**/
@property (nonatomic, strong) NSString *thumb;

/**跳转url*/
@property (nonatomic, strong) NSString *url;


@end

NS_ASSUME_NONNULL_END
