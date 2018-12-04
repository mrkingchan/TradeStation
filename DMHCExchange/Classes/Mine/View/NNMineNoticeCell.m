//
//  NNMineNoticeCell.m
//  DMHCExchange
//
//  Created by 牛牛 on 2018/10/25.
//  Copyright © 2018年 超级钱包. All rights reserved.
//

#import "NNMineNoticeCell.h"

@interface NNMineNoticeCell ()

/** 标题 */
@property (strong, nonatomic) UILabel *titleLabel;
/** 时间 */
@property (strong, nonatomic) UILabel *timeLabel;

@end

@implementation NNMineNoticeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self setupChildView];
    }
    return self;
}

- (void)setupChildView
{
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_centerY).offset(-6);
        make.left.equalTo(self.contentView).offset(15);
    }];
    
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_centerY).offset(6);
        make.left.equalTo(self.titleLabel);
    }];
}

- (void)setNoticeModel:(NNMineNoticeModel *)noticeModel
{
    _noticeModel = noticeModel;
    
    self.titleLabel.text = noticeModel.title;
    self.timeLabel.text = noticeModel.addtime;
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorThemeDark] font:[UIFont systemFontOfSize:14]];
        _titleLabel.backgroundColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (UILabel *)timeLabel
{
    if (_timeLabel == nil) {
        _timeLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorTextLightGray] font:[UIConfigManager fontThemeTextTip]];
        _timeLabel.backgroundColor = [UIColor whiteColor];
    }
    return _timeLabel;
}


@end
