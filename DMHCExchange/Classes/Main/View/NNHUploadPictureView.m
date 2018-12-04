//
//  NNHUploadPictureView.m
//  NNHPlatform
//
//  Created by leiliao lai on 17/3/2.
//  Copyright © 2017年 牛牛汇. All rights reserved.
//

#import "NNHUploadPictureView.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@interface NNHUploadPictureCell ()

/** 显示图片 */
@property (nonatomic, strong) UIButton *deleteButton;

@property (nonatomic, strong) UIImageView *addIcon;

@property (nonatomic, strong) UILabel *addLabel;

@end

@implementation NNHUploadPictureCell

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
    
    [self.contentView addSubview:self.deleteButton];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.contentView addSubview:self.addIcon];
    [self.addIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.contentView addSubview:self.addLabel];
    [self.addLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addIcon.mas_bottom).offset(NNHMargin_15);
        make.centerX.equalTo(self.contentView.mas_centerX);
    }];
}

#pragma mark -
#pragma mark ---------私有方法
- (void)setMaxCount:(NSInteger)maxCount
{
    _maxCount = maxCount;
    self.addLabel.text = @"";
}

- (void)deleteButtonClick:(UIButton *)button
{
    if (self.didDeleteBlock) {
        self.didDeleteBlock(self.currentIndex);
    }
}

- (void)changeImageState
{
    self.deleteButton.hidden = YES;
    self.addIcon.hidden = self.addLabel.hidden = NO;
    self.mainImage.image = nil;
    self.mainImage.backgroundColor = [UIConfigManager colorThemeColorForVCBackground];
}

- (void)setIsLast:(BOOL)isLast
{
    _isLast = isLast;
    if (isLast && self.currentIndex.row < self.maxCount) {
        [self changeImageState];
    }
}

- (void)setShowImage:(UIImage *)showImage
{
    _showImage = showImage;
    if (self.isLast && self.currentIndex.row < self.maxCount) {
        [self changeImageState];
    }else {
        self.mainImage.image = showImage;
        self.mainImage.backgroundColor = [UIColor whiteColor];
        self.deleteButton.hidden = NO;
        self.addIcon.hidden = self.addLabel.hidden = YES;
    }
}

- (void)setShowImageUrl:(NSString *)showImageUrl
{
    _showImageUrl = showImageUrl;
    if (self.isLast && self.currentIndex.row < self.maxCount) {
        [self changeImageState];
    }else {
        [self.mainImage sd_setImageWithURL:[NSURL URLWithString:showImageUrl]];
        self.mainImage.backgroundColor = [UIColor whiteColor];
        self.deleteButton.hidden = NO;
        self.addIcon.hidden = self.addLabel.hidden = YES;
    }
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

- (UIButton *)deleteButton
{
    if (_deleteButton == nil) {
        _deleteButton = [UIButton NNHBtnImage:@"ic_nav_close" target:self action:@selector(deleteButtonClick:)];
    }
    return _deleteButton;
}

- (UIImageView *)addIcon
{
    if (_addIcon == nil) {
        _addIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_add_picture"]];
    }
    return _addIcon;
}

- (UILabel *)addLabel
{
    if (_addLabel == nil) {
        _addLabel = [UILabel NNHWithTitle:@"添加图片" titleColor:[UIConfigManager colorTextLightGray] font:[UIConfigManager fontThemeTextTip]];
        _addLabel.numberOfLines = 2;
        _addLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _addLabel;
}

@end

/********************************************************/

@interface NNHUploadPictureView ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

/** 显示图片的CollectionView */
@property (nonatomic, strong) UICollectionView *pictureCollectionView;
/** 标题label */
@property (nonatomic, strong) UILabel *titleLabel;
/** 图片最大个数 */
@property (nonatomic, assign) NSInteger maxCount;

@end

@implementation NNHUploadPictureView

/** 最大图片数量 */
- (instancetype)initWithMaxImageCount:(NSInteger)count
{
    if (self = [super init]) {
        _maxCount = count;
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        [self setupChildViews];
    }
    return self;
}

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
    if (self.maxCount == 0) {
        self.maxCount = 6;
    }
    [self addSubview:self.pictureCollectionView];
    [self.pictureCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark -
#pragma mark ---------公开方法
- (void)reloadPictureData
{
    [self.pictureCollectionView reloadData];
}

- (void)addPicture:(UIImage *)image
{
    if ([self.pictureArray containsObject:image]) {
        [SVProgressHUD showMessage:@"请勿重复添加"];
        return;
    }
    
    if (self.pictureArray.count >= self.maxCount) return;
    
    [self.pictureArray addObject:image];
    
    [self reloadPictureData];
}

/** 添加图片数组 */
- (void)addPictureFromArray:(NSArray <UIImage *>*)imageArray
{
    [self.pictureArray addObjectsFromArray:imageArray];
    
    if (self.pictureArray.count >= self.maxCount) {
        [self.pictureArray removeObjectsInRange:NSMakeRange(self.maxCount, self.pictureArray.count - self.maxCount)];
    }
    [self reloadPictureData];
}

#pragma mark -
#pragma mark ---------UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.pictureArray.count == self.maxCount) {
        return self.pictureArray.count;
    }
    return self.pictureArray.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NNHUploadPictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([NNHUploadPictureCell class]) forIndexPath:indexPath];
    cell.maxCount = self.maxCount;
    cell.currentIndex = indexPath;
    if (indexPath.row == self.pictureArray.count) {
        cell.isLast = YES;
    }else {
        cell.isLast = NO;
        id image = self.pictureArray[indexPath.row];
        if ([image isKindOfClass:[UIImage class]]) {
            cell.showImage = (UIImage *)image;
        }
        if ([image isKindOfClass:[NSString class]]) {
            cell.showImageUrl = (NSString *)image;
        }
    }
    
    NNHWeakSelf(self)
    cell.didDeleteBlock = ^(NSIndexPath *index){
        [weakself.pictureArray removeObjectAtIndex:indexPath.row];
        [weakself.pictureCollectionView reloadData];
    };
    
    return cell;
}

#pragma mark -
#pragma mark ---------UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pictureArray.count < self.maxCount && (indexPath.row == self.pictureArray.count)) {
        if ([self.delegate respondsToSelector:@selector(didSelectedLastImageAtPictureView:)]) {
            [self.delegate didSelectedLastImageAtPictureView:self];
        }
    }else {
        NNHUploadPictureCell *cell = (NNHUploadPictureCell *)[collectionView cellForItemAtIndexPath:indexPath];
        
        // 1.创建图片浏览器
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        
        // 2.设置图片浏览器显示的所有图片
        NSMutableArray *photos = [NSMutableArray array];
        NSUInteger count = self.pictureArray.count;
        for (NSUInteger i = 0; i < count; i++) {
            
            MJPhoto *photo = [[MJPhoto alloc] init];
            
            // 设置图片的路径
            photo.image = self.pictureArray[i];
            
            // 设置来源于哪一个UIImageView
            photo.srcImageView = cell.mainImage;
            [photos addObject:photo];
        }
        
        browser.photos = photos;
        // 4.设置默认显示的图片索引
        browser.currentPhotoIndex = indexPath.row;
        // 5.显示浏览器
        [browser show];

        if ([self.delegate respondsToSelector:@selector(uploadPictureView:didClickPictureAtIndex:)]) {
            [self.delegate uploadPictureView:self didClickPictureAtIndex:indexPath.row];
        }
    }
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
        [_pictureCollectionView registerClass:[NNHUploadPictureCell class] forCellWithReuseIdentifier:NSStringFromClass([NNHUploadPictureCell class])];
    }
    return _pictureCollectionView;
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor whiteColor];
        _titleLabel.text = @"添加图片";
        _titleLabel.font = [UIConfigManager fontThemeTextTip];
        _titleLabel.textColor = [UIConfigManager colorTextLightGray];
    }
    return _titleLabel;
}

- (NSMutableArray *)pictureArray
{
    if (_pictureArray == nil) {
        _pictureArray = [NSMutableArray array];
    }
    return _pictureArray;
}

@end
