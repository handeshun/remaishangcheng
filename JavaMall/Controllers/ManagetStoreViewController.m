//
//  ManagetStoreViewController.m
//  JavaMall
//
//  Created by Cheerue on 2017/9/5.
//  Copyright © 2017年 Enation. All rights reserved.
//

#import "ManagetStoreViewController.h"
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

@interface ManagetStoreViewController ()<EMChatManagerDelegate>

@end

@implementation ManagetStoreViewController{
    HomeHeaderView *headerView;
    UIWebView *webView;
    NSString *homeJavaScript;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kStatusBarHeight)];
    topView.backgroundColor =[UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
    [self.view addSubview:topView];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"home" ofType:@"js"];
    homeJavaScript = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, kScreen_Width, kScreen_Height-kStatusBarHeight )];
    NSString *str = [NSString stringWithFormat:@"http://h2.shopdmp.com/mobile/storenav.html?uname=%@",self.username];
    NSURL *url = [NSURL URLWithString:str];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    webView.scrollView.delegate = self;
    webView.delegate = self;
    [self.view addSubview:webView];
    
    //    headerView = [[HomeHeaderView alloc] init];
    //
    //    [self.view addSubview:headerView];
    //    [headerView setSearchAction:@selector(searchAction)];
    //    [headerView setScanAction:@selector(scanAction)];
    //  [self makeNav];
    [self loadData];
}
-(void)makeNav
{
    HeaderView * headerView1 = [[HeaderView alloc] initWithTitle:@"邀请开店"];
    [headerView1 setBackAction:@selector(backBtnDown)];
    [self.view addSubview:headerView1];
    
}
-(void)backBtnDown
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

/**
 * 载入系统配置
 */
- (void)loadData {
    //获取系统配置
    //    [ToastUtils showLoading];
    //    [[SystemApi new] setting:^(Setting *setting) {
    //        [Constants setSetting:setting];
    //        [self initIM];
    //        [ToastUtils hideLoading];
    //    }                failure:^(NSError *error) {
    //        Setting *setting = [Setting new];
    //        setting.services = [NSMutableArray arrayWithCapacity:0];
    //        [Constants setSetting:setting];
    //        [self initIM];
    //        [ToastUtils hideLoading];
    //    }];
}

/**
 * 设置客服是否显示
 */
- (void)initIM {
    if(![Constants showIM]){
        [headerView hideIM];
    }
}


/**
 * 滚动时调整HeaderView的背景色透明度
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < 0) {
        [headerView setBackgroundAlpha:0.0];
        return;
    }
    if (scrollView.contentOffset.y > kHomeAdvHeight) {
        [headerView setBackgroundAlpha:0.8];
        return;
    }
    [headerView setBackgroundAlpha:(scrollView.contentOffset.y / kHomeAdvHeight)];
}

/**
 * 扫一扫
 */
- (void)scanAction {
    ScanViewController *scanViewController = [ScanViewController new];
    [[self rdv_tabBarController].navigationController pushViewController:scanViewController animated:YES];
}

/**
 * 消息
 */
- (void)imAction {
    if(![Constants isLogin]){
        [ToastUtils show:@"请您登录后进行此项操作！"];
        [self presentViewController:[ControllerHelper createLoginViewController] animated:YES completion:nil];
        return;
    }
    ChatViewController *chatViewController = [ControllerHelper createChatViewController];
    if (chatViewController == nil)
        return;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:chatViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

/**
 *  搜索
 *
 *  @param gesture
 */
- (void)searchAction {
    SearchViewController *searchViewController = [SearchViewController new];
    searchViewController.delegate = self;
    [self presentViewController:searchViewController animated:YES completion:nil];
}

/**
 * 搜索代理方法
 */
- (void)search:(NSString *)_keyword searchType:(NSInteger)searchType{
    if(searchType == 0) {
        [[self rdv_tabBarController].navigationController pushViewController:[ControllerHelper createGoodsListViewController:0 categoryName:nil keyword:_keyword brandId:0] animated:YES];
    }else{
        StoreListViewController *storeListViewController = [StoreListViewController new];
        storeListViewController.keyword = _keyword;
        [[self rdv_tabBarController].navigationController pushViewController:storeListViewController animated:YES];
    }
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
    [self rdv_tabBarController].selectedIndex = [index intValue] - 1;
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
