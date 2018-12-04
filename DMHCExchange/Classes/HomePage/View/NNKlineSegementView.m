//
//  NNKlineSegementView.m
//  DMHCExchange
//
//  Created by 云笈 on 2018/10/26.
//  Copyright © 2018年 超级钱包. All rights reserved.
//

#import "NNKlineSegementView.h"

@interface NNKlineSegementView () {
    NSArray *_titleArray;
    NSMutableArray <UIButton *> * _buttons;
    UIView *_line;
}

@end
@implementation NNKlineSegementView

+ (instancetype)nKlineSegementViewWithArray:(NSArray *)titleArray complete:(void (^)(NSInteger))complete {
    return [[NNKlineSegementView alloc]initWithArray:titleArray complete:complete];
}

- (instancetype)initWithArray:(NSArray *)titleArray complete:(void (^)(NSInteger))complete {
    if (self = [super initWithFrame:CGRectZero]) {
        NSParameterAssert(titleArray.count);
        _titleArray = titleArray;
        _complete = complete;
        _buttons = [NSMutableArray new];
        [self setUpChildViews];
    }
    return self;
}

#pragma mark - setUpChildViews
- (void)setUpChildViews {
    CGFloat itemW = SCREEN_WIDTH / _titleArray.count;
    for (int i = 0; i < _titleArray.count ; i ++) {
        UIView   *subView = [UIView new];
        [self addSubview:subView];
        [subView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.width.equalTo(@(itemW));
            make.left.equalTo(self.mas_left).offset(i * itemW);
        }];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor akext_colorWithHex:@"#131f30"];
        [button setTitle:_titleArray[i] forState:UIControlStateNormal];
        [button setTitle:_titleArray[i] forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        button.titleLabel.textAlignment = 1;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor akext_colorWithHex:@"#637794"] forState:UIControlStateNormal];
        button.tag = 20001  + i;
        [subView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(subView);
            make.width.equalTo(subView);
            make.left.equalTo(subView);
        }];
        [_buttons addObject:button];
    }
    _line = [[UIView alloc] initWithFrame:CGRectMake(-35,43.5 , 35, 1.5)];
    _line.backgroundColor = [UIColor akext_colorWithHex:@"#f0252a"];
    [self addSubview:_line];
}

- (void)setSelectedIndex:(NSInteger)index {
    [self buttonAction:_buttons[index]];
}

#pragma mark - private Method
- (void)buttonAction:(UIButton *)button {
    NSUInteger index = button.tag - 20001;
    [((UIButton*)_buttons[index]) setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_buttons enumerateObjectsUsingBlock:^(UIButton * _Nonnull btn, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx==index) {
            [btn setTitleColor:[UIColor akext_colorWithHex:@"#f0252a"] forState:UIControlStateNormal];
        } else {
            [btn setTitleColor:[UIColor akext_colorWithHex:@"#637794"] forState:UIControlStateNormal];
        }
    }];
    
    CGFloat itemW = SCREEN_WIDTH/_titleArray.count;
    [UIView animateWithDuration:0.3 animations:^{
        _line.frame =  CGRectMake(index * itemW + (itemW/2.0 - 17.5),43.5 , 35
                                  , 1.5);
    }];
    if (_complete) {
        _complete(index);
    }
}

#pragma mark - private Method
- (void)replaceTagWithContent:(NSString *)contentStr index:(NSInteger)index {
    for (int i = 0; i< _buttons.count; i ++) {
        if (i == index) {
            [((UIButton *)_buttons[i]) setTitle:contentStr forState:UIControlStateNormal];
            [((UIButton *)_buttons[i]) setTitleColor:[UIColor akext_colorWithHex:@"#f0252a"] forState:UIControlStateNormal];
        } else  {
            [((UIButton *)_buttons[i]) setTitleColor:[UIColor akext_colorWithHex:@"#637794"] forState:UIControlStateNormal];
        }
    }
}
@end
