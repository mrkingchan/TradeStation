//
//  NNPriceVolumeView.m
//  DMHCExchange
//
//  Created by 云笈 on 2018/11/7.
//  Copyright © 2018年 超级钱包. All rights reserved.
//

#import "NNPriceVolumeView.h"
@interface NNPriceVolumeView () {
    UILabel *_time;
    UILabel *_high;
    UILabel *_open;
    UILabel *_low;
    UILabel *_recieve;
    UILabel *_upDownPrice;
    UILabel *_upDownRate;
    NSDateFormatter *_formater;
}
@end

@implementation NNPriceVolumeView


-(instancetype)init {
    if (self = [super init]) {
        self.backgroundColor =  [UIColor akext_colorWithHex:@"#131f30"];
        self.layer.borderColor = [UIColor akext_colorWithHex:@"#637794"].CGColor;
        self.layer.borderWidth = 0.5;
        [self setUpChildViews];
        _formater = [NSDateFormatter new];
        [_formater setDateFormat:@"yy-MM-dd"];
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 3.0;
    }
    return self;
}

- (void)setUpChildViews {
    NSArray *titles = @[@"时间",@"开",@"高",@"低",@"收",@"涨跌额",@"涨跌幅"];
    UILabel *preLabel = nil;
    for (int i = 0 ; i < titles.count; i ++) {
        UILabel *label = [UILabel NNHWithTitle:titles[i] titleColor:[UIColor  whiteColor] font:[UIFont systemFontOfSize:10]];
        label.textAlignment = 0;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(8);
            if (preLabel) {
                make.top.equalTo(preLabel.mas_bottom).offset(5);
            } else {
                make.top.equalTo(self.mas_top).offset(5);
            }
            make.height.equalTo(@15);
        }];
        preLabel = label;
    }
    
    _time = [self private_createLabel];
    _open = [self private_createLabel];
    _high = [self private_createLabel];
    _low = [self private_createLabel];
    _recieve = [self private_createLabel];
    _upDownRate = [self private_createLabel];
    _upDownPrice = [self private_createLabel];
    
    //时间
    [_time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-3);
        make.height.equalTo(@15);
        make.top.equalTo(self.mas_top).offset(5);
    }];
    
    //开
    [_open mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-3);
        make.height.equalTo(@15);
        make.top.equalTo(_time.mas_bottom).offset(5);
    }];
    
    //高
    [_high mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-3);
        make.height.equalTo(@15);
        make.top.equalTo(_open.mas_bottom).offset(5);
    }];
    
    //低
    [_low mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-3);
        make.height.equalTo(@15);
        make.top.equalTo(_high.mas_bottom).offset(5);
    }];
    
    //收
    [_recieve mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-3);
        make.height.equalTo(@15);
        make.top.equalTo(_low.mas_bottom).offset(5);
    }];
    
    //涨跌额
    [_upDownPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-3);
        make.height.equalTo(@15);
        make.top.equalTo(_recieve.mas_bottom).offset(5);
    }];
    
    [_upDownRate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-3);
        make.height.equalTo(@15);
        make.top.equalTo(_upDownPrice.mas_bottom).offset(5);
    }];
}

- (UILabel *)private_createLabel {
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:10];
    //[UIColor akext_colorWithHex:@"#637794"];
    label.textColor = [UIColor whiteColor];
    label.lineBreakMode =  NSLineBreakByTruncatingTail;
    label.textAlignment = NSTextAlignmentRight;
    [self addSubview:label];
    return label;
}

#pragma mark - private Method
- (void)refreshWithModel:(Y_KLineModel *)model{
    NSInteger displayHM = [[[NSUserDefaults standardUserDefaults]valueForKey:@"displayHM"] integerValue];
    if (displayHM == 1) {
        [_formater  setDateFormat:@"yy-MM-dd HH:mm"];
    } else {
        [_formater  setDateFormat:@"yy-MM-dd"];
    }
    _time.text = [_formater stringFromDate:[NSDate dateWithTimeIntervalSince1970:model.Date.doubleValue]];
    _open.text = model.Open.stringValue;
    _high.text = model.High.stringValue;
    _low.text = model.Low.stringValue;
    _recieve.text = model.Close.stringValue;
    //涨跌额
    float value = model.Close.floatValue - model.Open.floatValue;
    _upDownPrice.text = [NSString stringWithFormat:@"%@%@",value <0?@"":@"+",[NSNumber numberWithFloat:value]];
    _upDownPrice.textColor = value>0 ? [UIColor akext_colorWithHex:@"#3fbe27"]:[UIConfigManager colorThemeRed];
    //涨跌幅
    
    float percentage = value / (model.Open.floatValue);
//    [NSNumber numberWithFloat:percentage]
    _upDownRate.text = [NSString stringWithFormat:@"%@%.4f%@",percentage <0?@"":@"+",percentage,@"%"];
    _upDownRate.textColor = value>0 ? [UIColor akext_colorWithHex:@"#3fbe27"]:[UIConfigManager colorThemeRed];
}

@end
