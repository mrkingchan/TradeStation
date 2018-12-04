//
//  NNHBaseRequest.m
//  NNHPlatform
//
//  Created by 牛牛 on 2017/3/3.
//  Copyright © 2017年 Smile intl. All rights reserved.
//

#import "NNHBaseRequest.h"
#import "NNLoginViewController.h"
#import "UIViewController+NNHExtension.h"
#import "NNHRequestError.h"
#import "AFNetworkReachabilityManager.h"
#import "NNHApplicationHelper.h"

@implementation NNHBaseRequest

/** 自定义URLRequest 如自定义此request则忽略requestUrl, requestArgument, requestMethod,requestSerializerType等 */
- (NSURLRequest *)buildCustomUrlRequest {
    // 服务器地址
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:[YTKNetworkConfig sharedConfig].baseUrl];
    NSURL *URL=[NSURL URLWithString:urlString];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod=@"POST";
    
    //设置请求体
    //把拼接后的字符串转换为data，设置请求体
    NSMutableString *muString = [NSMutableString string];
    [muString appendFormat:@"_apiname=%@",self.requestReServiceType];
    NSString *time = [[NNHProjectControlCenter sharedControlCenter].proConfig getCurrentTimeMedicine];
    [muString appendFormat:@"&_cc=%@",time];
    [muString appendFormat:@"&_ck=%@",[self getCK:time]];
    NSDictionary *dic = @{
                          @"_v":NNHPort,
                          @"_lon":@"",
                          @"_lat":@"",
                          @"_network":[[NNHProjectControlCenter sharedControlCenter].proConfig getNetWorkStates],
                          @"_model":[[NNHProjectControlCenter sharedControlCenter].proConfig getCurrentModel]
                          };
    
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    [muString appendFormat:@"&_env=%@",[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
    
    // 整体拼接mtoken
    NSMutableDictionary *reParams = [NSMutableDictionary dictionaryWithDictionary:self.reParams];
    [reParams setObject:[NNHProjectControlCenter sharedControlCenter].userControl_currentUserModel.mtoken forKey:@"mtoken"];
    
    // 排序 (不区分大小写 区分用compare)
    NSArray* arr = [reParams allKeys];
    arr = [arr sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    for (NSString *key in arr) {
        [muString appendFormat:@"&%@=",key];
        if ([[reParams objectForKey:key] isKindOfClass:[NSString class]]) {
            
            if([[reParams objectForKey:key]isEqualToString:@""]) { // 空的字符串,无参数
                
            }else{ // 普通字符串
                [muString appendString:[reParams objectForKey:key]];
            }
        }else if (([[self.reParams objectForKey:key]isKindOfClass:[NSArray class]])){ // 如果是数组
            NSArray *dataAry = [reParams objectForKey:key];
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataAry options:NSJSONWritingPrettyPrinted error:&parseError];
            NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@" " withString:@""];
            jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            [muString appendFormat:@"%@",jsonStr] ;
        }
    }
    
    // 将所有参数加密 checktoken参数
    NSString *checktoken = [[NSString stringWithFormat:@"%@%@",muString,NNHAPI_PRIVATEKEY_IOS] md5String];
    [muString appendFormat:@"&checktoken=%@",checktoken];
    
    
    request.HTTPBody = [muString dataUsingEncoding:NSUTF8StringEncoding];
    NNHLog(@"\n\n**************!!  组成Post请求体  !!**********************\n\n\
           ApiName:%@\n \n\
           RequestBody : %@\n\n******************!!  End  !!************************\n   ", self.reAPIName,muString);
    return request;
}

#pragma mark -----------开发者
#pragma mark ---------Override Methods
- (YTKResponseSerializerType)responseSerializerType
{
    return YTKResponseSerializerTypeHTTP;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

- (void)nnh_StartRequestWithSucBlock:(void(^)(NSDictionary *responseDic))sucBlock
                           failBlock:(void(^)(NNHRequestError *error))failBlock
                            isCached:(BOOL)cached
{
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus ==AFNetworkReachabilityStatusNotReachable) {
        NNHRequestError *requestError = [[NNHRequestError alloc] init];
        requestError.errorCode = NNHRequestFailed;
        requestError.errorReason = @"无网络";
        requestError.errorApiName = self.reAPIName;
        [requestError printErrorInfo];
        [SVProgressHUD showMessage:@"请检测您的网络状况"];
        failBlock(requestError);
    }
    
    NNHWeakSelf(self);
    [self startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        NNHStrongSelf(self);
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:0 error:nil];
        
        if ([dic[@"code"]integerValue] == 200 ) { // 请求成功
            if (cached) { // 缓存
                [strongself saveResponseDataToCacheFile:request.responseData];
            }
            sucBlock (dic);
            
        }else { // 请求失败
            
            if ([dic[@"code"] integerValue] == 104) { // token失效，请重新登录
                
                if (self.isNoJumpLogin) return;
                [[NNHProjectControlCenter sharedControlCenter].userControl logOut];
                [NNLoginViewController presentInViewController:[UIViewController currentViewController] completion:nil];
                
            }else {
                if (![dic[@"msg"]isEqualToString:@""] && dic[@"msg"] != nil ) {
                    if ([SVProgressHUD isVisible]) {
                        [SVProgressHUD nn_dismissWithDelay:0.3 completion:^{
                            [SVProgressHUD showMessage:dic[@"msg"]];
                        }];
                    }else{
                        [SVProgressHUD showMessage:dic[@"msg"]];
                    }
                }
            }
            NNHRequestError *requestError = [[NNHRequestError alloc] init];
            requestError.errorCode = request.responseStatusCode;
            requestError.errorReason = request.responseString;
            requestError.errorApiName = request.requestUrl;
            [requestError printErrorInfo];
            failBlock(requestError);
        }
        
        NNHLog(@"\n\n**************!!  请求完成  !!**********************\n\n\
               ApiName:%@ \n \n\
               StatusCode: %ld \n \n\
               ResponseString : %@ \n\n\
               ResponseJsonObjct : %@ \n \n******************!!  End  !!************************\n   ", self.reAPIName,(long)request.responseStatusCode,[self transformResponseToJsonWithResponse:request.responseString],request.responseJSONObject);
        
    } failure:^(YTKBaseRequest *request) {
        NNHRequestError *requestError = [[NNHRequestError alloc] init];
        requestError.errorCode = request.responseStatusCode;
        requestError.errorReason = request.responseString;
        requestError.errorApiName = request.requestUrl;
        [requestError printErrorInfo];
        failBlock(requestError);
    }];
}

#pragma mark - tip:直接打印出json格式 方便在下面看日志
- (id)transformResponseToJsonWithResponse:(id)response {
    if ([response isKindOfClass:[NSString class]]) {
        return [NSJSONSerialization JSONObjectWithData:[((NSString *)response) dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    } else if ([response isKindOfClass:[NSData class]]) {
        return [NSJSONSerialization JSONObjectWithData:(NSData *)response options:kNilOptions error:nil];
    }
    return response;
}

// 请求超时时间
-(NSTimeInterval)requestTimeoutInterval
{
    return 30;
}

- (NSString *)getCK:(NSString *)cc
{
    NSString *str1 = [[NSString stringWithFormat:@"%@%@",cc,NNHAPI_PRIVATEKEY_IOS] md5String];
    NSString *str2 = [[NSString stringWithFormat:@"%@%@%@",cc,NNHAPI_PRIVATEKEY_IOS,self.requestReServiceType] md5String];
    NSString *tmp = [NSString stringWithFormat:@"%@%@",str1,str2];
    
    // 截取
    NSInteger indxe = [[cc substringFromIndex:cc.length - 1] integerValue];
    NSString *ck = [tmp substringWithRange:NSMakeRange(indxe, 51)];
    return ck;
}

@end
