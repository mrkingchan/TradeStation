//
//  NNHAlertTool.m
//  ElegantTrade
//
//  Created by 牛牛 on 16/10/31.
//  Copyright © 2016年 Smile intl. All rights reserved.
//

#import "NNHAlertTool.h"

@interface NNHAlertTool ()

/** <#注释#> */
@property (nonatomic, copy) NSString *contentText;

@end

@implementation NNHAlertTool

-(void)showAlertView:(UIViewController *)viewController
               title:(NSString *)title
             message:(NSString *)message
   cancelButtonTitle:(NSString *)cancelButtonTitle
    otherButtonTitle:(NSString *)otherButtonTitle
             confirm:(void (^)(void))confirm
              cancle:(void (^)(void))cancle
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // 修改title
    if (title) {
        NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:title];
        [alertControllerStr addAttribute:NSForegroundColorAttributeName value:[UIConfigManager colorThemeBlack] range:NSMakeRange(0, title.length)];
        [alertControllerStr addAttribute:NSFontAttributeName value:[UIConfigManager fontThemeTextImportant] range:NSMakeRange(0, title.length)];
        [alertController setValue:alertControllerStr forKey:@"attributedTitle"];
    }

    //修改message
    if (message) {
        NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:message];
        [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:[UIConfigManager colorTextLightGray] range:NSMakeRange(0, message.length)];
        [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIConfigManager fontThemeTextDefault] range:NSMakeRange(0, message.length)];
        [alertController setValue:alertControllerMessageStr forKey:@"attributedMessage"];
    }

    // Create the actions.
    if (cancelButtonTitle) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            cancle();
        }];
        [alertController addAction:cancelAction];
    }
    
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        confirm();
    }];
    
    // Add the actions.
    [alertController addAction:otherAction];
    [viewController presentViewController:alertController animated:YES completion:nil];
}

- (void)showActionSheet:(UIViewController *)viewController
                  title:(NSString *)title
                message:(NSString *)message
      acttionTitleArray:(NSArray *)titleArray
                confirm:(void (^)(NSInteger index))confirm
                 cancle:(void (^)(void))cancle
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    
    // 修改title
    
    if (title) {
        NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:title];
        [alertControllerStr addAttribute:NSForegroundColorAttributeName value:[UIConfigManager colorThemeBlack] range:NSMakeRange(0, title.length)];
        [alertControllerStr addAttribute:NSFontAttributeName value:[UIConfigManager fontThemeTextImportant] range:NSMakeRange(0, title.length)];
        [alertController setValue:alertControllerStr forKey:@"attributedTitle"];
    }

    //修改message
    
    if (message) {
        NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:message];
        [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:[UIConfigManager colorTextLightGray] range:NSMakeRange(0, message.length)];
        [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIConfigManager fontThemeTextDefault] range:NSMakeRange(0, message.length)];
        [alertController setValue:alertControllerMessageStr forKey:@"attributedMessage"];
    }

    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        cancle();
    }];
    [alertController addAction:cancelAction];

    // Add the actions.
    if (titleArray.count) {
        for (int i = 0; i < titleArray.count; i++) {
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:titleArray[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                confirm(i);
            }];
            [alertController addAction:otherAction];
        }
    }

    [viewController presentViewController:alertController animated:YES completion:nil];
}

-(void)showAlertView:(UIViewController *)viewController
               title:(NSString *)title
        placeHoleder:(NSString *)placeHoleder
   cancelButtonTitle:(NSString *)cancelButtonTitle
    otherButtonTitle:(NSString *)otherButtonTitle
             confirm:(void (^)(NSString *content))confirm
              cancle:(void (^)(void))cancle
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    // 修改title
    if (title) {
        NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:title];
        [alertControllerStr addAttribute:NSForegroundColorAttributeName value:[UIConfigManager colorThemeBlack] range:NSMakeRange(0, title.length)];
        [alertControllerStr addAttribute:NSFontAttributeName value:[UIConfigManager fontThemeTextImportant] range:NSMakeRange(0, title.length)];
        [alertController setValue:alertControllerStr forKey:@"attributedTitle"];
    }
//
//    //修改message
//    if (message) {
//        NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:message];
//        [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:[UIConfigManager colorTextLightGray] range:NSMakeRange(0, message.length)];
//        [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIConfigManager fontThemeTextDefault] range:NSMakeRange(0, message.length)];
//        [alertController setValue:alertControllerMessageStr forKey:@"attributedMessage"];
//    }
    
    if (placeHoleder) {
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            textField.placeholder = placeHoleder;
        }];
    }
    
    // Create the actions.
    if (cancelButtonTitle) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            cancle();
        }];
        [alertController addAction:cancelAction];
    }
    
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        confirm(self.contentText);
    }];
    
    // Add the actions.
    [alertController addAction:otherAction];
    [viewController presentViewController:alertController animated:YES completion:nil];
}

- (void)textFieldDidChange:(UITextField *)textField
{
    self.contentText = textField.text;
}


static id _instace;
- (instancetype)init
{
    if(self = [super init]){
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            // 加载所需资源
        });
    }
    return self;
}

+ (instancetype)shareAlertTool
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [[self alloc] init];
    });
    return _instace;
}

/**
 *   重写此方法：控制内存
 */
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [super allocWithZone:zone];
    });
    return _instace;
}

+ (id)copyWithZone:(struct _NSZone *)zone
{
    return _instace;
}

@end
