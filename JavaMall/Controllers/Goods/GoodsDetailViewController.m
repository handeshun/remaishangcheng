//
// Created by Dawei on 1/31/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "GoodsDetailViewController.h"
#import "Masonry.h"

@implementation GoodsDetailViewController {
    UIWebView *webView;
}

@synthesize goodsId;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI {
    webView = [UIWebView new];
    [self.view addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-45);
    }];

    NSURL *url = [NSURL URLWithString:[@"http://h2.shopdmp.com" stringByAppendingFormat:@"/mobile/goods-%d.html", goodsId]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

@end
