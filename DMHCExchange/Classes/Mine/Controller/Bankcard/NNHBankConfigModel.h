//
//  NNHBankConfigModel.h
//  NNCivetCat
//
//  Created by 来旭磊 on 17/3/31.
//  Copyright © 2017年 灵猫. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NNHBankConfigModel : NSObject

/** 银行名称 */
@property (nonatomic, copy) NSString *bankName;
/** 银行卡背景色 */
@property (nonatomic, copy) NSString *bankColor;
/** 银行icon */
@property (nonatomic, copy) NSString *bankImage;

@end
