//
//  NNHSectionView.m
//  ElegantLife
//
//  Created by 牛牛 on 16/8/12.
//  Copyright © 2016年 NNH. All rights reserved.
//

#import "NNSectionView.h"

@interface NNSectionView ()

/** 标题➕icon */
@property (nonatomic, strong) UIButton *titleButton;
/** 右边详细 */
@property (nonatomic, strong) UILabel *detailTitleLabel;
/** 右边箭头 */
@property (nonatomic, strong) UIImageView *arrowImageView;
/** 分割线 */
@property (nonatomic, strong) UIView *lineView;

@end

@implementation NNSectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self initialization];
        [self setupUI];
    }
    return self;
}

+ (instancetype)sectionTitle:(NSString *)title detailTile:(NSString *)detailTitle
{
    return [NNSectionView sectionIcon:nil title:title detailTile:detailTitle];
}

+ (instancetype)sectionIcon:(NSString *)icon title:(NSString *)title detailTile:(NSString *)detailTitle
{
    NNSectionView *sectionView = [[self alloc] init];
    [sectionView.titleButton setTitle:title forState:UIControlStateNormal];
    sectionView.detailTitleLabel.text = detailTitle;
    if (icon.length) {
        [sectionView.titleButton setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
        [sectionView.titleButton setTitleEdgeInsets:UIEdgeInsetsMake(0, NNHMargin_10, 0, 0)];
    };
    return sectionView;
}

// 初始赋值
- (void)initialization
{
    _titleColor = [UIConfigManager colorThemeDark];
    _detailTitleColor = [UIConfigManager colorTextLightGray];
    _sectionViewBackgroundColor = [UIColor whiteColor];
    _sectionViewLineColor = [UIConfigManager colorThemeSeperatorLightGray];
    _titleLabelTextFont = [UIConfigManager fontThemeTextMain];
    _detailTitleLabelTextFont = [UIFont systemFontOfSize:11];
    _sectionViewLineHeight = 0.5;
}

// 初始UI
- (void)setupUI
{
    self.backgroundColor = self.sectionViewBackgroundColor;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSectionViewAction)]];

    [self addSubview:self.titleButton];
    [self.titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(NNHMargin_15);
        make.centerY.equalTo(self);
        make.width.equalTo(self).multipliedBy(0.5);
    }];
    
    [self addSubview:self.arrowImageView];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-NNHMargin_10);
        make.centerY.equalTo(self.titleButton);
    }];
    
    [self addSubview:self.detailTitleLabel];
    [self.detailTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arrowImageView.mas_left).offset(-5);
        make.centerY.equalTo(self.titleButton);
    }];
    
    [self addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self).insets(UIEdgeInsetsZero);
        make.height.equalTo(@(self.sectionViewLineHeight));
    }];
}

- (void)setText:(NSString *)text
{
    _text = [text copy];
    [self.titleButton setTitle:text forState:UIControlStateNormal];
}

- (void)setDetailText:(NSString *)detailText
{
    _detailText = [detailText copy];
    self.detailTitleLabel.text = detailText;
}

- (void)setDetailAttributedText:(NSAttributedString *)detailAttributedText
{
    _detailAttributedText = [detailAttributedText copy];
    self.detailTitleLabel.attributedText = detailAttributedText;
}

- (void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;
    [self.titleButton setTitleColor:titleColor forState:UIControlStateNormal];
}

- (void)setDetailTitleColor:(UIColor *)detailTitleColor
{
    _detailTitleColor = detailTitleColor;
    self.detailTitleLabel.textColor = detailTitleColor;
}

- (void)setSectionViewBackgroundColor:(UIColor *)sectionViewBackgroundColor
{
    _sectionViewBackgroundColor = sectionViewBackgroundColor;
    self.backgroundColor = sectionViewBackgroundColor;
}

- (void)setSectionViewLineColor:(UIColor *)sectionViewLineColor
{
    _sectionViewLineColor = sectionViewLineColor;
    self.lineView.backgroundColor = sectionViewLineColor;
}

- (void)setTitleLabelTextFont:(UIFont *)titleLabelTextFont
{
    _titleLabelTextFont = titleLabelTextFont;
    [self.titleButton.titleLabel setFont:titleLabelTextFont];
}

- (void)setDetailTitleLabelTextFont:(UIFont *)detailTitleLabelTextFont
{
    _detailTitleLabelTextFont = detailTitleLabelTextFont;
    self.detailTitleLabel.font = detailTitleLabelTextFont;
}

- (void)setShowArrow:(BOOL)showArrow
{
    _showArrow = showArrow;
    self.arrowImageView.hidden = !showArrow;
}

- (void)setRightImage:(NSString *)rightImage
{
    _rightImage = rightImage;
    self.arrowImageView.image = ImageName(rightImage);
}

- (void)setShowLine:(BOOL)showLine
{
    _showLine = showLine;
    self.lineView.hidden = !showLine;
}

- (void)setSectionViewLineHeight:(CGFloat)sectionViewLineHeight
{
    _sectionViewLineHeight = sectionViewLineHeight;
    [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(sectionViewLineHeight));
    }];
    [self layoutIfNeeded];
}

- (void)tapSectionViewAction
{
    if (self.didSelectedViewAction) {
        self.didSelectedViewAction();
    }
}

- (UIButton *)titleButton
{
    if (_titleButton == nil) {
        _titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_titleButton setTitleColor:_titleColor forState:UIControlStateNormal];
        [_titleButton.titleLabel setFont:_titleLabelTextFont];
        _titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _titleButton;
}

- (UILabel *)detailTitleLabel
{
    if (_detailTitleLabel == nil) {
        _detailTitleLabel = [[UILabel alloc] init];
        _detailTitleLabel.textColor = _detailTitleColor;
        _detailTitleLabel.font = _detailTitleLabelTextFont;
    }
    return _detailTitleLabel;
}

- (UIImageView *)arrowImageView
{
    if (_arrowImageView == nil) {
        _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_right"]];
        _arrowImageView.contentMode = UIViewContentModeCenter;
    }
    return _arrowImageView;
}

- (UIView *)lineView
{
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = _sectionViewLineColor;
    }
    return _lineView;
}

@end
