//
//  NNHPictureBrowseView.h
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/11/2.
//  Copyright © 2018 超级钱包. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NNHPictureBrowseCell : UICollectionViewCell

@end

@interface NNHPictureBrowseView : UIView

/** 图片url数组 */
@property (nonatomic, strong) NSArray *imageUrlArray;

@end

NS_ASSUME_NONNULL_END
