//
//  NNHProjectControlCenter.h
//  ElegantTrade
//
//  Created by 牛牛 on 16/10/19.
//  Copyright © 2016年 Smile intl. All rights reserved.
//


/*****************************************************
 
 @Author          牛牛
 
 @CreateTime      2016-10-19
 
 @Function        资料控制中心
 
 @Remarks          可以拓展
 
 @当前控制中心功能:
 
 1. 登录用户资料管理
 
 2. 项目状态，控制中心等
 
 
 @扩展方法:
 1. NNHControlDelegate 中设计接口
 2. 在本类中遵循该协议
 3. 新创建文件夹，创建实现接口的Model
 
 @调用方法:
 1. 保存当前用户资料到文件
 [[NNHProjectControlCenter sharedControlCenter] userControl_archiveCurrentUserToDisk];
 
 2. Bool isTestMode = [[NNHProjectControlCenter sharedControlCenter] Config_isTestMode];
 
 *****************************************************/

#import <Foundation/Foundation.h>
#import "NNHControlDelegate.h"
#import "NNHUserControl.h"
#import "NNHProjectConfig.h"

@interface NNHProjectControlCenter : NSObject <
    NNHProjectConfigProtocol, //用户资料管理
    NNHLoginUserControlProcotol //项目配置
>

//LoginUserControl
@property (nonatomic, strong) NNHUserControl *userControl;
//Projectconfig
@property (nonatomic, strong) NNHProjectConfig *proConfig;

+ (instancetype)sharedControlCenter;

@end
