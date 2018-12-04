//
//  NNCoinBuySellListView.m
//  SuperWallet
//
//  Created by 牛牛 on 2018/4/16.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import "NNCoinBuySellListView.h"

@interface NNCoinBuySellListView ()

/** 卖 */
@property (nonatomic, strong) UIView *sellContentView;
/** 买 */
@property (nonatomic, strong) UIView *buyContentView;
/** 当前价格 */
@property (nonatomic, strong) UIButton *currentPriceButton;

@end

static NSInteger const buySellListCount = 8;
@implementation NNCoinBuySellListView
{
    CGFloat _buttonH;
}

- (instancetype)initWithLeftUnit:(NSString *)leftUnit rightUnit:(NSString *)rightUnit
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self setupChildViewWithLeftUnit:leftUnit rightUnit:rightUnit];
    }
    return self;
}

- (void)setupChildViewWithLeftUnit:(NSString *)leftUnit rightUnit:(NSString *)rightUnit
{
    // 初始值
    CGFloat titleViewH = 30;
    CGFloat currentPriceViewH = 44;
    _buttonH = (SCREEN_HEIGHT - (NNHNavBarViewHeight) - (NNHBottomSafeHeight) - 44 - titleViewH - currentPriceViewH) / (buySellListCount *2);
    
    // 标题
    UIButton *titleBtn = [self buttonWithLeftTitle:[NSString stringWithFormat:@"价格(%@)",leftUnit] leftTitleColor:[UIConfigManager colorTextLightGray] rightTitle:[NSString stringWithFormat:@"数量(%@)",rightUnit] rightTitleColor:[UIConfigManager colorTextLightGray] addAction:NO];
    [self addSubview:titleBtn];
    [titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(@30);
    }];
    
    // 卖单view
    [self addSubview:self.sellContentView];
    [self.sellContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleBtn.mas_bottom);
        make.left.right.equalTo(self);
        make.height.equalTo(@(buySellListCount *_buttonH));
    }];
    
    // 中间实时价格
    [self addSubview:self.currentPriceButton];
    [self.currentPriceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(titleBtn);
        make.top.equalTo(self.sellContentView.mas_bottom);
        make.height.equalTo(@44);
    }];
    
    // 买单view
    [self addSubview:self.buyContentView];
    [self.buyContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.currentPriceButton.mas_bottom);
        make.left.right.equalTo(self);
        make.height.equalTo(@(buySellListCount *_buttonH));
    }];
    
}

- (void)setBuyLists:(NSArray *)buyLists
{
    _buyLists = buyLists;
    
    for (NSInteger i = 0; i < self.buyContentView.subviews.count; i++) {
        UIButton *btn = self.buyContentView.subviews[i];
        if (i < buyLists.count) {
            
            btn.hidden = NO;
            UILabel *rightLabel = [btn.subviews lastObject];
            
            // 赋值
            NSDictionary *dic = buyLists[i];
            [btn setTitle:dic[@"price"] forState:UIControlStateNormal];
            rightLabel.text = dic[@"totalnum"];
            
        }else{
            btn.hidden = YES;
        }
    }
}

- (void)setSellLists:(NSArray *)sellLists
{
    _sellLists = sellLists;
    
    for (NSInteger i = 0; i < self.sellContentView.subviews.count; i++) {
        UIButton *btn = self.sellContentView.subviews[i];
        if (i < sellLists.count) {
            
            btn.hidden = NO;
            UILabel *rightLabel = [btn.subviews lastObject];
            
            // 赋值
            NSDictionary *dic = sellLists[i];
            [btn setTitle:dic[@"price"] forState:UIControlStateNormal];
            rightLabel.text = dic[@"totalnum"];
            
        }else{
            btn.hidden = YES;
        }
    }
}

- (void)setCurrentPrice:(NSString *)currentPrice
{
    _currentPrice = [currentPrice copy];
    
    if (!currentPrice) return;
    [self.currentPriceButton setTitle:currentPrice forState:UIControlStateNormal];
}

- (void)getTradingPrice:(UIButton *)button
{
    if (self.selectedPriceBlock && button.currentTitle.length > 0) {
        self.selectedPriceBlock(button.currentTitle);        
    }
}

- (UIView *)sellContentView
{
    if (_sellContentView == nil) {
        _sellContentView = [[UIView alloc] init];
        _sellContentView.backgroundColor = [UIColor whiteColor];
        
        // 卖单
        for (NSInteger i = 0; i < buySellListCount; i++) {
            UIButton *btn = [self buttonWithLeftTitle:@"" leftTitleColor:[UIConfigManager colorThemeRed] rightTitle:@"" rightTitleColor:[UIConfigManager colorThemeDark] addAction:YES];
            [_sellContentView addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(_sellContentView);
                make.top.equalTo(_sellContentView).offset(i *_buttonH);
                make.height.equalTo(@(_buttonH));
            }];
        }
    }
    return _sellContentView;
}

- (UIView *)buyContentView
{
    if (_buyContentView == nil) {
        _buyContentView = [[UIView alloc] init];
        _buyContentView.backgroundColor = [UIColor whiteColor];
        
        // 买单
        for (NSInteger i = 0; i < buySellListCount; i++) {
            UIButton *btn = [self buttonWithLeftTitle:@"" leftTitleColor:[UIColor akext_colorWithHex:@"#3fbe72"] rightTitle:@"" rightTitleColor:[UIConfigManager colorThemeDark]  addAction:YES];
            [_buyContentView addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(_buyContentView);
                make.top.equalTo(_buyContentView).offset(i *_buttonH);
                make.height.equalTo(@(_buttonH));
            }];
        }
    }
    return _buyContentView;
}

- (UIButton *)currentPriceButton
{
    if (_currentPriceButton == nil) {
        _currentPriceButton = [UIButton NNHBtnTitle:@"" titileFont:[UIFont boldSystemFontOfSize:14] backGround:[UIColor whiteColor] titleColor:[UIConfigManager colorThemeDark]];
        [_currentPriceButton addTarget:self action:@selector(getTradingPrice:) forControlEvents:UIControlEventTouchUpInside];
        NNHViewBorderRadius(_currentPriceButton, 0.00, 0.5, [UIConfigManager colorThemeDark])
    }
    return _currentPriceButton;
}

- (UIButton *)buttonWithLeftTitle:(NSString *)leftTitle
                   leftTitleColor:(UIColor *)leftTitleColor
                       rightTitle:(NSString *)rightTitle
                  rightTitleColor:(UIColor *)rightTitleColor
                        addAction:(BOOL)action
{
    UIButton *btn = [UIButton NNHBtnTitle:leftTitle titileFont:[UIConfigManager fontThemeTextTip] backGround:[UIColor whiteColor] titleColor:leftTitleColor];
    [btn setBackgroundColor:[UIColor akext_colorWithHex:@"#f7f7f7"] forState:UIControlStateHighlighted];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    if (action) {
        [btn addTarget:self action:@selector(getTradingPrice:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UILabel *rightLabel = [UILabel NNHWithTitle:rightTitle titleColor:rightTitleColor font:[UIConfigManager fontThemeTextTip]];
    [btn addSubview:rightLabel];
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(btn);
    }];
    
    return btn;
}

@end
