//
//  NNHPickerVeiw.m
//  NNHPlatform
//
//  Created by leiliao lai on 17/3/1.
//  Copyright © 2017年 牛牛汇. All rights reserved.
//

#define kPICKVIEW_WIDTH   [UIScreen mainScreen].bounds.size.width
#define kPICKVIEW_HEIGHT  [UIScreen mainScreen].bounds.size.height

#import "NNHPickerVeiw.h"

@interface NNHPickerVeiw () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *mainPickerView;
/** 长条白色View **/
@property (nonatomic, strong) UIView *viewWhite;
/** 确定按钮 **/
@property (nonatomic, strong) UIButton *btnSure;
/** 取消按钮 **/
@property (nonatomic, strong) UIButton *btnCancel;
/** 背后深色背景· **/
@property (nonatomic, strong) UIView *viewBackGround;
/** currentRow **/
@property (nonatomic, assign) NSInteger currentRow;
/** currentComponent **/
@property (nonatomic, assign) NSInteger currentComponent;

@end

@implementation NNHPickerVeiw
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self buildUI];
    }
    return self;
    
}
- (void)showWithAnimation:(BOOL)animation fatherView:(UIView *)fatherView
{
    /** 坐标转换成约束 **/
    if (![fatherView.subviews containsObject:self]) {
        [fatherView addSubview:self];
    }
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(fatherView);
    }];
    [self.mainPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_bottom);
        make.left.equalTo(self);
        make.width.equalTo(self);
        make.height.equalTo(@(200));
    }];
    [self.viewWhite mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mainPickerView.mas_top);
        make.height.equalTo(@44);
        make.left.right.equalTo(self.mainPickerView);
    }];
    [self.btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.viewWhite).offset(5);
        make.centerY.equalTo(self.viewWhite);
        make.width.equalTo(@60);
        make.height.equalTo(@40);
    }];
    [self.btnSure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.viewWhite).offset(-5);
        make.centerY.equalTo(self.viewWhite);
        make.width.equalTo(@60);
        make.height.equalTo(@40);
    }];
    
    [self setNeedsDisplay];
    [self layoutIfNeeded];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.mainPickerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.left.equalTo(self);
            make.width.equalTo(self);
            make.height.equalTo(@(200));
        }];
        self.viewBackGround.alpha = 0.5;
        [self setNeedsDisplay];
        [self layoutIfNeeded];
    }];
    
}

/** 输出对应的当前行 **/
- (NSInteger)selectedRowInComponent:(NSInteger)component
{
    return [self.mainPickerView selectedRowInComponent:component];
}

- (void)dismissWithAnimation:(BOOL)aniamtion
{
    [UIView animateWithDuration:0.3 animations:^{
        [self.mainPickerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self.mas_bottom);
            make.width.equalTo(self);
            make.height.equalTo(@(200));
        }];
        self.viewBackGround.alpha = 0.2;
        [self setNeedsDisplay];
        [self layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)reloadAllData
{
    [self.mainPickerView reloadAllComponents];
}

- (void)relaodDataWithComponent:(NSInteger)component
{
    [self.mainPickerView reloadComponent:component];
}

- (void)selectedRow:(NSInteger)row andComponent:(NSInteger)component andAnimation:(BOOL)animation
{
    [self.mainPickerView selectRow:row inComponent:component animated:animation];
    
}

- (void)buildUI
{
    [self addSubview:self.viewBackGround];
    [self addSubview:self.mainPickerView];
    [self addSubview:self.viewWhite];
    [self.viewWhite addSubview:self.btnCancel];
    [self.viewWhite addSubview:self.btnSure];
    
    [self.viewBackGround mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark -----------PickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.numberOfComponents) {
        return self.numberOfComponents();
    }
    return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (self.numberOfRows) {
        return self.numberOfRows(component);
    }
    return 0;
}

#pragma mark ------------PickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component __TVOS_PROHIBITED
{
    if (self.widthForComponent) {
        return self.widthForComponent(component);
    }
    return PLDefaultComponentWidth;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component __TVOS_PROHIBITED
{
    if (self.heightForComponent) {
        return self.heightForComponent(component);
    }
    return PLDefaultComponentHeight;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component __TVOS_PROHIBITED
{
    if (self.stringForComponentAndComponent) {
        return self.stringForComponentAndComponent(component,row);
    }
    return @"";
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view __TVOS_PROHIBITED
{
    if (self.viewForRowAndComponent) {
        return self.viewForRowAndComponent(component,row,view);
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component __TVOS_PROHIBITED
{
    self.currentRow = row;
    self.currentComponent = component;
    [self scrollActionToNewPlace];
}

- (void)scrollActionToNewPlace
{
    if (self.didScrollRowAndComponent) {
        self.didScrollRowAndComponent(self.currentComponent,self.currentRow);
    }
}

- (void)actionToSure
{
    if (self.didSelectedRowAndComponent) {
        self.didSelectedRowAndComponent(self.currentComponent,self.currentRow);
    }
    [self dismissWithAnimation:YES];
}

#pragma mark -----------PropertyList
- (UIView *)viewWhite
{
    if (_viewWhite == nil) {
        _viewWhite = [[UIView alloc] init];
        _viewWhite.backgroundColor = [UIColor akext_colorWithHex:@"#eeeeee"];
        
        UILabel *promptLabel = [UILabel NNHWithTitle:@"请选择" titleColor:[UIConfigManager colorThemeDarkGray] font:[UIConfigManager fontThemeTextImportant]];
        [_viewWhite addSubview:promptLabel];
        [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_viewWhite);
        }];
    }
    return _viewWhite;
}

- (UIButton *)btnSure
{
    if (_btnSure == nil) {
        _btnSure = [UIButton NNHBtnTitle:@"确定" titileFont:[UIConfigManager fontThemeTextMain] backGround:[UIColor akext_colorWithHex:@"#eeeeee"] titleColor:[UIColor akext_colorWithHex:@"268aec"]];
        [_btnSure addTarget:self action:@selector(actionToSure) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnSure;
}

- (UIButton *)btnCancel
{
    if (_btnCancel == nil) {
        _btnCancel = [UIButton NNHBtnTitle:@"取消" titileFont:[UIConfigManager fontThemeTextMain] backGround:[UIColor akext_colorWithHex:@"#eeeeee"] titleColor:[UIColor akext_colorWithHex:@"268aec"]];
        [_btnCancel addTarget:self action:@selector(dismissWithAnimation:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnCancel;
}

- (UIView *)viewBackGround
{
    if (_viewBackGround == nil) {
        _viewBackGround = [[UIView alloc]init];
        _viewBackGround.backgroundColor = [UIColor  blackColor];
        _viewBackGround.alpha = 0.2;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissWithAnimation:)];
        _viewBackGround.userInteractionEnabled = YES;
        [_viewBackGround addGestureRecognizer:tap];
    }
    return _viewBackGround;
}

- (UIPickerView *)mainPickerView
{
    if (_mainPickerView == nil) {
        _mainPickerView = [[UIPickerView alloc]init];
        _mainPickerView.backgroundColor = [UIColor whiteColor];
        _mainPickerView.delegate = self;
        _mainPickerView.dataSource = self;
    }
    return _mainPickerView;
}


@end
