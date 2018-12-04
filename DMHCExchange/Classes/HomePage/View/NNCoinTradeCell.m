//
//  NNCoinTradeCell.m
//  DMHCExchange
//
//  Created by 云笈 on 2018/10/24.
//  Copyright © 2018年 超级钱包. All rights reserved.
//

#import "NNCoinTradeCell.h"
@interface NNCoinTradeCell()

/*名称*/
@property (nonatomic, strong) UILabel *name;

/**最高价*/
@property (nonatomic, strong) UILabel *maxPrice;

/**最低价*/

@property (nonatomic, strong) UILabel *minPrice;

/**成交价*/

@property (nonatomic, strong) UILabel *dealPrice;

/**成交量*/

@property (nonatomic, strong) UILabel *dealCount;

/**增幅*/

@property (nonatomic, strong) UILabel *priceRate;

@end

@implementation NNCoinTradeCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - init Method
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIConfigManager colorThemeWhite];
        [self setUpChildViews];
    }
    return self;
}

#pragma mark - setUpChildViews
- (void)setUpChildViews {
    //名称
    [self.contentView addSubview:self.name];
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(NNHMargin_20);
        make.top.equalTo(self.contentView.mas_top).offset(NNHMargin_15);
//        make.height.equalTo(@30);
//        make.width.equalTo(@120);
    }];
    
    //最高价
    [self.contentView addSubview:self.maxPrice];
    [_maxPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_name);
        make.top.equalTo(_name.mas_bottom).offset(13);
//        make.height.equalTo(@45);
//        make.width.equalTo(@100);
    }];
    
    //成交价
    [self.contentView addSubview:self.dealPrice];
    [_dealPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_name);
        make.left.equalTo(_name.mas_right).offset(30);
        make.width.equalTo(@130);
        make.height.equalTo(_name);
    }];
    
    //最低价
    [self.contentView addSubview:self.minPrice];
    [self.minPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dealPrice);
        make.top.equalTo(self.maxPrice);
        make.width.equalTo(self.maxPrice);
        make.height.equalTo(self.maxPrice);
    }];
    
    //增长率
    [self.contentView addSubview:self.priceRate];
    [self.priceRate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(20);
        make.right.equalTo(self.contentView.mas_right).offset(-NNHMargin_20);
        make.width.equalTo(@75);
        make.height.equalTo(@25);
    }];
    
    //成交量
    [self.contentView addSubview:self.dealCount];
    [self.dealCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.minPrice);
        make.left.equalTo(self.priceRate);
        make.width.equalTo(self.minPrice);
        make.height.equalTo(self.minPrice);
    }];
}

#pragma mark - private Method
- (void)setModel:(NNCoinTradeModel *)model {
    NSParameterAssert(model);
    _model = model;
    _name.text = model.name;
    _dealPrice.text = model.newprice;
    NSString *minPriceStr = [NSString stringWithFormat:@"最低价\n%@",model.min_price];
    NSString *maxPriceStr = [NSString stringWithFormat:@"最高价\n%@",model.max_price];
    NSString *dealCountStr = [NSString stringWithFormat:@"日成交量\n%@",model.volume];
    if ([model.change floatValue] <0) {
        _priceRate.backgroundColor = [UIColor colorWithRed:221/255.0 green:61/255.0 blue:54/255.0 alpha:1.0];
    } else {
        _priceRate.backgroundColor = [UIColor colorWithRed:102/255.0 green:187/255.0 blue:121/255.0 alpha:1.0];;
    }
    _priceRate.text = [NSString stringWithFormat:@"%@",model.changestr];
    
    
    for (int i = 0 ; i < 3; i ++) {
        NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString: i == 0 ?maxPriceStr:i == 1 ? minPriceStr :dealCountStr];
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:6];
        [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, i ==0 ?  [maxPriceStr length]: i == 1? [minPriceStr length]:[dealCountStr length])];
        if (i == 0 ) {
            [_maxPrice setAttributedText:attributedString1];
            [_maxPrice sizeToFit];
        } else if (i == 1 ) {
            [_minPrice setAttributedText:attributedString1];
            [_minPrice sizeToFit];
        } else if ( i == 2 ) {
            [_dealCount setAttributedText:attributedString1];
            [_dealCount sizeToFit];
        }
    }
}

#pragma mark - lazy Load

#define kLightGrayColor [UIColor akext_colorWithHex:@"#999999"]
- (UILabel *)name{
    if (!_name) {
        _name = [UILabel NNHWithTitle:@""
                           titleColor:[UIColor akext_colorWithHex:@"#333333"] font:[UIFont  boldSystemFontOfSize:16]];
        _name.backgroundColor = [UIColor whiteColor];
    }
    return _name;
}

- (UILabel *)minPrice{
    if (!_minPrice) {
        _minPrice = [UILabel NNHWithTitle:@""
                               titleColor:kLightGrayColor font:[UIFont  systemFontOfSize:12]];
        _minPrice.backgroundColor = [UIColor whiteColor];
        _minPrice.numberOfLines = 0;
    }
    return _minPrice;
}

- (UILabel *)maxPrice{
    if (!_maxPrice) {
        _maxPrice = [UILabel NNHWithTitle:@""
                               titleColor:kLightGrayColor font:[UIFont systemFontOfSize:12]];
        _maxPrice.backgroundColor = [UIColor whiteColor];
        _maxPrice.numberOfLines = 0;
    }
    return _maxPrice;
}

- (UILabel *)dealCount{
    if (!_dealCount) {
        _dealCount = [UILabel NNHWithTitle:@""
                               titleColor:kLightGrayColor font:[UIFont systemFontOfSize:12]];
        _dealCount.backgroundColor = [UIColor whiteColor];
        _dealCount.numberOfLines = 0;
    }
    return _dealCount;
}

- (UILabel *)dealPrice{
    if (!_dealPrice) {
        _dealPrice = [UILabel NNHWithTitle:@""
                                titleColor:[UIColor akext_colorWithHex:@"#333333"] font:[UIFont boldSystemFontOfSize:15]];
        _dealPrice.backgroundColor = [UIColor whiteColor];
    }
    return _dealPrice;
}


- (UILabel *)priceRate{
    if (!_priceRate) {
        _priceRate =[UILabel NNHWithTitle:@""
                               titleColor:[UIColor whiteColor] font:[UIFont boldSystemFontOfSize:13]];
        _priceRate.textAlignment = 1;
    }
    return _priceRate;
}
@end
