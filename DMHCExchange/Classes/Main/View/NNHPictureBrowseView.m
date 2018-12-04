//
//  NNHPictureBrowseView.m
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/11/2.
//  Copyright © 2018 超级钱包. All rights reserved.
//

#import "NNHPictureBrowseView.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@interface NNHPictureBrowseCell ()

/** 图片地址 */
@property (nonatomic, copy) NSString *imageUrl;

/** 显示图片 */
@property (nonatomic, strong) UIImageView *mainImage;

@end

@implementation NNHPictureBrowseCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setupChildView];
    }
    return self;
}

- (void)setupChildView
{
    [self.contentView addSubview:self.mainImage];
    [self.mainImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

#pragma mark -
#pragma mark ---------私有方法

- (void)setImageUrl:(NSString *)imageUrl
{
    _imageUrl = imageUrl;
    [self.mainImage sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
}

#pragma mark -
#pragma mark ---------Getter && Setter
- (UIImageView *)mainImage
{
    if (_mainImage == nil) {
        _mainImage = [[UIImageView alloc] init];
        _mainImage.backgroundColor = [UIConfigManager colorThemeColorForVCBackground];
        _mainImage.contentMode = UIViewContentModeScaleAspectFill;
        _mainImage.clipsToBounds = YES;
    }
    return _mainImage;
}


@end

/********************************************************/

@interface NNHPictureBrowseView ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

/** 显示图片的CollectionView */
@property (nonatomic, strong) UICollectionView *pictureCollectionView;

@end

@implementation NNHPictureBrowseView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        [self setupChildViews];
    }
    return self;
}

/**  添加子控件  */
- (void)setupChildViews
{
    [self addSubview:self.pictureCollectionView];
    [self.pictureCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)setImageUrlArray:(NSArray *)imageUrlArray
{
    _imageUrlArray = imageUrlArray;
    [self.pictureCollectionView reloadData];
}

#pragma mark -
#pragma mark ---------公开方法

#pragma mark -
#pragma mark ---------UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageUrlArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NNHPictureBrowseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([NNHPictureBrowseCell class]) forIndexPath:indexPath];

    cell.imageUrl = self.imageUrlArray[indexPath.row];
    
    return cell;
}

#pragma mark -
#pragma mark ---------UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NNHPictureBrowseCell *cell = (NNHPictureBrowseCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    // 1.创建图片浏览器
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    
    // 2.设置图片浏览器显示的所有图片
    NSMutableArray *photos = [NSMutableArray array];
    NSUInteger count = self.imageUrlArray.count;
    for (NSUInteger i = 0; i < count; i++) {
        
        MJPhoto *photo = [[MJPhoto alloc] init];
        
        // 设置图片的路径
        photo.url = [NSURL URLWithString:self.imageUrlArray[i]];
        
        // 设置来源于哪一个UIImageView
        photo.srcImageView = cell.mainImage;
        [photos addObject:photo];
    }
    
    browser.photos = photos;
    // 4.设置默认显示的图片索引
    browser.currentPhotoIndex = indexPath.row;
    // 5.显示浏览器
    [browser show];
}

#pragma mark -
#pragma mark ---------Getter && Setter

- (UICollectionView *)pictureCollectionView
{
    if (_pictureCollectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(0, NNHMargin_15, 0, NNHMargin_15);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        
        layout.itemSize = CGSizeMake((SCREEN_WIDTH - 50) / 3, (SCREEN_WIDTH - 50) / 3);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _pictureCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _pictureCollectionView.backgroundColor = [UIColor whiteColor];
        _pictureCollectionView.showsHorizontalScrollIndicator = NO;
        _pictureCollectionView.delegate = self;
        _pictureCollectionView.dataSource = self;
        _pictureCollectionView.bounces = NO;
        [_pictureCollectionView registerClass:[NNHPictureBrowseCell class] forCellWithReuseIdentifier:NSStringFromClass([NNHPictureBrowseCell class])];
    }
    return _pictureCollectionView;
}



@end
