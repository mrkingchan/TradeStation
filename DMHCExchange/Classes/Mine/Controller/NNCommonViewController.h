//
//  NNHCommonViewController.h
//  NNHPlatform
//
//  Created by 牛牛 on 2017/2/28.
//  Copyright © 2017年 Smile intl. All rights reserved.
//
/*****************************************************
 
 @Author          牛牛
 
 @CreateTime      2016-10-19
 
 @Function        静态单元格父类
 
 @Remarks
 
 *****************************************************/

#import "NNTableViewController.h"
#import "NNHMyGroup.h"
#import "NNHMyItem.h"

@interface NNCommonViewController : NNTableViewController

/** 数据源 */
@property (nonatomic, strong) NSMutableArray *groups;

@end
