//
//  NNHWebViewController.m
//  ElegantTrade
//
//  Created by 牛牛 on 16/11/3.
//  Copyright © 2016年 Smile intl. All rights reserved.
//

#import "NNWebViewController.h"
#import "YTKNetworkConfig.h"
#import <WebKit/WebKit.h>

@interface NNWebViewController () <WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webview;
@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation NNWebViewController

#pragma mark -
#pragma mark ---------Life Cycle
- (void)dealloc
{
    [self.webview loadHTMLString:@"" baseURL:nil];
    [self.webview removeObserver:self forKeyPath:@"title"];
    [self.webview removeObserver:self forKeyPath:@"estimatedProgress"];
    [self clearCache];
}

- (void)clearCache
{
    WKWebsiteDataStore *dateStore = [WKWebsiteDataStore defaultDataStore];
    [dateStore fetchDataRecordsOfTypes:[WKWebsiteDataStore allWebsiteDataTypes]
                     completionHandler:^(NSArray<WKWebsiteDataRecord *> * __nonnull records) {
                         for (WKWebsiteDataRecord *record  in records){
                             [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:record.dataTypes
                                                                       forDataRecords:@[record]
                                                                    completionHandler:^{
                                                                        
                                                                    }];
                         }
                     }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *backImage = [[UIImage imageNamed:@"ic_nav_back"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backImage style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    
    // 返回首页
    if (self.isBackHome) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(backHomeAction) image:@"ic_nav_home" highImage:@"ic_nav_home"];
    }
    
    // 初始化webview
    [self setupChildView];
    
    // 展示网页
    [self setupRequest];
    
    // kvo监听
    [self setupKVO];
}

- (void)setupRequest
{
    // 给本地链接增加协议
    if (![_url containsString:@"http"]) {
        _url = [NSString stringWithFormat:@"%@%@",[YTKNetworkConfig sharedConfig].cdnUrl,_url];
    }

    // 给允许的跳转的url 拼接mtoken 及 接口版本号
    if ([NNHProjectControlCenter sharedControlCenter].userControl.isLoginIn) {
        if ([_url containsString:@"?"]) {
            _url = [NSString stringWithFormat:@"%@&mtoken=%@",_url,[NNHProjectControlCenter sharedControlCenter].userControl_currentUserModel.mtoken];
        }else{
            _url = [NSString stringWithFormat:@"%@?mtoken=%@",_url,[NNHProjectControlCenter sharedControlCenter].userControl_currentUserModel.mtoken];
        }
    }
    // 拼接接口版本号
    if ([_url containsString:@"?"]) {
        _url = [NSString stringWithFormat:@"%@&_v=%@",_url,NNHPort];
    }else{
        _url = [NSString stringWithFormat:@"%@?&_v=%@",_url,NNHPort];
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_url]];
    [self.webview loadRequest:request];
}

- (void)setupKVO
{
    // KVO监听属性改变 KVO注意点.一定要记得移除 (title／estimatedProgress)
    [self.webview addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    [self.webview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)setupChildView
{
    [self.view addSubview:self.webview];
    [self.webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@1);
    }];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backHomeAction
{
    POST_NOTIFICATION(NNH_NotificationBackHome)
    [self.navigationController popToRootViewControllerAnimated:NO];
}

#pragma mark -
#pragma mark ---------WKNavigationDelegate
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
//
//    decisionHandler(WKNavigationActionPolicyAllow);//允许跳转
//
//}

#pragma mark - KVO
#pragma mark ---------只要观察对象属性有新值就会调用
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (self.navTitle) {
        self.navigationItem.title = self.navTitle;
    }else{
        if (self.webview.title.length) {
            self.navigationItem.title = self.webview.title;
        }
    }

    self.progressView.progress = self.webview.estimatedProgress;
    self.progressView.hidden = self.webview.estimatedProgress >= 1;
}

#pragma mark -
#pragma mark ---------Getters & Setters
- (WKWebView *)webview
{
    if (_webview == nil) {
        _webview = [[WKWebView alloc] init];
        _webview.navigationDelegate = self;
    }
    return _webview;
}

- (UIProgressView *)progressView
{
    if (_progressView == nil) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.tintColor = [UIConfigManager colorThemeRed];
    }
    return _progressView;
}

@end
