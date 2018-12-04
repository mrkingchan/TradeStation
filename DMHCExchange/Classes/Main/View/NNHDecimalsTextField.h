//
//  NNHDecimalsTextField.h
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/11/6.
//  Copyright © 2018 超级钱包. All rights reserved.
//

/*****************************************************
 
 @Author             来旭磊
 
 @CreateTime      TimeForever
 
 @ function           用来输入小数的 textField
 
 @Remarks          vc
 
 *****************************************************/

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol NNHDecimalsTextFieldDelegate <NSObject>

@optional

- (BOOL)nnh_textFieldShouldBeginEditing:(UITextField *)textField;        // return NO to disallow editing.
- (void)nnh_textFieldDidBeginEditing:(UITextField *)textField;           // became first responder
- (BOOL)nnh_textFieldShouldEndEditing:(UITextField *)textField;          // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
- (void)nnh_textFieldDidEndEditing:(UITextField *)textField;             // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
- (void)nnh_textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason NS_AVAILABLE_IOS(10_0); // if implemented, called in place of textFieldDidEndEditing:

- (BOOL)nnh_textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   // return NO to not change text

- (BOOL)nnh_textFieldShouldClear:(UITextField *)textField;               // called when clear button pressed. return NO to ignore (no notifications)
- (BOOL)nnh_textFieldShouldReturn:(UITextField *)textField;              // called when 'return' key pressed. return NO to ignore.

@end

@interface NNHDecimalsTextField : UITextField

@property (nonatomic, assign) id<NNHDecimalsTextFieldDelegate> nnhDelegate;

/** 小数点前位数 默认9位 */
@property (nonatomic, assign) NSInteger frontPlacesCount;

/** 小数点后位数 默认2位 */
@property (nonatomic, assign) NSInteger afterPlacesCount;

@end

NS_ASSUME_NONNULL_END
