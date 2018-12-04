//
//  NNShareModel.h
//  SuperWallet
//
//  Created by 牛牛 on 2018/4/3.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NNShareModel : NSObject

/** 分享标题 */
@property (nonatomic, copy) NSString *share_title;
/** 分享内容 */
@property (nonatomic, copy) NSString *share_content;
/** 分享内容 */
@property (nonatomic, copy) NSString *share_image;
/** 分享URL */
@property (nonatomic, copy) NSString *share_url;

@end
