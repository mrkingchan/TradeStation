//
//  NNHBankCardAddCell.h
//  NNCivetCat
//
//  Created by 来旭磊 on 17/3/30.
//  Copyright © 2017年 灵猫. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NNHBankCardItem;


@interface NNHAddBankCardCell : UITableViewCell

/** <#注释#> */
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
/** <#注释#> */
@property (nonatomic, strong) NNHBankCardItem *cardCellItem;
/** <#注释#> */
@property (nonatomic, copy) void(^didChangedTextFieldBlock)(NSString *text, NSIndexPath *index);

@end
