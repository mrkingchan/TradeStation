//
//  NNHbankCardCell.h
//  NNCivetCat
//
//  Created by 来旭磊 on 17/3/28.
//  Copyright © 2017年 灵猫. All rights reserved.
//

/*****************************************************
 
 @Author             来旭磊
 
 @CreateTime      TimeForever
 
 @ function           银行卡cell
 
 @Remarks          <#注释#>
 
 *****************************************************/

#import <UIKit/UIKit.h>
@class NNHBankCardModel;
@interface NNHBankCardCell : UITableViewCell

/** 选中按钮 */
@property (nonatomic, strong) UIButton *selectButton;
/** <#注释#> */
@property (nonatomic, strong) NNHBankCardModel *cardModel;
@end
