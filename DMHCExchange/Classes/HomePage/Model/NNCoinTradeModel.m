//
//  NNCoinTradeModel.m
//  DMHCExchange
//
//  Created by 云笈 on 2018/10/24.
//  Copyright © 2018年 超级钱包. All rights reserved.
//

#import "NNCoinTradeModel.h"

@implementation NNCoinTradeModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if([key isEqualToString:@"new_price"]) {
     self.newprice = value;
    }else if ([key isEqualToString:@"id"]) {
        self.tradeId = value;
    }
}
@end
