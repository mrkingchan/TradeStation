//
//  UIButton+Combo.m
//  JKCategories-Demo
//
//  Created by 牛牛 on 2017/6/7.
//  Copyright © 2017年 www.skyfox.org. All rights reserved.
//

#import "UIButton+Combo.h"
#import <objc/runtime.h>

@interface UIButton ()

@property (nonatomic, assign) NSTimeInterval nn_acceptEventTime;

@end

@implementation UIButton (Combo)

static const char *UIControl_acceptEventInterval = "UIControl_acceptEventInterval";
static const char *UIControl_acceptEventTime = "UIControl_acceptEventTime";

- (NSTimeInterval)nn_acceptEventInterval
{
    return  [objc_getAssociatedObject(self, UIControl_acceptEventInterval) doubleValue];
}

- (void)setNn_acceptEventInterval:(NSTimeInterval)nn_acceptEventInterval
{
    objc_setAssociatedObject(self, UIControl_acceptEventInterval, @(nn_acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval)nn_acceptEventTime {
    return  [objc_getAssociatedObject(self, UIControl_acceptEventTime) doubleValue];
}

- (void)setNn_acceptEventTime:(NSTimeInterval)nn_acceptEventTime {
    objc_setAssociatedObject(self, UIControl_acceptEventTime, @(nn_acceptEventTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// 在load时执行hook
+ (void)load
{
    SEL selA = @selector(sendAction:to:forEvent:);
    SEL selB = @selector(nn_sendAction:to:forEvent:);
    
    Method methodA =  class_getInstanceMethod(self,selA);
    Method methodB = class_getInstanceMethod(self, selB);
    
    //将 methodB的实现 添加到系统方法中 也就是说 将 methodA方法指针添加成 方法methodB的  返回值表示是否添加成功
    BOOL isAdd = class_addMethod(self, selA, method_getImplementation(methodB), method_getTypeEncoding(methodB));
    
    //添加成功了 说明 本类中不存在methodB 所以此时必须将方法b的实现指针换成方法A的，否则 b方法将没有实现。
    if (isAdd) {
        class_replaceMethod(self, selB, method_getImplementation(methodA), method_getTypeEncoding(methodA));
    }else{
        //添加失败了 说明本类中 有methodB的实现，此时只需要将 methodA和methodB的IMP互换一下即可。
        method_exchangeImplementations(methodA, methodB);
    }
}

- (void)nn_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    if ([NSDate date].timeIntervalSince1970 - self.nn_acceptEventTime < self.nn_acceptEventInterval) {
        return;
    }
    
    if (self.nn_acceptEventInterval > 0) {
        self.nn_acceptEventTime = [NSDate date].timeIntervalSince1970;
    }
    
    [self nn_sendAction:action to:target forEvent:event];
}

@end
