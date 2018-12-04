//
//  NNHFingerprintTool.h
//  NNHBitooex
//
//  Created by 牛牛 on 2018/3/23.
//  Copyright © 2018年 深圳市云牛惠科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NNHSingleton.h"

@interface NNHFingerprintTool : NSObject
NNHSingletonH

// 是否开启指纹
- (BOOL)openFingerprint;

// 开始指纹结果
- (void)openFingerprintResults:(void(^)(BOOL success))results;

// 改变指纹状态
- (void)switchFingerprintStatus;


@end
