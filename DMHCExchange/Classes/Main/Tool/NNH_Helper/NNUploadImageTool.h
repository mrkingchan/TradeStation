//
//  NNUploadImageTool.h
//  SuperWallet
//
//  Created by 牛牛 on 2018/3/29.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NNHRequestError.h"

@interface NNUploadImageTool : NSObject

+ (void)uploadWithImage:(UIImage *)image successBlock:(void (^)(NSString *upUrl,NSString *wholeUrl))sucBlock failedBlock:(void (^)(NNHRequestError *error))failBlock;

/** 上传图片数组 */
+ (void)uploadImageArray:(NSArray <UIImage *>*)imageArray complete:(void(^)(NSString *imageString))complete;

/** 上传图片数组 带上传图片失败的回调 */
+ (void)uploadImageArray:(NSArray <UIImage *>*)imageArray complete:(void(^)(NSString *imageString))complete failBlock:(void(^)(NNHRequestError *error))failBlock;

/** 返回图片上传数组 */
+ (void)uploadImageArray:(NSArray <UIImage *>*)imageArray completeArray:(void(^)(NSArray *imageArray))completeArray;

@end
