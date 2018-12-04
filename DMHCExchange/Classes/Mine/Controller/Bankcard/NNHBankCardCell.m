//
//  NNHbankCardCell.m
//  NNCivetCat
//
//  Created by 来旭磊 on 17/3/28.
//  Copyright © 2017年 灵猫. All rights reserved.
//

#import "NNHBankCardCell.h"
#import "NNHBankCardModel.h"
#import "UIColor+NNHExtension.h"

@interface NNHBankCardCell ()

/** 银行icon */
//@property (nonatomic, strong) UIImageView *cardImage;
/** 银行名 */
@property (nonatomic, strong) UILabel *bankNameLabel;
/** 银行类型 */
@property (nonatomic, strong) UILabel *bankTypeLabel;
/** 银行卡号 */
@property (nonatomic, strong) UILabel *bankNumLabel;
/** 渐变色 */
@property (nonatomic, strong) CAGradientLayer *gradientLayer;


@end

@implementation NNHBankCardCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.layer.cornerRadius = NNHMargin_10;
        self.layer.masksToBounds = YES;
        self.contentView.backgroundColor = [UIColor clearColor];
        [self setupChildView];
    }
    return self;
}

- (void)setupChildView
{
    [self.contentView.layer addSublayer:self.gradientLayer];
//    [self.contentView addSubview:self.cardImage];
    [self.contentView addSubview:self.bankNameLabel];
    [self.contentView addSubview:self.bankTypeLabel];
    [self.contentView addSubview:self.bankNumLabel];
    [self.contentView addSubview:self.selectButton];

//    [self.cardImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentView).offset(NNHMargin_15);
//        make.left.equalTo(self.contentView).offset(NNHMargin_15);
//        make.size.mas_equalTo(CGSizeMake(50, 50));
//    }];
    [self.bankNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(NNHMargin_15);
        make.left.equalTo(self.contentView).offset(25);
    }];
    [self.bankTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bankNameLabel.mas_bottom).offset(NNHMargin_15);
        make.left.equalTo(self.bankNameLabel);
    }];
    [self.bankNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-NNHMargin_10);
        make.right.equalTo(self.contentView).offset(-NNHMargin_15);
    }];
    
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView);
        make.top.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(NNHNormalViewH, NNHNormalViewH));
    }];
}

- (void)setCardModel:(NNHBankCardModel *)cardModel
{
    _cardModel = cardModel;
    self.bankNameLabel.text = cardModel.cardBankName;
    if ([cardModel.cardType isEqualToString:@"1"]) {
        self.bankTypeLabel.text = @"个人账户";
    }else {
        self.bankTypeLabel.text = @"公司账户";
    }
    self.bankNumLabel.text = cardModel.cardNum;
//    self.cardImage.image = [UIImage imageNamed:cardModel.bankImageName];
    
    if (cardModel.backColor == nil) {
        cardModel.backColor = [UIColor akext_colorWithHex:@"#f27ca9"];
    }
    self.gradientLayer.colors = @[(__bridge id)[cardModel.backColor colorWithAlphaComponent:0.7].CGColor, (__bridge id)cardModel.backColor.CGColor];
}

- (void)setFrame:(CGRect)frame
{
    CGFloat lrMargin = NNHMargin_15;
    CGFloat tbMargin = NNHMargin_5;
    frame.origin.x = lrMargin;
    frame.origin.y += tbMargin;
    frame.size.width = frame.size.width - 2 * lrMargin;
    frame.size.height = frame.size.height - tbMargin * 2;
    
    [super setFrame:frame];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.gradientLayer.frame = CGRectMake(0, 0, self.nnh_width, self.nnh_height);
}

//- (void)selectedButtonClick:(UIButton *)button
//{
//    button.selected = !button.selected;
//}

#pragma mark -
#pragma mark ---------Getter && Setter
//- (UIImageView *)cardImage
//{
//    if (_cardImage == nil) {
//        _cardImage = [[UIImageView alloc] init];
//    }
//    return _cardImage;
//}

- (UILabel *)bankNameLabel
{
    if (_bankNameLabel == nil) {
        _bankNameLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorThemeWhite] font:[UIConfigManager fontThemeLargerBtnTitles]];
    }
    return _bankNameLabel;
}

- (UILabel *)bankTypeLabel
{
    if (_bankTypeLabel == nil) {
        _bankTypeLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorThemeWhite] font:[UIConfigManager fontThemeTextMain]];
    }
    return _bankTypeLabel;
}

- (UILabel *)bankNumLabel
{
    if (_bankNumLabel == nil) {
        _bankNumLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorThemeWhite] font:[UIConfigManager fontThemeMostImportantTitles]];
        _bankNumLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _bankNumLabel;
}

- (UIButton *)selectButton
{
    if (_selectButton == nil) {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectButton setImage:[UIImage imageNamed:@"ic_bank_card_not_check"] forState:UIControlStateNormal];
        [_selectButton setImage:[UIImage imageNamed:@"ic_bank_card_check"] forState:UIControlStateSelected];
        _selectButton.userInteractionEnabled = NO;
//        [_selectButton addTarget:self action:@selector(selectedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _selectButton.hidden = YES;
    }
    return _selectButton;
}

- (CAGradientLayer *)gradientLayer
{
    if (_gradientLayer == nil) {
        //添加蒙版
        _gradientLayer = [CAGradientLayer layer];
        UIColor *currentColor = [UIColor akext_colorWithHex:@"#f27ca9"];
        _gradientLayer.colors = @[(__bridge id)[currentColor colorWithAlphaComponent:0.7].CGColor, (__bridge id)currentColor.CGColor];
        _gradientLayer.startPoint = CGPointMake(0, 0.0);
        _gradientLayer.endPoint = CGPointMake(0.7, 1);
    }
    return _gradientLayer;
}

@end
