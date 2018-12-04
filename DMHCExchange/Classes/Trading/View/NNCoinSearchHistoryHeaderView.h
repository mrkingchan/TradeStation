//
//  NNCoinSearchHistoryHeaderView.h
//  DMHCExchange
//
//  Created by 牛牛 on 2018/11/6.
//  Copyright © 2018年 超级钱包. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NNCoinSearchHistoryHeaderView : UITableViewHeaderFooterView

/** 清空历史搜索block */
@property (nonatomic, copy) void(^removeAllOperationBlock)(void);

@end
