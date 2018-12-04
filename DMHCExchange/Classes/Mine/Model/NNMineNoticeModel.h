//
//  NNMineNoticeModel.h
//  DMHCExchange
//
//  Created by 牛牛 on 2018/10/25.
//  Copyright © 2018年 超级钱包. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NNMineNoticeModel : NSObject

/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 时间 */
@property (nonatomic, copy) NSString *addtime;
/** 跳转链接 */
@property (nonatomic, copy) NSString *url;

@end
