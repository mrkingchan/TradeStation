//
//  NNLegalTenderTradeSelectMarketView.m
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/29.
//  Copyright © 2018 超级钱包. All rights reserved.
//

#import "NNLegalTenderTradeSelectMarketView.h"

@interface NNLegalTenderTradeSelectMarketCell ()

/** 交易对名称 */
@property (nonatomic, strong) UILabel *marketNameLabel;

@end

@implementation NNLegalTenderTradeSelectMarketCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIConfigManager colorThemeWhite];
        [self setupChildView];
    }
    return self;
}

- (void)setupChildView
{
    [self.contentView addSubview:self.marketNameLabel];
    [self.marketNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}
- (void)setCoinName:(NSString *)coinName
{
    _coinName = coinName;
    self.marketNameLabel.text = coinName;
}

- (UILabel *)marketNameLabel
{
    if (_marketNameLabel == nil) {
        _marketNameLabel = [UILabel NNHWithTitle:@"" titleColor:[UIColor akext_colorWithHex:@"#4e66b2"] font:[UIFont boldSystemFontOfSize:16]];
        _marketNameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _marketNameLabel;
}

@end

@interface NNLegalTenderTradeSelectMarketView ()<UICollectionViewDelegate, UICollectionViewDataSource>

/** 背景view */
@property (nonatomic, strong) UIView *bgView;
/** collectionView */
@property (nonatomic, strong) UICollectionView *collectionView;


@end

@implementation NNLegalTenderTradeSelectMarketView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupChildView];
    }
    return self;
}

- (void)setupChildView
{
    
    UIView *contentView = [[UIView alloc] init];
    [self addSubview:contentView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    [contentView addGestureRecognizer:tap];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.top.equalTo(self).offset((NNHNavBarViewHeight) - 1);
    }];

    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.bgView);
        make.height.equalTo(@(SCREEN_WIDTH * 0.6));
    }];
}

- (void)show
{
    // 获得最上面的窗口
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    // 添加自己到窗口上
    [window addSubview:self];
    
    // 设置尺寸
    self.frame = window.bounds;
}

- (void)close
{
    [self removeFromSuperview];
}

- (void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NNLegalTenderTradeSelectMarketCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([NNLegalTenderTradeSelectMarketCell class]) forIndexPath:indexPath];
    NNLegalTenderTradeCoinModel *coinModel = self.dataSource[indexPath.row];
    cell.coinName = coinModel.coinname;
    return cell;
}

#pragma mark -
#pragma mark ---------UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NNLegalTenderTradeCoinModel *coinModel = self.dataSource[indexPath.row];
    if (self.selectedMarketCompleteBlock) {
        self.selectedMarketCompleteBlock(coinModel);
    }
    
    [self removeFromSuperview];
}

#pragma mark - Getter && Setter

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        layout.itemSize = CGSizeMake(SCREEN_WIDTH * 0.25, SCREEN_WIDTH * 0.25 * 0.6);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIConfigManager colorThemeWhite];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[NNLegalTenderTradeSelectMarketCell class] forCellWithReuseIdentifier:NSStringFromClass([NNLegalTenderTradeSelectMarketCell class])];
    }
    return _collectionView;
}

- (UIView *)bgView
{
    if (_bgView == nil) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [[UIColor akext_colorWithHex:@"#000000"] colorWithAlphaComponent:0.6];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
        [_bgView addGestureRecognizer:tap];
    }
    return _bgView;
}

@end
