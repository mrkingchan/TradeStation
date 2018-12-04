//
//  NNCoinSearchHelper.m
//  DMHCExchange
//
//  Created by 牛牛 on 2018/11/6.
//  Copyright © 2018年 超级钱包. All rights reserved.
//

#import "NNCoinSearchHelper.h"
#import "NNCoinSearchModel.h"

NSString * const NNHSearchLocalHistorySave_GoodsKey = @"NNHSearchLocalHistorySave_GoodsKey";
@interface NNCoinSearchHelper ()

/** 历史搜索记录数组 */
@property (nonatomic, strong) NSMutableArray <NNCoinSearchModel *> *historyArray;

@end

@implementation NNCoinSearchHelper

/** 添加一条新的搜索记录 */
- (void)addNewHistoryWithSearchModel:(NNCoinSearchModel *)model
{
    BOOL isExist = NO;
    for (NNCoinSearchModel *oldmodel in self.historyArray) {
        if ([oldmodel.marketcoinid isEqualToString:model.marketcoinid]) {
            isExist = YES;
            break;
        }
    }
    if (!isExist) {
        [self.historyArray insertObject:model atIndex:0];
    } else {
        [self.historyArray replaceObjectAtIndex:0 withObject:model];
    }
    
    // 最多就10条
    if (self.historyArray.count > 10) {
        [self.historyArray removeLastObject];
    }
    
    [self updateLocalHistoryRecord];
}

/** 删除某一行的搜索记录 */
- (void)deleteHistroySearchRecordAtIndex:(NSInteger)index
{
    [self.historyArray removeObjectAtIndex:index];
    [self updateLocalHistoryRecord];
}

/** 清空所有的历史记录 */
- (void)removeAllHistorySearchRecord
{
    [self.historyArray removeAllObjects];
    [self updateLocalHistoryRecord];
}

/** 更新本地搜索记录 */
- (void)updateLocalHistoryRecord
{
    // 要转换成不可变数组类型
    NSArray *arr = [NSArray arrayWithArray:self.historyArray];
    
    // 将类型变为NSData类型
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:arr];
    
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:NNHSearchLocalHistorySave_GoodsKey];
}

- (NSMutableArray<NNCoinSearchModel *> *)historyArray
{
    if (_historyArray == nil) {
        
        // 取出数据
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:NNHSearchLocalHistorySave_GoodsKey];
        
        // 将类型还原
        NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        _historyArray = [NSMutableArray arrayWithArray:arr];
        
    }
    
    return _historyArray;
}

@end
