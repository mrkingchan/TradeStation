//
//  NNHUIConfigManager.m
//  ElegantTrade
//
//  Created by 牛牛 on 16/10/18.
//  Copyright © 2016年 Smile intl. All rights reserved.
//  UI 配置


#import "NNHUIConfigManager.h"
#import "NNHDefaultStyleFont.h"
#import "NNHDefaultStyleColor.h"
#import "NNHDefaultStylePlaceHolder.h"
#import <objc/runtime.h>

@interface NNHUIConfigManager ()

/** UI风格 暂时不支持热切换 必须重启**/
@property (nonatomic, assign) NNHUIStyle uiStyle;
@property (nonatomic, strong) id <NNHFontProtocol> fontManager;
@property (nonatomic, strong) id <NNHColorProtocol> colorManager;
@property (nonatomic, strong) id <NNHPlaceHoderImageProcotol> placeHolderManager;

@end

@implementation NNHUIConfigManager

void noResponse (id self, SEL _cmd){
     NSLog(@" *************************************************  \n \
         AKUIConfigManager Warning!!!  \n \
         这个方法没有人执行:: %s   !!!! \n \
         检查是否满足以下条件:\n \
         1. 方法开头要有font/color等功能字样 \n \
         2. 方法要在遵循代理的类中实现!  \n *************************************************   ", sel_getName(_cmd));
}

/** 经过这个方法过滤一下 **/
+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    NSString *selName = NSStringFromSelector(sel);
    
    if ([selName hasPrefix:@"font"] ||
        [selName hasPrefix:@"color"] ||
        [selName hasPrefix:@"NNH_placeHolder"]) {
        return NO;
    }else{
        // 动态添加一个方法
        class_addMethod([self class], sel, (IMP)noResponse, "v@:");
        return [super resolveInstanceMethod:sel];
    }
    
}

/** 当此类没有遵循代理类中方法的实现时候会调用该方法 将消息转发给具体代理喽 **/
- (id)forwardingTargetForSelector:(SEL)aSelector
{
    NSString *selName = NSStringFromSelector(aSelector);
    if ([selName hasPrefix:@"font"]) {
        return self.fontManager;
    }else if ([selName hasPrefix:@"color"]){
        return self.colorManager;
    } else if ([selName hasPrefix:@"NNH_placeHolder"]){
        return self.placeHolderManager;
    }
    else {
        noResponse(self, aSelector);
        return nil;
    }
}


#pragma mark -
#pragma mark ---------Init Methods
/** 暂时还不需要支持主题切换，先这样吧 **/
+ (instancetype)sharedManager
{
    return [self sharedManagerWithStyle:NNHUIStyle_Default];
}

+ (instancetype)sharedManagerWithStyle:(NNHUIStyle)uiStyle
{
    static NNHUIConfigManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[NNHUIConfigManager alloc] initWithStyle:uiStyle];
    });
    return _manager;
}

- (instancetype)initWithStyle:(NNHUIStyle)uiStyle
{
    if (self = [super init]) {
        _uiStyle = uiStyle;
        [self prepareComponentsManager];
    }
    return self;
}

- (void)prepareComponentsManager
{
    switch (_uiStyle) {
        default:
        {
            _fontManager = [[NNHDefaultStyleFont alloc] init];
            _colorManager = [[NNHDefaultStyleColor alloc] init];
            _placeHolderManager = [[NNHDefaultStylePlaceHolder alloc] init];
        }
            break;
    }
}

/**
 *  返回以iPhone 6 屏幕宽度为基准，等比伸缩后的数值
 *  适用:1. 把设计稿宽度拉到375, 然后用截图软件测量距离
 *      2. 设计稿是以6的屏幕基准标注的距离
 *
 */
+ (CGFloat)widthCompareWithStandardScreenWidth:(CGFloat)designValue
{
    return  designValue *([UIScreen mainScreen].bounds.size.width /375.f);
}


@end
