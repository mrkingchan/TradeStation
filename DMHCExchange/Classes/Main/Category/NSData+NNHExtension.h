//
//  NSData+NNHExtension.h
//  DMHCAMU
//
//  Created by 牛牛 on 2018/10/23.
//  Copyright © 2018年 牛牛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (NNHExtension)

/**
 返回已解码的NSDictionary或NSArray
 */
- (nullable id)jsonValueDecoded;

@end
