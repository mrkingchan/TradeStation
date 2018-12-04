//
//  NNHRegisterAreaView.m
//  WBTWallet
//
//  Created by 牛牛 on 2018/3/6.
//  Copyright © 2018年 深圳市云牛惠科技有限公司. All rights reserved.
//

#import "NNRegisterAreaView.h"
#import "NNHRegisterChooseCodeCell.h"
#import "NNHCountryCodeModel.h"

@interface NNRegisterAreaView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;


@end

@implementation NNRegisterAreaView

- (instancetype)init
{
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor akext_colorWithHex:@"f4f4f4"];
        
        self.layer.cornerRadius = 2;
        self.layer.masksToBounds = YES;
        
        [self setupChildView];
    }
    return self;
}

- (void)setupChildView
{
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)setDataSource:(NSMutableArray<NNHCountryCodeModel *> *)dataSource
{
    _dataSource = dataSource;
    [self.tableView reloadData];
    
    if (dataSource.count) {
        self.selectedModel = dataSource[0];
    }
}

#pragma mark -
#pragma mark ---------UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NNHRegisterChooseCodeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NNHRegisterChooseCodeCell class])];
    NNHCountryCodeModel *codeModel= self.dataSource[indexPath.row];
    cell.codeModel = codeModel;
    return cell;
}

#pragma mark -
#pragma mark ---------UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NNHCountryCodeModel *codeModel= self.dataSource[indexPath.row];
    
    self.selectedModel = codeModel;
    
    if (self.selectedCodeBlock) {
        self.selectedCodeBlock(codeModel);
    }
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [UITableView nnhTableViewPlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = NNHNormalViewH;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView registerClass:[NNHRegisterChooseCodeCell class] forCellReuseIdentifier:NSStringFromClass([NNHRegisterChooseCodeCell class])];
    }
    return _tableView;
}

@end
