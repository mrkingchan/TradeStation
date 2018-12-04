//
//  UIView+NNHExtension.m
//  ElegantTrade
//
//  Created by 牛牛 on 16/10/19.
//  Copyright © 2016年 牛牛汇. All rights reserved.
//

#import "UIView+NNHExtension.h"

@implementation UIView (NNHExtension)

- (void)setNnh_height:(CGFloat)nnh_height
{
    CGRect rect = self.frame;
    rect.size.height = nnh_height;
    self.frame = rect;
}

- (CGFloat)nnh_height
{
    return self.frame.size.height;
}

- (CGFloat)nnh_width
{
    return self.frame.size.width;
}

- (void)setNnh_width:(CGFloat)nnh_width
{
    CGRect rect = self.frame;
    rect.size.width = nnh_width;
    self.frame = rect;
}

- (void)setNnh_size:(CGSize)nnh_size
{
    CGRect frame = self.frame;
    frame.size = nnh_size;
    self.frame = frame;
}

- (CGSize)nnh_size
{
    return self.frame.size;
}

- (CGFloat)nnh_x
{
    return self.frame.origin.x;
}

- (void)setNnh_x:(CGFloat)nnh_x
{
    CGRect rect = self.frame;
    rect.origin.x = nnh_x;
    self.frame = rect;
}

- (void)setNnh_y:(CGFloat)nnh_y
{
    CGRect rect = self.frame;
    rect.origin.y = nnh_y;
    self.frame = rect;
}

- (CGFloat)nnh_y
{
    return self.frame.origin.y;
}

- (void)setNnh_centerX:(CGFloat)nnh_centerX
{
    CGPoint center = self.center;
    center.x = nnh_centerX;
    self.center = center;
}

- (CGFloat)nnh_centerX
{
    return self.center.x;
}

- (void)setNnh_centerY:(CGFloat)nnh_centerY
{
    CGPoint center = self.center;
    center.y = nnh_centerY;
    self.center = center;
}

- (CGFloat)nnh_centerY
{
    return self.center.y;
}

- (void)setNnh_origin:(CGPoint)nnh_origin{
    CGRect frame = self.frame;
    frame.origin = nnh_origin;
    self.frame = frame;
}
- (CGPoint)nnh_origin {
    return self.frame.origin;
}

+ (instancetype)viewFromXib
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

+ (UITableView *)nnhTableViewPlain
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.backgroundColor = [UIConfigManager colorThemeColorForVCBackground];
    tableView.separatorColor = [UIConfigManager colorThemeSeperatorLightGray];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorInset = UIEdgeInsetsZero;
    tableView.tableFooterView = [UIView new];
    return tableView;
}

+ (UITableView *)nnhTableViewGroup
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIConfigManager colorThemeColorForVCBackground];
    tableView.separatorColor = [UIConfigManager colorThemeSeperatorLightGray];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorInset = UIEdgeInsetsZero;
    if (UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11.0")) {
        tableView.estimatedRowHeight = 0.0;
        tableView.estimatedSectionFooterHeight = 0.0;
        tableView.estimatedSectionHeaderHeight = 0.0;
    }
    return tableView;
}

/** 创建下拉菜单内容view  **/
+ (UITableView *)nnhMenuTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.rowHeight = 40;
    tableView.separatorColor = [UIColor whiteColor];
    tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.showsVerticalScrollIndicator = NO;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    return tableView;
}

/** 创建横线view  **/
+ (UIView *)lineView
{
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIConfigManager colorThemeSeperatorLightGray];
    return lineView;
}

+ (UIWindow *)currentWindow
{
    UIWindow *currentWindow = [UIApplication sharedApplication].keyWindow;
    return currentWindow;
}

@end
