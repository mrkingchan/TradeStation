//
//  NNHBankCardItem.h
//  NNCivetCat
//
//  Created by 来旭磊 on 17/3/30.
//  Copyright © 2017年 灵猫. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NNHBankCardItem : NSObject

/** 标题 */
@property (nonatomic, copy) NSString *itemName;
/** textField内容 */
@property (nonatomic, copy) NSString *itemText;
/** textField PlaceHolder */
@property (nonatomic, copy) NSString *itemPlaceHolder;
/** 箭头内容 */
@property (nonatomic, copy) NSString *itemRightText;
/** 不能编辑 默认为no */
@property (nonatomic, assign) BOOL noneEdit;
/** 是否有箭头 */
@property (nonatomic, assign) BOOL hasArrow;

+ (instancetype)itemWithName:(NSString *)name itemPlaceHolder:(NSString *)placeHolder;

+ (instancetype)itemWithName:(NSString *)name itemRightText:(NSString *)rightText;

@end
