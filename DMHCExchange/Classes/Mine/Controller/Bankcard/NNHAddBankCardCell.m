//
//  NNHBankCardAddCell.m
//  NNCivetCat
//
//  Created by 来旭磊 on 17/3/30.
//  Copyright © 2017年 灵猫. All rights reserved.
//

#import "NNHAddBankCardCell.h"
#import "NNHBankCardItem.h"

@interface NNHAddBankCardCell ()

/** <#注释#> */
@property (nonatomic, strong) UILabel *itemNameLabel;
/** 左侧文本输入框 */
@property (nonatomic, strong) UITextField *leftTextField;
/** 箭头 */
@property (strong, nonatomic) UIImageView *rightArrow;
/** 标签 */
@property (strong, nonatomic) UILabel *rightLabel;
/**  箭头➕文字 */
@property (strong, nonatomic) UIView *rightView;

@end



@implementation NNHAddBankCardCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.font = [UIConfigManager fontThemeTextDefault];
        [self.contentView addSubview:self.leftTextField];
        [self.leftTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(90);
            make.top.bottom.equalTo(self.contentView);
            make.width.equalTo(@(SCREEN_WIDTH - 100));
        }];
    }
    return self;
}


- (void)setCurrentIndexPath:(NSIndexPath *)currentIndexPath
{
    _currentIndexPath = currentIndexPath;
    if (currentIndexPath.row == 1 || currentIndexPath.row == 4) {
        self.leftTextField.keyboardType = UIKeyboardTypeNumberPad;
    }else{
        self.leftTextField.keyboardType = UIKeyboardTypeDefault;
    }
}

- (void)setCardCellItem:(NNHBankCardItem *)cardCellItem
{
    _cardCellItem = cardCellItem;
    self.textLabel.text = cardCellItem.itemName;
    
    if (cardCellItem.itemRightText) {
        self.leftTextField.hidden = YES;
        self.accessoryView = self.rightView;
        self.rightLabel.text = cardCellItem.itemRightText;
    }else {
        self.leftTextField.hidden = NO;
        self.leftTextField.placeholder = cardCellItem.itemPlaceHolder;
        self.accessoryView = nil;
    }
    
    if (cardCellItem.itemText) {
        self.leftTextField.text = cardCellItem.itemText;
    }
    
    if (cardCellItem.hasArrow) {
        self.rightArrow.hidden = NO;
    }else {
        self.rightArrow.hidden = YES;
    }
    self.leftTextField.userInteractionEnabled = !cardCellItem.noneEdit;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (self.currentIndexPath.row == 4) {
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
        }
        
        if (![textField.text checkIsPhoneNumber] && textField.text.length == 11) {
            [SVProgressHUD showMessage:@"输入手机号格式不正确"];
        }
    }
    
    if (self.didChangedTextFieldBlock) {
        self.didChangedTextFieldBlock(textField.text, self.currentIndexPath);
    }
}

#pragma mark -
#pragma mark ---------Getter && Setter

- (UIImageView *)rightArrow
{
    if (_rightArrow == nil) {
        _rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_icon_arrow"]];
    }
    return _rightArrow;
}

- (UILabel *)rightLabel
{
    if (_rightLabel == nil) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.textColor = [UIConfigManager colorThemeDarkGray];
        _rightLabel.font = [UIFont systemFontOfSize:13];
    }
    return _rightLabel;
}

- (UIView *)rightView
{
    if (_rightView == nil) {
        _rightView = [[UIView alloc] init];
        [_rightView addSubview:self.rightLabel];
        [_rightView addSubview:self.rightArrow];
        [self.rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_rightView);
            make.centerY.equalTo(_rightView);
        }];
        [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.rightArrow.mas_left).offset(-NNHMargin_5);
            make.centerY.equalTo(_rightView);
        }];
    }
    return _rightView;
}

- (UITextField *)leftTextField
{
    if (_leftTextField == nil) {
        _leftTextField = [[UITextField alloc] init];
        _leftTextField.textColor = [UIConfigManager colorThemeBlack];
        _leftTextField.font = [UIFont systemFontOfSize:13];
        [_leftTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _leftTextField;
}


@end
