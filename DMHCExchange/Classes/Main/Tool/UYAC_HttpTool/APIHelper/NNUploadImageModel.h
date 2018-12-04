//
//  NNUploadImageModel.h
//  SuperWallet
//
//  Created by 牛牛 on 2018/3/29.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NNUploadImageModel : NSObject

@property (nonatomic, copy) NSString *accessid;
@property (nonatomic, copy) NSString *host;
@property (nonatomic, copy) NSString *policy ;
@property (nonatomic, copy) NSString *signature;
@property (nonatomic, copy) NSString *expire;
@property (nonatomic, copy) NSString *dir;
@property (nonatomic, copy) NSString *success_action_status;
@property (nonatomic, copy) NSString *ImgServerName;
@property (nonatomic, copy) NSString *bucketName;

@end
