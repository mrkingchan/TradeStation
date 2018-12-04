//
//  NNMineShareRewardCell.m
//  DMHCExchange
//
//  Created by 牛牛 on 2018/10/24.
//  Copyright © 2018年 超级钱包. All rights reserved.
//

#import "NNMineShareRewardCell.h"

@interface NNMineShareRewardCell ()

/** 标题 */
@property (strong, nonatomic) UILabel *titleLabel;
/** 时间 */
@property (strong, nonatomic) UILabel *timeLabel;
/** 数量 */
@property (strong, nonatomic) UILabel *numberLabel;
/** 币种 */
@property (strong, nonatomic) UILabel *symbolLabel;
/** 状态 */
@property (strong, nonatomic) UILabel *statusLabel;

@end

@implementation NNMineShareRewardCell

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
    
    [self.contentView addSubview:self.numberLabel];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    [self.contentView addSubview:self.symbolLabel];
    [self.symbolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self.numberLabel.mas_left).offset(-5);
    }];
    
    [self.contentView addSubview:self.statusLabel];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeLabel);
        make.right.equalTo(self.numberLabel);
    }];
}

- (void)setShareRewardModel:(NNMineShareRewardModel *)shareRewardModel
{
    _shareRewardModel = shareRewardModel;
    
    self.titleLabel.text = shareRewardModel.nickname;
    self.timeLabel.text = shareRewardModel.time;
    self.numberLabel.text = shareRewardModel.amount;
    self.symbolLabel.text = shareRewardModel.unit;
    self.statusLabel.text = shareRewardModel.statusstr;
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

- (UILabel *)numberLabel
{
    if (_numberLabel == nil) {
        _numberLabel = [UILabel NNHWithTitle:@"" titleColor:[UIColor akext_colorWithHex:@"009759"] font:[UIFont boldSystemFontOfSize:14]];
        _numberLabel.backgroundColor = [UIColor whiteColor];
    }
    return _numberLabel;
}

- (UILabel *)symbolLabel
{
    if (_symbolLabel == nil) {
        _symbolLabel = [UILabel NNHWithTitle:@"" titleColor:[UIColor akext_colorWithHex:@"4e66b2"] font:[UIFont boldSystemFontOfSize:14]];
        _symbolLabel.backgroundColor = [UIColor whiteColor];
    }
    return _symbolLabel;
}

- (UILabel *)statusLabel
{
    if (_statusLabel == nil) {
        _statusLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorTextLightGray] font:[UIConfigManager fontThemeTextTip]];
        _statusLabel.backgroundColor = [UIColor whiteColor];
    }
    return _statusLabel;
}

@end
