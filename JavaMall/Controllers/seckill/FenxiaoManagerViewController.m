//
//  FenxiaoManagerViewController.m
//  JavaMall
//
//  Created by Cheerue on 2017/9/2.
//  Copyright © 2017年 Enation. All rights reserved.
//

#import "FenxiaoManagerViewController.h"
#import "HomeHeaderView.h"

#import "ControllerHelper.h"
#import "ScanViewController.h"
#import "RDVTabBarController.h"
#import "SearchViewController.h"
#import "EMConversation.h"
#import "EaseMessageViewController.h"
#import "ChatViewController.h"
#import "MyOrderListViewController.h"
#import "Order.h"
#import "ToastUtils.h"
#import "Constants.h"
#import "Setting.h"
#import "SystemApi.h"
#import "StoreListViewController.h"
#import "HeaderView.h"
@interface FenxiaoManagerViewController ()<EMChatManagerDelegate> {
    
}


@end

@implementation FenxiaoManagerViewController{
    HomeHeaderView *headerView;
    UIWebView *webView;
    NSString *homeJavaScript;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 20)];
    topView.backgroundColor =[UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];

    [self.view addSubview:topView];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"home" ofType:@"js"];
    homeJavaScript = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    webView.backgroundColor = [UIColor redColor];
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height )];
    NSString *str = [NSString stringWithFormat:@"http://h2.shopdmp.com/mobile/storenav.html?uname=%@",self.uname];
    NSString* encodedString = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",str);
    NSURL *url = [NSURL URLWithString:encodedString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    webView.scrollView.delegate = self;
    webView.delegate = self;
    
 
    [self.view addSubview:webView];
    

}

-(void)backBtnDown
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - webViewDelegate

- (void)webViewDidFinishLoad:(nonnull UIWebView *)webView {
    [webView stringByEvaluatingJavaScriptFromString:homeJavaScript];
//    [webView.scrollView.header endRefreshing];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *requestString = [[request URL] absoluteString];
    
    NSString *protocol = @"app://";
    if ([requestString hasPrefix:protocol]) {
        NSString *requestContent = [requestString substringFromIndex:[protocol length]];
        NSArray *vals = [requestContent componentsSeparatedByString:@"/"];
        if ([vals[0] isEqualToString:@"showgoods"]) {
            [self showGoods:vals[1]];
        } else if ([vals[0] isEqualToString:@"showlist"]) {
            [self showList:[vals[1] intValue]];
        } else if ([vals[0] isEqualToString:@"changetab"]) {
               [self.navigationController popViewControllerAnimated:YES];
            [self changeTab:vals[1]];
        } else if ([vals[0] isEqualToString:@"myorder"]) {
            [self myorder];
        } else if ([vals[0] isEqualToString:@"showbrand"]) {
            [self showBrand:[vals[1] intValue]];
        } else {
            [webView stringByEvaluatingJavaScriptFromString:@"alert('未定义操作');"];
        }
        return NO;
    }
    return YES;
}

/**
 * 显示商品详情
 */
- (void)showGoods:(NSString *)goodsid {
    [[self rdv_tabBarController].navigationController pushViewController:[ControllerHelper createGoodsViewControllerWithId:[goodsid intValue]] animated:YES];
}

/**
 * 显示分类下的商品列表
 */
- (void)showList:(int)catid {
    [[self rdv_tabBarController].navigationController pushViewController:[ControllerHelper createGoodsListViewController:catid categoryName:@"" keyword:@"" brandId:0] animated:YES];
}

/**
 * 显示品牌下的商品列表
 */
- (void)showBrand:(int)brandid {
    [[self rdv_tabBarController].navigationController pushViewController:[ControllerHelper createGoodsListViewController:0 categoryName:@"" keyword:@"" brandId:brandid] animated:YES];
}

/**
 * 切换tab
 */
- (void)changeTab:(NSString *)index {
    [self rdv_tabBarController].selectedIndex = [index intValue] - 2;
}

/**
 * 我的订单
 */
- (void)myorder {
    if (![ControllerHelper isLogined]) {
        [ToastUtils show:@"请您登录后进行此项操作！"];
        [self presentViewController:[ControllerHelper createLoginViewController] animated:YES completion:nil];
        return;
    }
    MyOrderListViewController *myOrderListViewController = [MyOrderListViewController new];
    myOrderListViewController.status = OrderStatus_ALL;
    [[self rdv_tabBarController].navigationController pushViewController:myOrderListViewController animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
