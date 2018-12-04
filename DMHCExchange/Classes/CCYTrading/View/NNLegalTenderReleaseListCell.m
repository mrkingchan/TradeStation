//
//  NNLegalTenderReleaseListCell.m
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/26.
//  Copyright © 2018 超级钱包. All rights reserved.
//

#import "NNLegalTenderReleaseListCell.h"
#import "NNLegalTenderTradeReleaseOrderListModel.h"

@interface NNLegalTenderReleaseListCell ()

/** 状态 */
@property (nonatomic, strong) UIView  *statusView;
/** 名称 */
@property (nonatomic, strong) UILabel *nameLabel;
/** 时间 */
@property (nonatomic, strong) UILabel *timeLabel;
/** 订单状态 */
@property (nonatomic, strong) UILabel *statusLabel;
/** 委托价格 */
@property (nonatomic, strong) UILabel *orderPriceLabel;
/** 委托数量 */
@property (nonatomic, strong) UILabel *orderCountLabel;
/** 已成交数量 */
@property (nonatomic, strong) UILabel *transactionCountLabel;
/** 取消按钮 */
@property (nonatomic, weak) UIButton *cancleButton;

@end

@implementation NNLegalTenderReleaseListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIConfigManager colorThemeWhite];
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
    
    [self.contentView addSubview:self.statusView];
    [self.statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.centerY.equalTo(self.nameLabel);
        make.height.equalTo(self.nameLabel);
        make.width.equalTo(@5);
    }];
    
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).offset(NNHMargin_10);
        make.baseline.equalTo(self.nameLabel);
    }];
    
    [self.contentView addSubview:self.statusLabel];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel);
        make.right.equalTo(self.contentView).offset(-NNHMargin_15);
    }];
    
    UILabel *orderPriceLabel = [UILabel NNHWithTitle:@"委托价格" titleColor:[UIConfigManager colorTextLightGray] font:[UIConfigManager fontThemeTextTip]];
    [self.contentView addSubview:orderPriceLabel];
    [orderPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(NNHMargin_15);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(NNHMargin_20);
    }];
    
    [self.contentView addSubview:self.orderPriceLabel];
    [self.orderPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(orderPriceLabel.mas_right).offset(NNHMargin_15);
        make.centerY.equalTo(orderPriceLabel);
    }];
    
    UILabel *orderCountLabel = [UILabel NNHWithTitle:@"委托数量" titleColor:[UIConfigManager colorTextLightGray] font:[UIConfigManager fontThemeTextTip]];
    [self.contentView addSubview:orderCountLabel];
    [orderCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_centerX).offset(-NNHMargin_25);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(NNHMargin_20);
    }];
    
    [self.contentView addSubview:self.orderCountLabel];
    [self.orderCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(orderCountLabel.mas_right).offset(NNHMargin_15);
        make.centerY.equalTo(orderPriceLabel);
    }];
    
    
    UILabel *transactionCountLabel = [UILabel NNHWithTitle:@"已成交量" titleColor:[UIConfigManager colorTextLightGray] font:[UIConfigManager fontThemeTextTip]];
    [self.contentView addSubview:transactionCountLabel];
    [transactionCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(orderPriceLabel);
        make.top.equalTo(orderPriceLabel.mas_bottom).offset(NNHMargin_10);
    }];
    
    [self.contentView addSubview:self.transactionCountLabel];
    [self.transactionCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(transactionCountLabel.mas_right).offset(NNHMargin_15);
        make.centerY.equalTo(transactionCountLabel);
    }];
    
    UIButton *cancleButton = [UIButton NNHBorderBtnTitle:@"撤销" borderColor:[UIConfigManager colorThemeSeperatorDarkGray] titleColor:[UIConfigManager colorThemeBlack]];
    self.cancleButton = cancleButton;
    [cancleButton addTarget:self action:@selector(cancleOrderAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:cancleButton];
    [cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-NNHMargin_15);
        make.bottom.equalTo(self.contentView).offset(-NNHMargin_10);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
}

- (void)setOrderModel:(NNLegalTenderTradeReleaseOrderListModel *)orderModel
{
    _orderModel = orderModel;
    
    NNLegalTenderTradeReleaseOrderListActionModel *actionModel = orderModel.tradeact;
    
    self.nameLabel.text = orderModel.coinname;
    self.timeLabel.text = orderModel.addtime;
    self.statusLabel.text = actionModel.statusstr;
    self.orderPriceLabel.text = orderModel.price;
    self.orderCountLabel.text = orderModel.totalnum;
    self.transactionCountLabel.text = orderModel.dealnum;
    
    if ([orderModel.type isEqualToString:@"1"]) {
        self.statusView.backgroundColor = [UIColor akext_colorWithHex:@"#3fbe72"];
    }else {
        self.statusView.backgroundColor = [UIConfigManager colorThemeRed];
    }
    
    self.cancleButton.hidden = actionModel.actstr.length == 0;
    [self.cancleButton setTitle:actionModel.actstr forState:UIControlStateNormal];
    
}

- (void)cancleOrderAction
{
    if (self.cancleOperationBlock) {
        self.cancleOperationBlock();
    }
}

#pragma mark - Lazy Loads
- (UIView *)statusView
{
    if (_statusView == nil) {
        _statusView = [[UIView alloc] init];
        _statusView.backgroundColor = [UIConfigManager colorThemeRed];
    }
    return _statusView;
}

- (UILabel *)nameLabel
{
    if (_nameLabel == nil) {
        _nameLabel = [UILabel NNHWithTitle:@"USDT" titleColor:[UIColor akext_colorWithHex:@"#1a3b55"] font:[UIFont boldSystemFontOfSize:18]];
    }
    return _nameLabel;
}

- (UILabel *)timeLabel
{
    if (_timeLabel == nil) {
        _timeLabel = [UILabel NNHWithTitle:@"2018-10-26" titleColor:[UIConfigManager colorTextLightGray] font:[UIConfigManager fontThemeTextTip]];
    }
    return _timeLabel;
}

- (UILabel *)statusLabel
{
    if (_statusLabel == nil) {
        _statusLabel = [UILabel NNHWithTitle:@"待成交" titleColor:[UIColor akext_colorWithHex:@"#3fbe72"] font:[UIFont boldSystemFontOfSize:13]];
    }
    return _statusLabel;
}

- (UILabel *)orderPriceLabel
{
    if (_orderPriceLabel == nil) {
        _orderPriceLabel = [UILabel NNHWithTitle:@"6.98" titleColor:[UIConfigManager colorThemeBlack] font:[UIConfigManager fontThemeTextTip]];
    }
    return _orderPriceLabel;
}

- (UILabel *)orderCountLabel
{
    if (_orderCountLabel == nil) {
        _orderCountLabel = [UILabel NNHWithTitle:@"60" titleColor:[UIConfigManager colorThemeBlack] font:[UIConfigManager fontThemeTextTip]];
    }
    return _orderCountLabel;
}

- (UILabel *)transactionCountLabel
{
    if (_transactionCountLabel == nil) {
        _transactionCountLabel = [UILabel NNHWithTitle:@"100" titleColor:[UIConfigManager colorThemeBlack] font:[UIConfigManager fontThemeTextTip]];
    }
    return _transactionCountLabel;
}



@end
