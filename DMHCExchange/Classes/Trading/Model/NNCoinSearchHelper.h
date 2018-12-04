//
//  NNCoinSearchHelper.h
//  DMHCExchange
//
//  Created by 牛牛 on 2018/11/6.
//  Copyright © 2018年 超级钱包. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NNCoinSearchModel;

@interface NNCoinSearchHelper : NSObject

/** 历史搜索记录数组 */
@property (nonatomic, strong, readonly) NSMutableArray <NNCoinSearchModel *> *historyArray;

/** 添加一条新的搜索记录 */
- (void)addNewHistoryWithSearchModel:(NNCoinSearchModel *)model;

/** 删除某一行的搜索记录 */
- (void)deleteHistroySearchRecordAtIndex:(NSInteger)index;

/** 清空所有的历史记录 */
- (void)removeAllHistorySearchRecord;

@end
