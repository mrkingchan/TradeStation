//
//  Y-StockChartView.m
//  BTC-Kline
//
//  Created by yate1996 on 16/4/30.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import "Y_StockChartView.h"
#import "Y_KLineView.h"
#import "Masonry.h"
#import "Y_StockChartGlobalVariable.h"
#import "NNKlineSegementView.h"
#import "NNDropListView.h"
@interface Y_StockChartView()

/**
 *  K线图View
 */
@property (nonatomic, strong) Y_KLineView *kLineView;

/**
 *  底部选择View
 */

@property (nonatomic, strong) NNKlineSegementView *segementView;


/**
 *  图表类型
 */
@property(nonatomic,assign) Y_StockChartCenterViewType currentCenterViewType;

/**
 *  当前索引
 */
@property(nonatomic,assign,readwrite) NSInteger currentIndex;

@end

@implementation Y_StockChartView {
    __block NSInteger _selectedIndex;  //选中索引
}

#pragma mark - initialize method
- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.segementView];
        [_segementView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.equalTo(@45);
        }];
        
        [self addSubview:self.kLineView];
        [_kLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self);
            make.top.equalTo(self.segementView.mas_bottom);
        }];
        
        //默认日线
        [self.segementView setSelectedIndex:3];
        _selectedIndex = 8;
    }
    return self;
}

#pragma mark - lazy load
- (Y_KLineView *)kLineView {
    if(!_kLineView) {
        _kLineView = [Y_KLineView new];
    }
    return _kLineView;
}

- (NNKlineSegementView *)segementView{
    if (!_segementView) {
        _segementView = [NNKlineSegementView nKlineSegementViewWithArray:@[@"15分",@"1小时",@"4小时",@"日线",@"更多",@"指标"] complete:^(NSInteger index1) {
            [self removeCurrentDropView];
            if (index1 <4 ) {
                switch (index1) {
                    case 0:
                        _selectedIndex = 4;
                        break;
                    case 1:
                        _selectedIndex = 6;
                        break;
                    case 2:
                        _selectedIndex = 7;
                        break;
                    case 3:
                        _selectedIndex = 8;
                        break;
                    default:
                        break;
                }
                [self loadkLineDataAndRefresh];
                if (index1 <=3) {
                    [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:@"displayHM"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    if (index1 == 3) {
                        [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:@"displayHM"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                }
            } else if (index1 == 4) {
                    [NNDropListView nnDropListViewWithArray:@[@"1分",@"5分",@"30分",@"周线"]
                                                   complete:^(NSString * _Nonnull subStr, NSInteger index) {
                                                       switch (index) {
                                                           case 0:
                                                               _selectedIndex = 2;
                                                               break;
                                                           case 1:
                                                               _selectedIndex = 3;
                                                               break;
                                                           case 2:
                                                               _selectedIndex = 5;
                                                               break;
                                                           case 3:
                                                               _selectedIndex = 9;
                                                               break;
                                                           default:
                                                               break;
                                                       }
                                                       if (index <3) {
                                                           [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:@"displayHM"];
                                                           [[NSUserDefaults standardUserDefaults] synchronize];
                                                       } else {
                                                           [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:@"displayHM"];
                                                           [[NSUserDefaults standardUserDefaults] synchronize];
                                                       }
                                                       [_segementView replaceTagWithContent:subStr index:index1];
                                                       [self loadkLineDataAndRefresh];
                                                   }];
                } else if (index1 == 5) {
                    //主指标和副指标
                    [NNDropListView nnDropListViewWithArray:@[@"主图    |",@"MA",@"EMA",@"BOLL",
                                                              @"副图    |",@"MACD",@"KDJ"] complete:^(NSString * _Nonnull subStr, NSInteger index) {
                        _selectedIndex = index<=3? index + 102: 95 + index;
                        if (self.kLineView.kLineModels.count) {
                            //容错判断
                            if (_selectedIndex == 105 ) {
                                //BOLL
                                [Y_StockChartGlobalVariable setisBOLLLine:Y_StockChartTargetLineStatusBOLL];
                                self.kLineView.targetLineStatus = 105;
                                [self.kLineView reDraw];
                            } else {
                                [Y_StockChartGlobalVariable setisEMALine:_selectedIndex];
                                self.kLineView.targetLineStatus = _selectedIndex;
                                [self.kLineView reDraw];
                            }
                        }
                    }];
            }
        }];
    }
    return _segementView;
}

#pragma mark - load kline Data and refresh Kline
- (void)loadkLineDataAndRefresh {
    if (_selectedIndex < 100) {
        if (_dataSource && [_dataSource respondsToSelector:@selector(stockDatasWithIndex:)]) {
            id stockData = [_dataSource stockDatasWithIndex:_selectedIndex];
            if (!stockData) {
                return ;
            }
            Y_StockChartViewItemModel *itemModel = self.itemModels[_selectedIndex];
            Y_StockChartCenterViewType type = itemModel.centerViewType;
            if(type != self.currentCenterViewType) {
                self.currentCenterViewType = type;
                switch (type) {
                    case Y_StockChartcenterViewTypeKline: {
                        self.kLineView.hidden = NO;
                    }
                        break;
                    default:
                        break;
                }
            }
            if(type == Y_StockChartcenterViewTypeOther) {
                
            } else {
                //刷新k线图
                self.kLineView.kLineModels = (NSArray *)stockData;
                self.kLineView.MainViewType = type;
                [self.kLineView reDraw];
            }
        }
    }
}

///MARK:setter Method
- (void)setItemModels:(NSArray *)itemModels {
    _itemModels = itemModels;
    if(itemModels) {
        //左侧items
        NSMutableArray *items = [NSMutableArray array];
        for(Y_StockChartViewItemModel *item in itemModels) {
            [items addObject:item.title];
        }
        Y_StockChartViewItemModel *firstModel = itemModels.firstObject;
        self.currentCenterViewType = firstModel.centerViewType;
    }
    if(self.dataSource){
        _selectedIndex = 8;
        [self loadkLineDataAndRefresh];
    }
}

- (void)setDataSource:(id<Y_StockChartViewDataSource>)dataSource {
    _dataSource = dataSource;
    if(self.itemModels) {
        _selectedIndex = 8;
        [self loadkLineDataAndRefresh];
    }
}

- (void)reloadData {
    [self loadkLineDataAndRefresh];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self removeCurrentDropView];
}

- (void)removeCurrentDropView {
    [[UIApplication sharedApplication].keyWindow.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NNDropListView class]]) {
            [obj removeFromSuperview];
        }
    }];
}

@end

/************************ItemModel类************************/
@implementation Y_StockChartViewItemModel

+ (instancetype)itemModelWithTitle:(NSString *)title
                              type:(Y_StockChartCenterViewType)type {
    Y_StockChartViewItemModel *itemModel = [Y_StockChartViewItemModel new];
    itemModel.title = title;
    itemModel.centerViewType = type;
    return itemModel;
}
@end
