//
//  NNHUploadPictureView.h
//  NNHPlatform
//
//  Created by leiliao lai on 17/3/2.
//  Copyright © 2017年 牛牛汇. All rights reserved.
//

/*****************************************************
 
 @Author             来旭磊
 
 @CreateTime      TimeForever
 
 @ function           售后贷款上传图片view
 
 @Remarks          <#注释#>
 
 *****************************************************/

#import <UIKit/UIKit.h>
@class NNHUploadPictureView;

@interface NNHUploadPictureCell : UICollectionViewCell
/** 图片最大个数 */
@property (nonatomic, assign) NSInteger maxCount;
/** 显示图片 */
@property (nonatomic, strong) UIImage *showImage;
/** 显示图片的路径 */
@property (nonatomic, copy) NSString *showImageUrl;

/** 显示图片 */
@property (nonatomic, assign) BOOL isLast;
/** index */
@property (nonatomic, strong) NSIndexPath *currentIndex;

@property (nonatomic, copy) void(^didDeleteBlock)(NSIndexPath *index);
/** 显示图片 */
@property (nonatomic, strong) UIImageView *mainImage;
@end

/********************************************************/


@protocol NNHUploadPictureViewDelegate <NSObject>
/** 点击了最后一张图片 */
- (void)didSelectedLastImageAtPictureView:(NNHUploadPictureView *)pictureView;

@optional
/** 点击cell的代理方法，最后一个cell是点击添加图片 添加图片之后需手动调用reloadPictureData 刷新界面*/
- (void)uploadPictureView:(NNHUploadPictureView *)pictureView didClickPictureAtIndex:(NSInteger)index;

@end

@interface NNHUploadPictureView : UIView

@property (nonatomic, strong) NSMutableArray *pictureArray;
/** 代理 */
@property (nonatomic, weak) id<NNHUploadPictureViewDelegate> delegate;

/** 最大图片数量 */
- (instancetype)initWithMaxImageCount:(NSInteger)count;

/** 添加单张图片 */
- (void)addPicture:(UIImage *)image;

/** 添加图片数组 */
- (void)addPictureFromArray:(NSArray <UIImage *>*)imageArray;


@end
