//
//  NNWalletPropertyRecordCell.h
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/24.
//  Copyright © 2018 超级钱包. All rights reserved.
//

/*****************************************************
 
 @Author             来旭磊
 
 @CreateTime      TimeForever
 
 @ function           账单页面 cell
 
 @Remarks          <#注释#>
 
 *****************************************************/

#import <UIKit/UIKit.h>
@class NNWalletPropertyRecordModel;

NS_ASSUME_NONNULL_BEGIN

@interface NNWalletPropertyRecordCell : UITableViewCell

/** 记录模型 */
@property (nonatomic, strong) NNWalletPropertyRecordModel *recordModel;

@end

NS_ASSUME_NONNULL_END
