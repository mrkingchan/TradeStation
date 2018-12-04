//
//  NNNewsCell.m
//  DMHCExchange
//
//  Created by 云笈 on 2018/10/24.
//  Copyright © 2018年 超级钱包. All rights reserved.
//

#import "NNNewsCell.h"

@interface NNNewsCell()

/** 内容 */
@property (nonatomic, strong) UILabel *content;

/**发布时间 */
@property (nonatomic, strong) UILabel *releaseTime;

/**图片 */

@property (nonatomic, strong) UIImageView *picture;


@end
@implementation NNNewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - init method
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style
                    reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIConfigManager colorThemeWhite];
        [self setUpChildViews];
    }
    return self;
}

#pragma mark - setUpChildViews
- (void)setUpChildViews {
    //内容
    [self.contentView addSubview:self.content];
    [_content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(NNHMargin_15);
        make.top.equalTo(self.contentView.mas_top).offset(NNHMargin_20);
    }];
    
    //时间
    [self.contentView addSubview:self.releaseTime];
    [_releaseTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_content);
        make.top.equalTo(_content.mas_bottom).offset(NNHMargin_20);
    }];
    
    //图片
    [self.contentView addSubview:self.picture];
    [_picture mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(NNHMargin_15);
        make.right.equalTo(self.contentView.mas_right).offset(-NNHMargin_15);
        make.height.equalTo(@80);
        make.width.equalTo(@120);
    }];
}

#pragma mark - private Method
- (void)setNewsModel:(NNNewsModel *)newsModel {
    NSParameterAssert(newsModel);
    _content.text = newsModel.title;
    _releaseTime.text = newsModel.addtime;
    [_picture  sd_setImageWithURL:[NSURL URLWithString:newsModel.thumb] placeholderImage:nil];
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:newsModel.title];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:10];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [newsModel.title length])];
    [_content setAttributedText:attributedString1];
    [_content sizeToFit];
    if (newsModel.thumb.length < 1) {
        _picture.hidden = YES;
        [_content mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(NNHMargin_20);
            make.left.equalTo(self.contentView.mas_left).offset(NNHMargin_15);
            make.right.equalTo(self.contentView.mas_right).offset(-NNHMargin_15);
        }];
    } else {
        _picture.hidden = NO;
        [_content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(NNHMargin_15);
            make.top.equalTo(self.contentView.mas_top).offset(NNHMargin_20);
            make.right.equalTo(self.contentView.mas_right).offset(-153);
        }];
    }
}

#pragma mark - Lazy Loads
- (UILabel *)content{
    if (!_content) {
        _content = [UILabel NNHWithTitle:@""
                              titleColor:[UIColor  akext_colorWithHex:@"#333333"] font:[UIFont boldSystemFontOfSize:15]];
        _content.numberOfLines = 2;
        _content.lineBreakMode =  NSLineBreakByTruncatingTail;
        _content.backgroundColor = [UIColor whiteColor];
    }
    return _content;
}

- (UILabel *)releaseTime{
    if (!_releaseTime) {
        _releaseTime = [UILabel NNHWithTitle:@""
                                  titleColor:[UIColor akext_colorWithHex:@"#999999"] font:[UIFont  systemFontOfSize:12]];
        _releaseTime.backgroundColor = [UIColor whiteColor];
    }
    return _releaseTime;
}

- (UIImageView *)picture{
    if (!_picture) {
        _picture = [[UIImageView  alloc] init];
        _picture.backgroundColor = NNHRGBColor(204, 204, 204);
    }
    return _picture;
}

@end
