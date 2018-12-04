//
//  NNHPickerVeiw.h
//  NNHPlatform
//
//  Created by leiliao lai on 17/3/1.
//  Copyright © 2017年 牛牛汇. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PLDefaultComponentWidth 30
#define PLDefaultComponentHeight 44

@interface NNHPickerVeiw : UIView

#pragma mark -------------- require
/** 多少组 **/
@property (nonatomic, copy) NSUInteger (^numberOfComponents)(void);
/** 多少行 **/
@property (nonatomic, copy) NSUInteger (^numberOfRows)(NSInteger Components);


#pragma mark -------------UI optional pickerViewDelegate
/** 显示的行距 **/
@property (nonatomic, copy)CGFloat (^widthForComponent)(NSInteger Component);
/** 显示的高度 **/
@property (nonatomic, copy) CGFloat (^heightForComponent)(NSInteger Component);
/** 显示的文字的字体 **/
@property (nonatomic, copy) NSString *(^stringForComponentAndComponent)(NSInteger Component,NSInteger Row);


/** attributestring 返回显示的，若写了下面block，则优先 **/
//@property (nonatomic, copy) NSAttributedString *(^atttributeStringForRowAndComponent)(NSInteger Component,NSInteger Row);



/** 返回的控件reuse **/
@property (nonatomic, copy) UIView *(^viewForRowAndComponent)(NSInteger Component,NSInteger Row,UIView *resuseView);

/** 点击了其中之一 **/
@property (nonatomic, copy)void (^didSelectedRowAndComponent)(NSInteger Component,NSInteger Row);

/** 选择了控制器 **/
@property (nonatomic, copy) void (^didScrollRowAndComponent)(NSInteger Component,NSInteger Row);

/** 重载数据 **/
- (void)relaodDataWithComponent:(NSInteger)component;

- (void)reloadAllData;

/** 选择确切的某行某列 **/
- (void)selectedRow:(NSInteger)row andComponent:(NSInteger)component andAnimation:(BOOL)animation;

/** 动画展示 **/
- (void)showWithAnimation:(BOOL)animation fatherView:(UIView *)fatherView;

/** 动画消失 **/
- (void)dismissWithAnimation:(BOOL)aniamtion;

/** 输出对应的当前行 **/
- (NSInteger)selectedRowInComponent:(NSInteger)component;

@end
