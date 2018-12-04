//
//  NNHCountryCodeModel.h
//  WBTWallet
//
//  Created by 来旭磊 on 2018/8/11.
//  Copyright © 2018年 深圳市云牛惠科技有限公司. All rights reserved.
//

/*****************************************************
 
 @Author             来旭磊
 
 @CreateTime      TimeForever
 
 @ function           注册页面 郭嘉手机号编码
 
 @Remarks          <#注释#>
 
 *****************************************************/

#import <Foundation/Foundation.h>

@interface NNHCountryCodeModel : NSObject

/** 限时编码 */
@property (nonatomic, copy) NSString *scode;
/** 国家名称 */
@property (nonatomic, copy) NSString *name;
/** 编码 */
@property (nonatomic, copy) NSString *code;

@end
