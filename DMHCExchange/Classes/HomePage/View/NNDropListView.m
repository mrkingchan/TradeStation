//
//  NNDropListView.m
//  DMHCExchange
//
//  Created by 云笈 on 2018/10/26.
//  Copyright © 2018年 超级钱包. All rights reserved.
//

#import "NNDropListView.h"
#import "NNTagCell.h"

@interface NNDropListView () <UICollectionViewDataSource,UICollectionViewDelegate> {
    UICollectionView *_collectionView;
    NSArray *_dataArray;
}

@end
@implementation NNDropListView

+ (instancetype)nnDropListViewWithArray:(NSArray *)titles complete:(void (^)(NSString * _Nonnull, NSInteger))complete {
    return [[NNDropListView alloc] initWithArray:titles complete:complete];
}

- (instancetype)initWithArray:(NSArray *)titles complete:(void (^)(NSString * _Nonnull, NSInteger))complete {
    if (self = [super initWithFrame:CGRectMake(0, isiPhoneX ? 88 + 135 : 64 + 135, SCREEN_WIDTH, titles.count %4 == 0 ? titles.count /4 * 44:((titles.count / 4) + 1) * 44)]) {
        NSParameterAssert(titles.count);
        _complete = complete;
        _dataArray = titles;
        self.backgroundColor = [UIColor clearColor];
        [self setUpChildViews];
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
    return self;
}

- (void)setUpChildViews {
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.minimumLineSpacing = 5.0;
    layout.minimumInteritemSpacing = 5.0;
    layout.itemSize = CGSizeMake((SCREEN_WIDTH - 25)/4.0, 44);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, _dataArray.count %4 == 0 ? -44 *(_dataArray.count / 4): -(_dataArray.count / 4 +1 ) * 44, 0, 0) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor colorWithRed:21/255.0 green:31/255.0 blue:47/255.0 alpha:1.0];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.scrollEnabled = NO;
    [self addSubview:_collectionView];
    [_collectionView registerClass:[NNTagCell class] forCellWithReuseIdentifier:NSStringFromClass([NNTagCell class])];
    [UIView animateWithDuration:0.1 animations:^{
        _collectionView.frame = self.bounds;
    }];
}

#pragma mark - UICollectionViewDatasource &Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NNTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([NNTagCell class]) forIndexPath:indexPath];
    [cell setTagContent:_dataArray[indexPath.row]];
    return  cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([_dataArray[indexPath.row] rangeOfString:@"图"].location != NSNotFound) {
        return;
    } else {
        [UIView animateWithDuration:0.1 animations:^{
            [self removeFromSuperview];
        } completion:^(BOOL finished) {
            
        }];
        if (_complete) {
            _complete(_dataArray[indexPath.row],indexPath.row);
        }
    }
}

@end
