//
//  NNHAlertTool.h
//  ElegantTrade
//
//  Created by 牛牛 on 16/10/31.
//  Copyright © 2016年 Smile intl. All rights reserved.
//

typedef NS_ENUM(NSInteger, NNHAlertControllerStyle) {
    NNHAlertControllerStyleAlert,
    NNHAlertControllerStyleActionSheet
};

#import <Foundation/Foundation.h>

@interface NNHAlertTool : NSObject

+ (instancetype)shareAlertTool;

-(void)showAlertView:(UIViewController *)viewController
               title:(NSString *)title
             message:(NSString *)message
   cancelButtonTitle:(NSString *)cancelButtonTitle
    otherButtonTitle:(NSString *)otherButtonTitle
             confirm:(void (^)(void))confirm
              cancle:(void (^)(void))cancle;

- (void)showActionSheet:(UIViewController *)viewController
                  title:(NSString *)title
                message:(NSString *)message
      acttionTitleArray:(NSArray *)titleArray
                confirm:(void (^)(NSInteger index))confirm
                 cancle:(void (^)(void))cancle;

-(void)showAlertView:(UIViewController *)viewController
               title:(NSString *)title
        placeHoleder:(NSString *)placeHoleder
   cancelButtonTitle:(NSString *)cancelButtonTitle
    otherButtonTitle:(NSString *)otherButtonTitle
             confirm:(void (^)(NSString *content))confirm
              cancle:(void (^)(void))cancle;
@end
