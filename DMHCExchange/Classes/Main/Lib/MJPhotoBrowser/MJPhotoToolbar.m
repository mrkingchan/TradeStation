//
//  MJPhotoToolbar.m
//  FingerNews
//
//  Created by mj on 13-9-24.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MJPhotoToolbar.h"
#import "MJPhoto.h"
//#import "MBProgressHUD+Add.h"

@interface MJPhotoToolbar()
{
    // 显示页码
    UILabel *_indexLabel;
    UIButton *_saveImageBtn;
    UIPageControl *_pageControl;
}
@end

@implementation MJPhotoToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark -
#pragma mark ----- 此处有修改 将标记label换成_pageControl
- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    if (_photos.count > 1) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.numberOfPages = photos.count;
        _pageControl.currentPageIndicatorTintColor = [UIConfigManager colorThemeRed];
        _pageControl.pageIndicatorTintColor = [[UIColor whiteColor] colorWithAlphaComponent:.2];
        _pageControl.userInteractionEnabled = NO;
        [self addSubview:_pageControl];
//        _indexLabel = [[UILabel alloc] init];
//        _indexLabel.font = [UIFont boldSystemFontOfSize:20];
//        _indexLabel.frame = self.bounds;
//        _indexLabel.backgroundColor = [UIColor clearColor];
//        _indexLabel.textColor = [UIColor whiteColor];
//        _indexLabel.textAlignment = NSTextAlignmentCenter;
//        _indexLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//        [self addSubview:_indexLabel];
    }
    
    // 保存图片按钮
//    CGFloat btnWidth = self.bounds.size.height;
//    _saveImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _saveImageBtn.frame = CGRectMake(20, 0, btnWidth, btnWidth);
//    _saveImageBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//    [_saveImageBtn setImage:[UIImage imageNamed:@"MJPhotoBrowser.bundle/save_icon.png"] forState:UIControlStateNormal];
//    [_saveImageBtn setImage:[UIImage imageNamed:@"MJPhotoBrowser.bundle/save_icon_highlighted.png"] forState:UIControlStateHighlighted];
//    [_saveImageBtn addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_saveImageBtn];
}

- (void)saveImage
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        MJPhoto *photo = _photos[_currentPhotoIndex];
        UIImageWriteToSavedPhotosAlbum(photo.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    });
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
//        [MBProgressHUD showSuccess:@"保存失败" toView:nil];
    } else {
        MJPhoto *photo = _photos[_currentPhotoIndex];
        photo.save = YES;
        _saveImageBtn.enabled = NO;
//        [MBProgressHUD showSuccess:@"成功保存到相册" toView:nil];
    }
}

#pragma mark -
#pragma mark ----- 此处有修改 更新页码
- (void)setCurrentPhotoIndex:(NSUInteger)currentPhotoIndex
{
    _currentPhotoIndex = currentPhotoIndex;
    
    // 更新页码
    _pageControl.currentPage = currentPhotoIndex;
//    _indexLabel.text = [NSString stringWithFormat:@"%lu / %lu", _currentPhotoIndex + 1, (unsigned long)_photos.count];
    if (_photos.count) {
        
        MJPhoto *photo = _photos[_currentPhotoIndex];
        // 按钮
        _saveImageBtn.enabled = photo.image != nil && !photo.save;
    }
}

@end
