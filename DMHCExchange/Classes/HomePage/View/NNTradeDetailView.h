//
//  NNTradeDetailView.h
//  DMHCExchange
//
//  Created by 云笈 on 2018/10/26.
//  Copyright © 2018年 超级钱包. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NNCoinTradeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NNTradeDetailView : UIView

- (void)refreshWithData:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
