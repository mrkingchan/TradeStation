//
//  NNTradeDetailView.m
//  DMHCExchange
//
//  Created by 云笈 on 2018/10/26.
//  Copyright © 2018年 超级钱包. All rights reserved.
//

#import "NNTradeDetailView.h"
#import "NNCustomLabel.h"

#define kAppTextColor   [UIColor akext_colorWithHex:@"#637794"]
@interface NNTradeDetailView()

@property (nonatomic, strong) UILabel *currentPrice;

@property (nonatomic, strong) NNCustomLabel  *priceRate;

@property (nonatomic, strong) UILabel *dealCount;

@property (nonatomic, strong) UILabel *open;

@property (nonatomic, strong) UILabel *high;

@property (nonatomic, strong) UILabel *recieve;

@property (nonatomic, strong) UILabel *low;

@property (nonatomic, strong) UIImageView *priceUpDownTip;


@end

@implementation NNTradeDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor =[UIColor colorWithRed:21/255.0 green:31/255.0 blue:47/255.0 alpha:1.0];
        [self setUpChildViews];
    }
    return self;
}

- (void)setUpChildViews {
    //当前价格
    [self addSubview:self.currentPrice];
    [_currentPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.mas_top).offset(15);
    }];
    
    [self addSubview:self.priceUpDownTip];
    [_priceUpDownTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_currentPrice.mas_right).offset(10);
        make.top.equalTo(_currentPrice.mas_top).offset(5);
        make.height.equalTo(@16);
        make.width.equalTo(@10);
    }];
    
    //涨幅
    [self addSubview:self.priceRate];
    [_priceRate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_currentPrice);
        make.top.equalTo(_currentPrice.mas_bottom).offset(15);
        make.height.equalTo(@15);
        make.width.equalTo(@45);
    }];
    
    //成交量
    
    [self addSubview:self.dealCount];
    [_dealCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_priceRate.mas_right).offset(8);
        make.centerY.equalTo(_priceRate);
    }];
    
    NSArray *titles = @[@"开",@"高",@"低",@"收"];
    UILabel *preLabel = nil;
    for (int i = 0; i < 4; i ++) {
        UILabel *label = [UILabel NNHWithTitle:titles[i]
                                    titleColor:kAppTextColor font:[UIFont systemFontOfSize:12]];
        [self addSubview:label];
        if (preLabel == nil) {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.mas_top).offset(12);
                make.height.width.equalTo(@15);
                make.left.equalTo(self.mas_centerX).offset(50);
            }];
            
        } else {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(preLabel.mas_bottom).offset(5);
                make.height.width.equalTo(@15);
                make.left.equalTo(self.mas_centerX).offset(50);
            }];
        }
        preLabel = label;
    }
    
    //开
    [self addSubview:self.open];
    [self.open
     mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-NNHMargin_10);
        make.left.equalTo(preLabel.mas_right);
        make.height.equalTo(@15);
        make.top.equalTo(self.mas_top).offset(12);
    }];
    
    //高
    [self addSubview:self.high];
    [self.high mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.open);
        make.left.equalTo(preLabel.mas_right);
        make.height.equalTo(@15);
        make.top.equalTo(self.open.mas_bottom).offset(5);
    }];
    
    //低
    [self addSubview:self.low];
    [self.low mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.open);
        make.left.equalTo(preLabel.mas_right);
        make.height.equalTo(@15);
        make.top.equalTo(self.high.mas_bottom).offset(5);
    }];
    
    //收
    [self addSubview:self.recieve];
    [self.recieve mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.open);
        make.left.equalTo(preLabel.mas_right);
        make.height.equalTo(@15);
        make.top.equalTo(self.low.mas_bottom).offset(5);
    }];
}

#pragma mark - private Method
- (void)refreshWithData:(NSDictionary *)dic {
    NSParameterAssert(dic);
    _currentPrice.text = dic[@"new_price"];
    _low.text = dic[@"min_price"];
    _high.text = dic[@"max_price"];
    _dealCount.text = [NSString stringWithFormat:@"≈%@CNY",dic[@"qc_price"]];
    _priceRate.text = dic[@"changestr"];
    _open.text = dic[@"open_price"];
    _recieve.text = dic[@"new_price"];
    if ([dic[@"changestr"] containsString:@"-"]) {
        //下跌
        _priceRate.backgroundColor =  _currentPrice.textColor = [UIConfigManager colorThemeRed];
        _priceUpDownTip.image = [UIImage imageNamed:@"ic_kline_price_down"];
    }else {
        //上涨
        _priceRate.backgroundColor = _currentPrice.textColor = [UIColor akext_colorWithHex:@"#3fbe27"];
        _priceUpDownTip.image = [UIImage imageNamed:@"ic_kline_price_up"];
    }
}

#pragma mark - lazy Load

- (UILabel *)currentPrice{
    if (!_currentPrice) {
        _currentPrice = [UILabel NNHWithTitle:@""
                                   titleColor:[UIColor akext_colorWithHex:@"#3fbe72"] font:[UIFont boldSystemFontOfSize:20]];
        _currentPrice.textAlignment = 0;
    }
    return _currentPrice;
}

- (UIImageView *)priceUpDownTip {
    if (!_priceUpDownTip) {
        _priceUpDownTip = [UIImageView new];
    }
    return _priceUpDownTip;
}

- (NNCustomLabel *)priceRate{
    if (!_priceRate) {
        _priceRate =  [[NNCustomLabel alloc] initWithFrame:CGRectZero];
        _priceRate.textColor = [UIColor whiteColor];
        _priceRate.font = [UIFont systemFontOfSize:10];
        _priceRate.backgroundColor =[UIColor colorWithRed:102/255.0 green:187/255.0 blue:121/255.0 alpha:1.0];
        _priceRate.textAlignment = 1;
    }
    return _priceRate;
}

- (UILabel *)dealCount{
    if (!_dealCount) {
        _dealCount = [UILabel NNHWithTitle:@""
                                titleColor:kAppTextColor font:[UIFont systemFontOfSize:14]];
        _dealCount.textAlignment= 2;
    }
    return _dealCount;
}

//开 高 低 收
- (UILabel *)open{
    if (!_open) {
        _open = [UILabel NNHWithTitle:@""
                           titleColor:kAppTextColor font:[UIFont systemFontOfSize:12]];
        _open.textAlignment = 2;
    }
    return _open;
}

- (UILabel *)high{
    if (!_high) {
        _high = [UILabel NNHWithTitle:@""
                           titleColor:kAppTextColor font:[UIFont systemFontOfSize:12]];
        _high.textAlignment = 2;
    }
    return _high;
}

- (UILabel *)low{
    if (!_low) {
        _low = [UILabel NNHWithTitle:@""
                           titleColor:kAppTextColor font:[UIFont systemFontOfSize:12]];
        _low.textAlignment = 2;
    }
    return _low;
}

- (UILabel *)recieve{
    if (!_recieve) {
        _recieve = [UILabel NNHWithTitle:@""
                           titleColor:kAppTextColor font:[UIFont systemFontOfSize:12]];
        _recieve.textAlignment = 2;
    }
    return _recieve;
}


@end
