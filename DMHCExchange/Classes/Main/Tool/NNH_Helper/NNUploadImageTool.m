//
//  NNUploadImageTool.m
//  SuperWallet
//
//  Created by 牛牛 on 2018/3/29.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import "NNUploadImageTool.h"
#import "NNImageBaseRequest.h"
#import "NNAPIMineTool.h"
#import "AFNetworking.h"

@implementation NNUploadImageTool

+ (void)uploadWithImage:(UIImage *)image successBlock:(void (^)(NSString *upUrl,NSString *wholeUrl))sucBlock failedBlock:(void (^)(NNHRequestError *error))failBlock
{
    // 图片处理
    NNUploadImageTool *imageTool = [[NNUploadImageTool alloc] init];
    image = [UIImage imageWithData:[imageTool resetSizeOfImageData:image maxSize:300]];
    
    NNAPIMineTool *params = [[NNAPIMineTool alloc] initUploadImage];
    [params nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
        NNUploadImageModel *model = [NNUploadImageModel mj_objectWithKeyValues:responseDic[@"data"]];
        NNImageBaseRequest *api = [[NNImageBaseRequest alloc] initWithModel:model image:image];
        
        [api image_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
            sucBlock([NSString stringWithFormat:@"%@",responseDic[@"UploadUrl"]],[NSString stringWithFormat:@"%@",responseDic[@"WholeUrl"]]);
        } failBlock:^(NNHRequestError *error){
            failBlock(error);
        }];
        
    } failBlock:^(NNHRequestError *error) {
        
    } isCached:NO];
    
}

- (void)loadImageFinished:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NNHLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}

+ (void)uploadImageArray:(NSArray <UIImage *>*)imageArray complete:(void(^)(NSString *imageString))complete
{
    if (imageArray.count == 0) {
        complete(@"");
    }
    
    if (imageArray.count > 0) { // 获得全局的并发队列
        dispatch_group_t group = dispatch_group_create();
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        __block NSString *multiImageStr = [[NSString alloc] init];
        for (NSInteger i = 0; i < imageArray.count; i++) {
            dispatch_group_enter(group);
            dispatch_group_async(group, queue, ^{
                
                // 取出当前图片
                UIImage *newImage = imageArray[i];
                
                // 上传图片
                [NNUploadImageTool uploadWithImage:newImage successBlock:^(NSString *upUrl, NSString *wholeUrl) {
                    
                    multiImageStr = [NSString stringWithFormat:@"%@,%@",multiImageStr,upUrl];
                    
                    dispatch_group_leave(group);
                    
                } failedBlock:^(NNHRequestError *error) {
                    dispatch_group_leave(group);
                }];
            });
        }
        
        dispatch_group_notify(group, queue, ^{
            if (multiImageStr.length > 1) {
                multiImageStr = [multiImageStr substringFromIndex:1];
            }
            if (complete) {
                complete(multiImageStr);
            }
        });
    }
}

+ (void)uploadImageArray:(NSArray <UIImage *>*)imageArray complete:(void(^)(NSString *imageString))complete failBlock:(void(^)(NNHRequestError *error))failBlock
{
    if (imageArray.count == 0) {
        complete(@"");
    }
    
    if (imageArray.count > 0){
        // 获得全局的并发队列
        dispatch_group_t group = dispatch_group_create();
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        __block NSString *multiImageStr = [[NSString alloc] init];
        for (NSInteger i = 0; i < imageArray.count; i++) {
            dispatch_group_enter(group);
            dispatch_group_async(group, queue, ^{
                
                // 取出当前图片
                UIImage *newImage = imageArray[i];
                
                // 上传图片
                [NNUploadImageTool uploadWithImage:newImage successBlock:^(NSString *upUrl, NSString *wholeUrl) {
                    
                    multiImageStr = [NSString stringWithFormat:@"%@,%@",multiImageStr,upUrl];
                    
                    dispatch_group_leave(group);
                    
                } failedBlock:^(NNHRequestError *error) {
                    if (failBlock) {
                        failBlock(error);
                    }
                }];
            });
        }
        
        dispatch_group_notify(group, queue, ^{
            if (multiImageStr.length > 1) {
                multiImageStr = [multiImageStr substringFromIndex:1];
            }
            if (complete) {
                complete(multiImageStr);
            }
        });
    }
}



+ (void)uploadImageArray:(NSArray <UIImage *>*)imageArray completeArray:(void(^)(NSArray *imageArray))completeArray
{
    if (imageArray.count == 0) {
        completeArray(@[]);
    }
    
    if (imageArray.count > 0) { // 获得全局的并发队列
        dispatch_group_t group = dispatch_group_create();
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        __block NSMutableArray *array = [NSMutableArray array];
        for (NSInteger i = 0; i < imageArray.count; i++) {
            dispatch_group_enter(group);
            dispatch_group_async(group, queue, ^{
                
                // 取出当前图片
                UIImage *newImage = imageArray[i];
                
                // 上传图片
                [NNUploadImageTool uploadWithImage:newImage successBlock:^(NSString *upUrl, NSString *wholeUrl) {
                    
                    [array addObject:upUrl];
                    
                    dispatch_group_leave(group);
                    
                } failedBlock:^(NNHRequestError *error) {
                    
                }];
            });
        }
        
        dispatch_group_notify(group, queue, ^{
            if (completeArray) {
                completeArray([array copy]);
            }
        });
    }
}


/**
 *  图片压缩
 */
- (NSData *)resetSizeOfImageData:(UIImage *)source_image maxSize:(NSInteger)maxSize
{
    //先判断当前质量是否满足要求，不满足再进行压缩
    __block NSData *finallImageData = UIImageJPEGRepresentation(source_image,1.0);
    NSUInteger sizeOrigin   = finallImageData.length;
    NSUInteger sizeOriginKB = sizeOrigin / 1024;
    
    if (sizeOriginKB <= maxSize) {
        return finallImageData;
    }
    
    //先调整分辨率 http://www.pmcaff.com/article?id=2000000000007505
    CGSize defaultSize = CGSizeMake(1280, 1280);
    UIImage *newImage = [self newSizeImage:defaultSize image:source_image];
    finallImageData = UIImageJPEGRepresentation(newImage,1.0);
    
    /*
     调整大小
     说明：压缩系数数组@[@0.8,@0.7,@0.6,@0.55]
     */
    //思路：使用二分法搜索
    finallImageData = [self halfFuntion:@[@0.8,@0.7,@0.6,@0.55] image:newImage sourceData:finallImageData maxSize:maxSize];
    
    return finallImageData;
}

#pragma mark 调整图片分辨率/尺寸（等比例缩放）
- (UIImage *)newSizeImage:(CGSize)size image:(UIImage *)source_image {
    
    CGSize newSize = CGSizeMake(source_image.size.width, source_image.size.height);
    
    CGFloat tempHeight = source_image.size.height / size.height;
    CGFloat tempWidth = source_image.size.width / size.width;
    
    if (tempWidth > 1.0 && tempWidth > tempHeight) {
        newSize = CGSizeMake(source_image.size.width / tempWidth, source_image.size.height / tempWidth);
    }
    else if (tempHeight > 1.0 && tempWidth < tempHeight){
        newSize = CGSizeMake(source_image.size.width / tempHeight, source_image.size.height / tempHeight);
    }
    
    UIGraphicsBeginImageContext(newSize);
    [source_image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark 二分法
- (NSData *)halfFuntion:(NSArray *)arr image:(UIImage *)image sourceData:(NSData *)finallImageData maxSize:(NSInteger)maxSize {
    
    for (NSInteger i = 0; i < arr.count; i++) { // 当最小压缩系数还是大于规定maxSize时 以最小系数上传
        finallImageData = UIImageJPEGRepresentation(image,[arr[i] floatValue]);
        NSUInteger sizeOriginKB = finallImageData.length / 1024;
        NNHLog(@"当前降到的质量：%ld -----当前系数：%.2f", (unsigned long)sizeOriginKB,[arr[i] floatValue]);
        if (sizeOriginKB < maxSize) {
            return finallImageData;
        }
    }
    
    return finallImageData;
}

#pragma mark -- UIImage -> Base64图片
- (BOOL)imageHasAlpha:(UIImage *)image
{
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(image.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}

static NSString *const kAFCharactersGeneralDelimitersToEncode =@":#[]@";
static NSString *const kAFCharactersSubDelimitersToEncode = @"!$&'()*+,;=";
- (NSString *)image2DataURL:(UIImage *)image
{
//    NSData   *imageData = nil;
//    //NSString *mimeType  = nil;
//    if ([self imageHasAlpha:image]) {
//        
//        imageData = UIImagePNGRepresentation(image);
////        mimeType = @"image/png";
//    }else{
//        
//        imageData = UIImageJPEGRepresentation(image, 0.3f);
////        mimeType = @"image/jpeg";
//    }
    
    NSData *imageData = [self resetSizeOfImageData:image maxSize:300];
    
    NSString *imageStr = [NSString stringWithFormat:@"data:image/jpeg;base64,%@",[imageData base64EncodedStringWithOptions: 0]];
    
//    NSMutableCharacterSet *allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
//    [allowedCharacterSet removeCharactersInString:[kAFCharactersGeneralDelimitersToEncode stringByAppendingString:kAFCharactersSubDelimitersToEncode]];
//    imageStr =  [imageStr stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
    
//    NSString *charactersToEscape = @":/?#[]@!$&’()*+,;=";
//    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    
//    imageStr = [imageStr stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
    
    return imageStr;
////    NSData *imageData = UIImageJPEGRepresentation(image, 1.0f);
//    NSData *imageData = [self resetSizeOfImageData:image maxSize:300];
//
////    NSString *string = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
//
//    NSString *imageStr = [NSString stringWithFormat:@"data:%@;base64,%@", @"image/jpeg",
//                          [imageData base64EncodedStringWithOptions:0]];
//
//    NSString *charactersToEscape = @":/?#[]@!$&’()*+,;=";
//    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
//
//    imageStr = [imageStr stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
//
//    return imageStr;
    
}

@end
