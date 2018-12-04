//
//  NNWalletTableViewCell.m
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/24.
//  Copyright © 2018 超级钱包. All rights reserved.
//

#import "NNWalletTableViewCell.h"
#import "UIButton+NNImagePosition.h"
#import "NNWalletPropertyModel.h"

@interface NNWalletTableViewCell ()

/** 名称 */
@property (nonatomic, strong) UILabel *nameLabel;

/** 总量 */
@property (nonatomic, strong) UILabel *totalLabel;
/** 可用 */
@property (nonatomic, strong) UILabel *availableLabel;
/** 冻结 */
@property (nonatomic, strong) UILabel *freezeLabel;

/** 充值按钮 */
@property (nonatomic, weak) UIButton *rechargeButton;
/** 提现按钮 */
@property (nonatomic, weak) UIButton *withdrawButton;
/** 账单 */
@property (nonatomic, weak) UIButton *recordButton;

@end

@implementation NNWalletTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setupChildView];
    }
    return self;
}

- (void)setupChildView
{
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(NNHMargin_15);
        make.top.equalTo(self.contentView).offset(NNHMargin_15);
    }];
    
    UIButton *rechargeButton = [self buttonWithTitle:@"充币"];
    UIButton *withdrawButton = [self buttonWithTitle:@"提币"];
    UIButton *recordButton = [self buttonWithTitle:@"账单"];
    
    [self.contentView addSubview:rechargeButton];
    [self.contentView addSubview:withdrawButton];
    [self.contentView addSubview:recordButton];
    
    
    CGFloat buttonWidth = 100;
    CGFloat padding = (SCREEN_WIDTH - 3 * buttonWidth) / 3;
    
    [rechargeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(padding * 0.5);
        make.bottom.equalTo(self.contentView).offset(-NNHMargin_20);
        make.height.equalTo(@(30));
        make.width.equalTo(@(buttonWidth));
    }];
    
    [withdrawButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rechargeButton.mas_right).offset(padding);
        make.size.equalTo(rechargeButton);
        make.top.equalTo(rechargeButton);
    }];
    
    [recordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(withdrawButton.mas_right).offset(padding);
        make.size.equalTo(withdrawButton);
        make.top.equalTo(withdrawButton);
    }];
    
    self.rechargeButton = rechargeButton;
    self.withdrawButton = withdrawButton;
    self.recordButton = recordButton;
    
    self.rechargeButton.tag = NNHWalletOperationType_recharge;
    self.withdrawButton.tag = NNHWalletOperationType_withdraw;
    self.recordButton.tag = NNHWalletOperationType_record;
    

    [self.contentView addSubview:self.availableLabel];
    [self.availableLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rechargeButton);
        make.baseline.equalTo(self.rechargeButton.mas_top).offset(-NNHMargin_15);
        make.right.equalTo(self.withdrawButton.mas_left).offset(-NNHMargin_5);
    }];
    
    [self.contentView addSubview:self.freezeLabel];
    [self.freezeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.withdrawButton);
        make.baseline.equalTo(self.availableLabel);
        make.right.equalTo(self.recordButton.mas_left).offset(-NNHMargin_5);
    }];
    
    [self.contentView addSubview:self.totalLabel];
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.recordButton);
        make.baseline.equalTo(self.availableLabel);
        make.right.equalTo(self.contentView).offset(-NNHMargin_15);
    }];
}

- (void)walletOperationAction:(UIButton *)button
{
    if (self.walletOperationBlock) {
        self.walletOperationBlock(button.tag);
    }
}

 - (void)setPropertyModel:(NNWalletPropertyModel *)propertyModel
{
    _propertyModel = propertyModel;
    self.nameLabel.text = propertyModel.coinname_abb;
    
    self.rechargeButton.enabled = [propertyModel.is_show_recharge isEqualToString:@"1"];
    self.withdrawButton.enabled = [propertyModel.is_show_extract isEqualToString:@"1"];
    
    self.availableLabel.text = [NSString stringWithFormat:@"可用：%@",propertyModel.coinamount];
    self.freezeLabel.text = [NSString stringWithFormat:@"冻结：%@",propertyModel.fut_coinamount];
    self.totalLabel.text = [NSString stringWithFormat:@"全部：%@",propertyModel.all_coinamount];
    
    [self.availableLabel nnh_addAttringTextWithText:@"可用：" font:nil color:[UIConfigManager colorTextLightGray]];
    [self.freezeLabel nnh_addAttringTextWithText:@"冻结：" font:nil color:[UIConfigManager colorTextLightGray]];
    [self.totalLabel nnh_addAttringTextWithText:@"全部：" font:nil color:[UIConfigManager colorTextLightGray]];
}

- (UILabel *)nameLabel
{
    if (_nameLabel == nil) {
        _nameLabel = [UILabel NNHWithTitle:@"BTC" titleColor:[UIColor akext_colorWithHex:@"#4e66b2"] font:[UIFont boldSystemFontOfSize:14]];
    }
    return _nameLabel;
}

- (UILabel *)availableLabel
{
    if (_availableLabel == nil) {
        _availableLabel = [UILabel NNHWithTitle:@"可用：100" titleColor:[UIConfigManager colorThemeBlack] font:[UIConfigManager fontThemeTextTip]];
    }
    return _availableLabel;
}

- (UILabel *)freezeLabel
{
    if (_freezeLabel == nil) {
        _freezeLabel = [UILabel NNHWithTitle:@"冻结：100" titleColor:[UIConfigManager colorThemeBlack] font:[UIConfigManager fontThemeTextTip]];
    }
    return _freezeLabel;
}

- (UILabel *)totalLabel
{
    if (_totalLabel == nil) {
        _totalLabel = [UILabel NNHWithTitle:@"全部：200" titleColor:[UIConfigManager colorThemeBlack] font:[UIConfigManager fontThemeTextTip]];
    }
    return _totalLabel;
}

- (UIButton *)buttonWithTitle:(NSString *)title
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIConfigManager colorThemeBlack] forState:UIControlStateNormal];
    [btn setTitleColor:[UIConfigManager colorThemeSeperatorDarkGray] forState:UIControlStateDisabled];
    [btn.titleLabel setFont:[UIConfigManager fontThemeTextTip]];
    [btn addTarget:self action:@selector(walletOperationAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = NNHMargin_5;
    btn.layer.borderColor = [UIConfigManager colorThemeSeperatorDarkGray].CGColor;
    btn.layer.borderWidth = 0.5;
    return btn;
}

@end
