//
//  NNHBankCardModel.m
//  NNCivetCat
//
//  Created by 来旭磊 on 17/3/30.
//  Copyright © 2017年 灵猫. All rights reserved.
//

#import "NNHBankCardModel.h"
#import "NNHBankConfigModel.h"
#import "UIColor+NNHExtension.h"

@interface NNHBankCardModel ()

/** <#注释#> */
@property (nonatomic, strong) NSArray <NNHBankConfigModel *>*banksArray;

@end

@implementation NNHBankCardModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"cardID"          : @"id",
             @"cardBankName"    : @"bank_name",
             @"cardType"        : @"account_type",
             @"cardNum"         : @"account_number",
             };
}

- (UIColor *)backColor
{
    if (_backColor == nil) {
        NNHWeakSelf(self)
        [self.banksArray enumerateObjectsUsingBlock:^(NNHBankConfigModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.bankName containsString:weakself.cardBankName]) {
                _backColor = [UIColor akext_colorWithHex:obj.bankColor];
                *stop = YES;
            }
        }];
    }
    return _backColor;
}

- (NSArray *)banksArray
{
    if (_banksArray == nil) {
        NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"NNHBankCardColors" ofType:@"plist"]];
        _banksArray = [NNHBankConfigModel mj_objectArrayWithKeyValuesArray:array];
    }
    return _banksArray;
}

- (NSString *)tailNumber
{
    if (_tailNumber == nil) {
        if (_cardNum.length > 4) {
            _tailNumber = [_cardNum substringFromIndex:_cardNum.length - 4];
        }else {
            _tailNumber = _cardNum;
        }
    
    }
    return _tailNumber;
}

@end
