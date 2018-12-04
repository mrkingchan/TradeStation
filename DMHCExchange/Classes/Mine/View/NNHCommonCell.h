//
//  NNHCommonCell.h
//  NNHPlatform
//
//  Created by 牛牛 on 2017/2/28.
//  Copyright © 2017年 Smile intl. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NNHMyItem;

@interface NNHCommonCell : UITableViewCell

/** cell数据模型 **/
@property (nonatomic, strong) NNHMyItem *myItem;

@end
