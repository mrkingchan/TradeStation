//
//  WebChatPayH5VIew.m
//  One
//
//  Created by MJL on 2018/1/12.
//  Copyright © 2018年 MJL. All rights reserved.
//

#import "WebChatPayH5VIew.h"

@interface WebChatPayH5VIew ()<UIWebViewDelegate>

@property (strong, nonatomic) UIWebView *myWebView;

@property (assign, nonatomic) BOOL isLoading;

@end

@implementation WebChatPayH5VIew

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.myWebView = [[UIWebView alloc] initWithFrame:self.frame];
        [self addSubview:self.myWebView];
        self.myWebView.delegate = self;
    }
    return self;
}

#pragma mark 加载地址
- (void)loadingURL:(NSString *)url withIsWebChatURL:(BOOL)isLoading
{
    [self.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

    NSDictionary *headers = [request allHTTPHeaderFields];
    BOOL hasReferer = [headers objectForKey:@"Referer"] != nil;
    if (hasReferer) {
        return YES;
    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSURL *url = [request URL];
                NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
                //设置授权域名
                [request setValue:@"api.mocheg.cc://" forHTTPHeaderField: @"Referer"];
                [self.myWebView loadRequest:request];
            });
        });
        return NO;
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [SVProgressHUD showWithStatus:@"支付中..."];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{    
    [SVProgressHUD dismiss];
    if (self.closeWeixinPayBlcok) {
        self.closeWeixinPayBlcok();
    }
}

@end
