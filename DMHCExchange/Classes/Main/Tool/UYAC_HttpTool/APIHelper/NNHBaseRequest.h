//
//  NNHBaseRequest.h
//  NNHPlatform
//
//  Created by 牛牛 on 2017/3/3.
//  Copyright © 2017年 Smile intl. All rights reserved.
//

/*
 
 1、属性赋值统一在init方法中进行，严格按照接口文档的排列顺序放入数组reParams
 2、使用时直接调用start方法，可以用代理，或者Block回调，这样调start不是属于我这里的基类，属于猿题库的start，最好带上uyacstart
 3、其他个性化配置参照文档 BasicGuide.md
 4、必带参数已经封装在此类接口中
 
 */

#import "YTKRequest.h"
@class NNHRequestError;

@interface NNHBaseRequest : YTKRequest

/** 接口名称 在子类赋值，必填 **/
@property (nonatomic, copy) NSString *requestReServiceType;
/** 发起请求时间  YYYYMMDDHHMMSS 在此类计算 **/
@property (nonatomic, copy, readonly) NSString *requetConnectionTime;
/** 字段值按照接口文档顺序放进数组，这就是带的参数 **/
@property (nonatomic, strong) NSDictionary *reParams;


#pragma mark -
#pragma mark ---------辅助
/** 辅助接口名字，用于输出，可写可不写，最好带上，方便调试**/
@property (nonatomic, copy) NSString *reAPIName;
/** 返回104 是否禁止跳转登录页面 */
@property (nonatomic, assign, getter=isNoJumpLogin) BOOL noJumpLogin;


#pragma mark -
#pragma mark ---------发起请求
/**
 *  发起请求
 *
 *  @param sucBlock  成功之后返回的数据字典,是否添加缓存
 *  @param failBlock  失败返回Error
 */
- (void)nnh_StartRequestWithSucBlock:(void(^)(NSDictionary *responseDic))sucBlock
                            failBlock:(void(^)(NNHRequestError *error))failBlock
                             isCached:(BOOL)cached;

@end
