//
//  NNHUserControl.m
//  ElegantTrade
//
//  Created by 牛牛 on 16/10/19.
//  Copyright © 2016年 Smile intl. All rights reserved.
//

#import "NNHUserControl.h"

@interface NNHUserControl ()

/** 当前登录用户**/
@property (nonatomic, strong) NNUserModel *currentUserModel;
/** 保存用户资料的文件夹 **/
@property (nonatomic, strong) NSString *fileDire;
/** 保存当前用户资料的文件路径 **/
@property (nonatomic, strong) NSString *currentUserFilePath;
/** 上次登录的手机号码 **/
@property (nonatomic, strong) NSString *lastLoginToken;

@end

static NSString *const user_mtoken = @"user_mtoken";
@implementation NNHUserControl

#pragma mark -
#pragma mark ---------PublicMethods
/** 登录成功之后调用，保存用户令牌 **/
- (void)saveUserDataWithUserInfo:(NNUserModel *)userModel
{
    if (userModel == nil) return;
    
    _currentUserModel = userModel;
    [[NSUserDefaults standardUserDefaults] setObject:userModel.mtoken forKey:user_mtoken];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self archiveCurrentUserToDisk];
}

/** 补全账户信息存入本地 **/
- (void)completionUserModelWithDictionAry:(NSDictionary *)dic
{
    self.currentUserModel.mobile = dic[@"mobile"];
    
    [self archiveCurrentUserToDisk];
}

/** 把当前内存中已经登录的用户资料保存硬盘 **/
- (void)archiveCurrentUserToDisk
{
    if (self.currentUserModel == nil) return;
    
    //删除之前的file
    [self removeUserFileBymtoken:self.currentUserModel.mtoken];
    
    //把新的文件写入
    [NSKeyedArchiver archiveRootObject:self.currentUserModel toFile:self.currentUserFilePath];
}


/** 删除本次登录用户文件 不是注销的时候不要调用 **/
- (void)removeCurrentLoginUserFile
{
    [self removeUserFileBymtoken:self.currentUserModel.mtoken];
}

/** 加载上次登录的用户信息 **/
- (NNUserModel *)loadLastLoginModelFromFile
{
    _lastLoginToken = [[NSUserDefaults standardUserDefaults] objectForKey:user_mtoken];
    
    // 检测用户令牌是否存在
    if (_lastLoginToken == nil || _lastLoginToken.length == 0){
        NNUserModel *model = [NNUserModel new];
        model.mtoken = @"";
        return model;
    }
    
    // 检测是否存在用户文件
    BOOL fileExist = [self fileExistsForUsermToken:_lastLoginToken];
    if (fileExist == NO) {
        NNUserModel *model = [NNUserModel new];
        model.mtoken = @"";
        return model;
    }
    
    NSString *filePath = [self filePahForUserMtoken:_lastLoginToken];
    NNUserModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    return model;
}

- (BOOL)isLoginIn
{
    self.currentUserModel = [self loadLastLoginModelFromFile];
    if (![NSString isEmptyString:self.currentUserModel.mtoken]) {
        return YES;
    }
    return NO;
}

- (void)logOut
{
    [self removeCurrentLoginUserFile];
    self.currentUserModel.mtoken = @"";
}

#pragma mark -
#pragma mark ---------PrivateMethods
- (void)removeUserFileBymtoken:(NSString *)mtoken
{
    if (mtoken == nil ) {
        return;
    }
    
    NSString *fileToDelete = [self filePahForUserMtoken:mtoken];
    
    if (fileToDelete == nil) {
        return;
    }
    
    // 检测文件是否存在
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:fileToDelete];
    
    if (isExist) {
        NSError *deleteError  = nil;
        [[NSFileManager defaultManager] removeItemAtPath:fileToDelete error:&deleteError];
        if (deleteError) {
            NNHLog(@"Fail to delete : %@", deleteError);
        }
    }else{
        NNHLog(@"dele Suc !!");
    }
}

/*!
 @method
 @brief      是否存在该用户的记录文件
 */
- (BOOL)fileExistsForUsermToken:(NSString *)mToken
{
    if (mToken == nil || mToken.length == 0) {
        return NO;
    }
    
    NSString *filePath = [self filePahForUserMtoken:mToken];
    
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    
}

#pragma mark -
#pragma mark ---------文件操作
- (NSString *)fileDire
{
    if (![[NSFileManager defaultManager]fileExistsAtPath:[[self akext_docutmentDirePath] stringByAppendingPathComponent:@"loggedUserFiles"]]) {
        // 创建目录
        [[NSFileManager defaultManager]createDirectoryAtPath:[[self akext_docutmentDirePath] stringByAppendingPathComponent:@"loggedUserFiles"] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return [[self akext_docutmentDirePath] stringByAppendingPathComponent:@"loggedUserFiles"];
}

- (NSString *)currentUserFilePath
{
    if (self.currentUserModel == nil || self.currentUserModel.mtoken == nil || self.currentUserModel.mtoken.length == 0 ) return nil;
    
    NSString *filePath = [self filePahForUserMtoken:self.currentUserModel.mtoken];
    _currentUserFilePath = filePath;
    NNHLog(@"Current user file path =  %@", filePath);
    return _currentUserFilePath;
}

- (NSString *)filePahForUserMtoken:(NSString *)mToken
{
    if (mToken == nil || mToken.length == 0) return nil;
    return [self.fileDire stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",mToken]];
}

/**
 *  返回沙盒Document文件夹路径
 *
 *  @return 格式"~~~~/document/"
 */
- (NSString *)akext_docutmentDirePath
{
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
}

#pragma mark --------PropertyList
- (NNUserModel *)currentUserModel
{
    if (_currentUserModel == nil) {
        _currentUserModel = [self loadLastLoginModelFromFile];
    }
    return _currentUserModel;
}

@end
