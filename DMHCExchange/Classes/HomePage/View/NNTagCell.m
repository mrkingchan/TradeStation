//
//  NNTagCell.m
//  DMHCExchange
//
//  Created by 云笈 on 2018/10/26.
//  Copyright © 2018年 超级钱包. All rights reserved.
//

#import "NNTagCell.h"

@interface NNTagCell () {
    UILabel *_content;
}

@end
@implementation NNTagCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _content = [UILabel NNHWithTitle:@"" titleColor:[UIColor akext_colorWithHex:@"#637794"] font:[UIFont systemFontOfSize:13]];
        [self addSubview:_content];
        [_content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(5);
            make.bottom.equalTo(self.mas_bottom).offset(-5);
            make.left.equalTo(self.mas_left).offset(15);
            make.right.equalTo(self.mas_right).offset(-15);
        }];
        _content.textAlignment = 1;
        
    }
    return self;
}

#pragma mark - private Method
- (void)setTagContent:(NSString *)tagContent {
    _tagContent = tagContent;
    _content.text = tagContent;
}
@end
