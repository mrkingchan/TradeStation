//
//  NNTextField.m
//  SuperWallet
//
//  Created by 牛牛 on 2018/3/16.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import "NNTextField.h"

@interface NNTextField ()

@end

@implementation NNTextField

- (instancetype)init
{
    if (self = [super init]){
        self.backgroundColor = [UIColor whiteColor];
        self.textColor = [UIConfigManager colorThemeDark];
        self.font = [UIConfigManager fontThemeTextDefault];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor whiteColor];
        self.textColor = [UIConfigManager colorThemeDark];
        self.font = [UIConfigManager fontThemeTextDefault];
    }
    return self;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    [super setPlaceholder:placeholder];
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName:[UIConfigManager colorTextLightGray],}];
}

@end
