//
//  NNHMyHeaderView.m
//  ElegantTrade
//
//  Created by 牛牛 on 16/10/23.
//  Copyright © 2016年 牛牛汇. All rights reserved.
//

#import "NNHMyHeaderView.h"
#import "NNMineModel.h"

@interface NNHMyHeaderView ()

/** 昵称 */
@property (nonatomic, strong) UIButton *nameButton;
/** 身份认证 */
@property (nonatomic, strong) UIButton *idcardButton;

@end

@implementation NNHMyHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        [self setupChildView];
    }
    return self;
}

- (void)setupChildView
{
    [self addSubview:self.nameButton];
    [self.nameButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(NNHMargin_15);
    }];
    
    [self addSubview:self.idcardButton];
    [self.idcardButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.nameButton.mas_right).offset(NNHMargin_10);
        make.right.equalTo(self).offset(-15).priorityLow();
        make.height.equalTo(@25);
        make.width.equalTo(@70);
    }];
    
    [self.nameButton setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)setMineModel:(NNMineModel *)mineModel
{
    _mineModel = mineModel;
    
    if ([mineModel.userModel.mtoken isNotBlank]) {
        [self.nameButton setTitle:mineModel.userModel.nickname forState:UIControlStateNormal];
        self.idcardButton.hidden = NO;
        if ([mineModel.userModel.isnameauth integerValue] == 1) {
            self.idcardButton.enabled = NO;
            [self.idcardButton setTitle:@"实名认证" forState:UIControlStateNormal];
            [self.idcardButton setTitleColor:[UIColor akext_colorWithHex:@"8a662b"] forState:UIControlStateNormal];
            [self.idcardButton setBackgroundColor:[UIColor akext_colorWithHex:@"f0d3b0"] forState:UIControlStateNormal];
            self.idcardButton.layer.borderColor = [UIColor akext_colorWithHex:@"c0985d"].CGColor;
        }else if ([mineModel.userModel.isnameauth integerValue] == 2){
            self.idcardButton.enabled = NO;
            [self.idcardButton setTitle:@"审核中" forState:UIControlStateNormal];
            [self.idcardButton setTitleColor:[UIColor akext_colorWithHex:@"999999"] forState:UIControlStateNormal];
            [self.idcardButton setBackgroundColor:[UIColor akext_colorWithHex:@"f5f5f5"] forState:UIControlStateNormal];
            self.idcardButton.layer.borderColor = [UIColor akext_colorWithHex:@"cccccc"].CGColor;
        }else {
            self.idcardButton.enabled = YES;
            [self.idcardButton setTitle:@"未认证" forState:UIControlStateNormal];
            [self.idcardButton setTitleColor:[UIConfigManager colorThemeRed] forState:UIControlStateNormal];
            [self.idcardButton setBackgroundColor:[UIColor akext_colorWithHex:@"ffe7e8"] forState:UIControlStateNormal];
            self.idcardButton.layer.borderColor = [UIColor akext_colorWithHex:@"ffb2b5"].CGColor;
        }
    }else{
        [self.nameButton setTitle:@"请登录账号" forState:UIControlStateNormal];
        self.idcardButton.hidden = YES;
    }
}

- (void)jumpLogin
{
    if (self.headerViewJumpBlock) {
        if ([self.mineModel.userModel.mtoken isNotBlank]) {
            if (self.headerViewJumpBlock) self.headerViewJumpBlock(NNHMyHeaderViewJumpTypeInformation);
        }else {
            if (self.headerViewJumpBlock) self.headerViewJumpBlock(NNHMyHeaderViewJumpTypeLogin);
        }
    }
}

- (void)jumpRealName
{
    if (self.headerViewJumpBlock) self.headerViewJumpBlock(NNHMyHeaderViewJumpTypeRealName);
}

- (UIButton *)nameButton
{
    if (_nameButton == nil) {
        _nameButton = [UIButton NNHBtnTitle:@"请登录账号" titileFont:[UIFont boldSystemFontOfSize:24] backGround:[UIColor whiteColor] titleColor:[UIConfigManager colorThemeDark]];
        [_nameButton addTarget:self action:@selector(jumpLogin) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nameButton;
}

- (UIButton *)idcardButton
{
    if (_idcardButton == nil) {
        _idcardButton = [UIButton NNHBtnTitle:@"未认证" titileFont:[UIConfigManager fontThemeTextTip] backGround:[UIColor clearColor] titleColor:[UIConfigManager colorThemeRed]];
        [_idcardButton addTarget:self action:@selector(jumpRealName) forControlEvents:UIControlEventTouchUpInside];
        _idcardButton.layer.borderWidth = 0.5;
        _idcardButton.hidden = YES;
    }
    return _idcardButton;
}

@end
