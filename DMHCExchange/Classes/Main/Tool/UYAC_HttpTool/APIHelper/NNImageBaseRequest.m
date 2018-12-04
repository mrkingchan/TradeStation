//
//  NNImageBaseRequest.m
//  SuperWallet
//
//  Created by 牛牛 on 2018/3/29.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import "NNImageBaseRequest.h"
#import "YTKNetworkConfig.h"
#import "AFNetworking.h"

@interface NNUploadImageModel ()

@end

//缩放比例调整上传的
#define UpImageFactor  0.9
@interface NNImageBaseRequest ()

/** upLoadImage **/
@property (nonatomic, strong) UIImage *upLoadImage;
/** model **/
@property (nonatomic, strong) NNUploadImageModel *upLoadImageModel;

@end

@implementation NNImageBaseRequest

- (instancetype)initWithModel:(NNUploadImageModel *)upLoadImageModel image:(UIImage *)image
{
    self = [super init];
    if (self) {
        _upLoadImage = image;
        _upLoadImageModel = upLoadImageModel;
    }
    return self;
}

- (NSString *)baseUrl
{
    return self.upLoadImageModel.host;
}

- (NSString *)requestUrl
{
    return @"";
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

- (id)requestArgument
{
    return @{
                 @"key":[NSString stringWithFormat:@"%@.jpeg",self.upLoadImageModel.dir],
                 @"policy":self.upLoadImageModel.policy,
                 @"OSSAccessKeyId":self.upLoadImageModel.accessid,
                 @"success_action_status":self.upLoadImageModel.success_action_status,
                 @"signature":self.upLoadImageModel.signature
            };
}

- (AFConstructingBlock)constructingBodyBlock {
    return ^(id<AFMultipartFormData> formData) {
        
        NSMutableData *data1 =  [[NSMutableData alloc]initWithData:UIImageJPEGRepresentation(self.upLoadImage, UpImageFactor)];
        NSString *name =  [NSString stringWithFormat:@"%@.jpeg",[self stringFromNowDate]];
        NSString *formKey = @"file";
        NSString *type = @"image/jpeg";
        [formData appendPartWithFileData:data1 name:formKey fileName:name mimeType:type];
    };
}

- (NSString *)stringFromNowDate
{
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f",timeInterval];
    return timeString;
}

/**
 *  发起请求
 *
 *  @param sucBlock  成功之后返回的数据字典
 *  @param failBlock  失败返回Error
 */
- (void)image_StartRequestWithSucBlock:(void(^)(NSDictionary *responseDic))sucBlock
                             failBlock:(void(^)(NNHRequestError *error))failBlock
{
    NNHWeakSelf(self)
    [self startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        //        阿里云服务器不反回任何数据，所以我这里如果没有就是成功
        NSDictionary *dic = @{
                              @"WholeUrl":[NSString stringWithFormat:@"%@%@.jpeg",weakself.upLoadImageModel.ImgServerName,weakself.upLoadImageModel.dir],
                              @"UploadUrl":[NSString stringWithFormat:@"%@.jpeg",weakself.upLoadImageModel.dir]
                              };
        sucBlock(dic);
        NNHLog(@"\n\n**************!!  请求完成  !!**********************\n\n\
               StatusCode: %ld \n \n\
               ResponseString : %@ \n\n\
               ResponseJsonObjct : %@ \n \n******************!!  End  !!************************\n   ",(long)request.responseStatusCode,request.responseString,request.responseJSONObject);
        
    } failure:^(YTKBaseRequest *request) {
        if (![request.responseString isEqualToString:@""]&&request.responseString != nil) {
            [SVProgressHUD showMessage:request.responseString];
        }
        NNHRequestError *requestError = [[NNHRequestError  alloc]init];
        requestError.errorCode = request.responseStatusCode;
        requestError.errorReason = request.responseString;
        requestError.errorApiName = request.requestUrl;
        [requestError printErrorInfo];
        failBlock(requestError);
    }];
}

// 请求超时时间
-(NSTimeInterval)requestTimeoutInterval
{
    return 30;
}

@end
