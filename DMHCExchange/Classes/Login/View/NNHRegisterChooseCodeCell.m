//
//  NNHRegisterChooseCodeCell.m
//  WBTWallet
//
//  Created by 来旭磊 on 2018/8/11.
//  Copyright © 2018年 深圳市云牛惠科技有限公司. All rights reserved.
//

#import "NNHRegisterChooseCodeCell.h"
#import "NNHCountryCodeModel.h"

@interface NNHRegisterChooseCodeCell ()

/** code */
@property (nonatomic, strong) UILabel *codeLabel;

/** 名称 */
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation NNHRegisterChooseCodeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self setupChildView];
    }
    return self;
}

- (void)setupChildView
{
    [self.contentView addSubview:self.codeLabel];
    [self.contentView addSubview:self.nameLabel];
    
    [self.codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(NNHMargin_15);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.codeLabel.mas_right).offset(NNHMargin_10);
        make.centerY.equalTo(self.contentView);
    }];
}

- (void)setCodeModel:(NNHCountryCodeModel *)codeModel
{
    _codeModel = codeModel;
    self.codeLabel.text = codeModel.scode;
    self.nameLabel.text = codeModel.name;
}

#pragma mark - Lazy Loads


- (UILabel *)codeLabel
{
    if (_codeLabel == nil) {
        _codeLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorThemeDark] font:[UIConfigManager fontThemeTextDefault]];
    }
    return _codeLabel;
}

- (UILabel *)nameLabel
{
    if (_nameLabel == nil) {
        _nameLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorThemeDark] font:[UIConfigManager fontThemeTextDefault]];
    }
    return _nameLabel;
}

@end
