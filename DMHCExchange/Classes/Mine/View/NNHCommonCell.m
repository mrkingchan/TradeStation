//
//  NNHCommonCell.m
//  NNHPlatform
//
//  Created by 牛牛 on 2017/2/28.
//  Copyright © 2017年 Smile intl. All rights reserved.
//

#import "NNHCommonCell.h"
#import "NNHMyItem.h"
#import "NNHFingerprintTool.h"

@interface NNHCommonCell ()

/** 标签 */
@property (strong, nonatomic) UILabel *rightLabel;
/** 箭头 */
@property (strong, nonatomic) UIImageView *rightArrow;
/** switch */
@property (strong, nonatomic) UISwitch *rightSwitch;
/** 箭头➕文字 / 箭头➕图片 */
@property (strong, nonatomic) UIView *rightView;
@property (strong, nonatomic) UIImageView *rightIconView;
@property (strong, nonatomic) UILabel *rightViewLabel;

@end

@implementation NNHCommonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.textColor = [UIConfigManager colorThemeDark];
        self.textLabel.font = [UIConfigManager fontThemeTextMain];
    }
    return self;
}

- (void)setMyItem:(NNHMyItem *)myItem
{
    _myItem = myItem;
    
    // 设置基本数据
    if (myItem.icon) self.imageView.image = [UIImage imageNamed:myItem.icon];
    self.textLabel.text = myItem.title;
    
    if (myItem.type == NNHItemAccessoryViewTypeArrow) {
        self.accessoryView = self.rightArrow;
    } else if (myItem.type == NNHItemAccessoryViewTypeSwitch){
        self.accessoryView = self.rightSwitch;
    } else if (myItem.type == NNHItemAccessoryViewTypeRightLabel) {
        self.rightLabel.text = myItem.rightTitle;
        // 根据文字计算尺寸
        NSMutableDictionary *fontAttrs = [NSMutableDictionary dictionary];
        fontAttrs[NSFontAttributeName] = self.rightLabel.font;
        self.rightLabel.nnh_size = [myItem.rightTitle sizeWithAttributes:fontAttrs];
        if (self.rightLabel.nnh_width > SCREEN_WIDTH - 140) self.rightLabel.nnh_width = SCREEN_WIDTH - 140;
        self.accessoryView = self.rightLabel;
    }else if (myItem.type == NNHItemAccessoryViewTypeRightView) {
        self.rightIconView.hidden = !myItem.rightIcon;
        self.rightViewLabel.hidden = !myItem.rightTitle;
        self.rightIconView.image = ImageName(myItem.rightIcon);
        self.rightViewLabel.text = myItem.rightTitle;
        if (myItem.rightTitleColor) {
            self.rightViewLabel.textColor = myItem.rightTitleColor;
        }else{
            self.rightViewLabel.textColor = [UIConfigManager colorTextLightGray];
        }
        self.accessoryView = self.rightView;
    }else if (myItem.type == NNHItemAccessoryViewTypeCustomView) {
        self.accessoryView = myItem.customRightView;
    }else { // 取消右边的内容
        self.accessoryView = nil;
    }
}

-(void)switchAction:(UISwitch *)sender
{
    if (sender.isOn) {
        [[NNHFingerprintTool sharedInstance] openFingerprintResults:^(BOOL success) {
            sender.on = success;
            if (success) [[NNHFingerprintTool sharedInstance] switchFingerprintStatus];
        }];
    }else{
        [[NNHFingerprintTool sharedInstance] switchFingerprintStatus];
        sender.on = NO;
    }
}

- (UIImageView *)rightArrow
{
    if (_rightArrow == nil) {
        _rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_right_arrow"]];
    }
    return _rightArrow;
}

- (UILabel *)rightLabel
{
    if (_rightLabel == nil) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.textColor = [UIConfigManager colorTextLightGray];
        _rightLabel.font = [UIFont systemFontOfSize:13];
        _rightLabel.lineBreakMode = NSLineBreakByTruncatingHead;
    }
    return _rightLabel;
}

- (UIView *)rightView
{
    if (_rightView == nil) {
        _rightView = [[UIView alloc] init];
        
        UIImageView *rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_right_arrow"]];
        [_rightView addSubview:self.rightViewLabel];
        [_rightView addSubview:rightArrow];
        [_rightView addSubview:self.rightIconView];
        
        [rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_rightView);
            make.centerY.equalTo(_rightView);
        }];
        [self.rightIconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(rightArrow.mas_left).offset(-NNHMargin_5);
            make.centerY.equalTo(_rightView);
        }];
        [self.rightViewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(rightArrow.mas_left).offset(-NNHMargin_5);
            make.centerY.equalTo(_rightView);
        }];
    }
    return _rightView;
}

- (UILabel *)rightViewLabel
{
    if (_rightViewLabel == nil) {
        _rightViewLabel = [UILabel NNHWithTitle:@"" titleColor:[UIConfigManager colorTextLightGray] font:[UIFont systemFontOfSize:13]];
        _rightViewLabel.hidden = YES;
    }
    return _rightViewLabel;
}

- (UIImageView *)rightIconView
{
    if (_rightIconView == nil) {
        _rightIconView = [[UIImageView alloc] init];
        _rightIconView.hidden = YES;
    }
    return _rightIconView;
}

- (UISwitch *)rightSwitch
{
    if (_rightSwitch == nil) {
        _rightSwitch = [[UISwitch alloc] init];
        [_rightSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        _rightSwitch.on = [[NNHFingerprintTool sharedInstance] openFingerprint];
    }
    return _rightSwitch;
}

@end
