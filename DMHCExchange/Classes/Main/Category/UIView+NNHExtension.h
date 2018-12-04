//
//  UIView+NNHExtension.h
//  ElegantTrade
//
//  Created by 牛牛 on 16/10/19.
//  Copyright © 2016年 牛牛汇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (NNHExtension)

@property (nonatomic, assign) CGFloat nnh_width;
@property (nonatomic, assign) CGFloat nnh_height;
@property (nonatomic, assign) CGSize  nnh_size;
@property (nonatomic, assign) CGFloat nnh_x;
@property (nonatomic, assign) CGFloat nnh_y;
@property (nonatomic, assign) CGFloat nnh_centerX;
@property (nonatomic, assign) CGFloat nnh_centerY;
@property (nonatomic, assign) CGPoint nnh_origin;

+ (instancetype)viewFromXib;

/** TableView :UITableViewStylePlain  **/
+ (UITableView *)nnhTableViewPlain;

/** TableView :UITableViewStyleGroup  **/
+ (UITableView *)nnhTableViewGroup;

/** 创建下拉菜单内容view  **/
+ (UITableView *)nnhMenuTableView;

/** 创建横线view  **/
+ (UIView *)lineView;

/** 获取最上面的窗口  **/
+ (UIWindow *)currentWindow;

@end
