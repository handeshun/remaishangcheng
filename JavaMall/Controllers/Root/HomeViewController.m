//
// Created by Dawei on 1/4/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeHeaderView.h"
#import "MJRefresh.h"
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
#import "LBMoreSecKillVC.h"
#import "PintuanListViewController.h"
#import "FightgroupsViewController.h"
#import "CartApi.h"
#import "StoreAddressListViewController.h"
#import "AddressApi.h"
#import "Address.h"
#import <CoreLocation/CoreLocation.h>
#define isIOS(version) ([[UIDevice currentDevice].systemVersion floatValue] >= version)
@interface HomeViewController () <EMChatManagerDelegate,CLLocationManagerDelegate>
@property (nonatomic,strong)CLLocationManager *manager;
@property (nonatomic,copy) NSString *longDoubleStr;
@property (nonatomic,copy) NSString *latDoubleStr;
@property (nonatomic,assign) double longDouble;
@property (nonatomic,assign) double latDouble;
@property (nonatomic,assign) NSInteger dingWeiStatus;// YES 定位打开

@end

@implementation HomeViewController {
    HomeHeaderView *headerView;
    UIWebView *webView;
    NSString *homeJavaScript;
    CartApi *cartApi;
    AddressApi *addressApi;
    NSMutableArray *addressArray;
    
    UILabel *addressLab;
    UIButton *addressView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    cartApi = [CartApi new];
    addressApi = [AddressApi new];
    addressArray = [[NSMutableArray alloc] initWithCapacity:0];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"home" ofType:@"js"];
    homeJavaScript = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];

    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, kTopHeight-4, kScreen_Width, kScreen_Height-kTopHeight-49+4 )];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://h2.shopdmp.com/mobile/index.html"]];

    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    webView.scrollView.delegate = self;
    webView.delegate = self;
   [webView stringByEvaluatingJavaScriptFromString:homeJavaScript];
    //下拉刷新
    __weak UIScrollView *scrollView = webView.scrollView;
    scrollView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [webView reload];
    }];
    [self.view addSubview:webView];

    headerView = [[HomeHeaderView alloc] init];
    [headerView hideIM];
    [self.view addSubview:headerView];
    [headerView setSearchAction:@selector(searchAction)];
    [headerView setScanAction:@selector(scanAction)];
    [headerView setDressAction:@selector(dressAction)];
    
    addressView = [[UIButton alloc]init];
    addressView.frame =CGRectMake(0, kTopHeight-4, kScreen_Width, 30);
    addressView.backgroundColor = [[UIColor whiteColor]  colorWithAlphaComponent:0.9];
    [addressView addTarget:self action:@selector(dressAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addressView];
    
    UIImageView *addressimg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 8, 12, 15)];
    addressimg.image = [UIImage imageNamed:@"home_dress1"];
    [addressView addSubview:addressimg];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 29.5, SCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = LBColor(231, 231, 231);
    [addressView addSubview:lineView];
    
    addressLab = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, kScreen_Width-60, 30)];
    addressLab.textColor = [UIColor colorWithHexString:@"#848689"];
    addressLab.font = [UIFont systemFontOfSize:13];
    addressLab.adjustsFontSizeToFitWidth = YES;
    addressLab.textAlignment =NSTextAlignmentLeft;
    [addressView addSubview:addressLab];
  
    [self.manager startUpdatingLocation];
   // [self openLocation];//开始定位
    [self loadData];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cartChangedCompletion:) name:nchangStoreAddress object:nil];
}
- (void)cartChangedCompletion:(NSNotification *)notification {
    NSLog(@"%@",notification.object);
    addressLab.text = notification.object;
}

-(void)loadaddress
{
    
    [addressApi getAddress:self.latDouble lon:self.longDouble success:^(NSMutableArray *address) {
        [addressArray removeAllObjects];
        [addressArray addObjectsFromArray:address];
        if(addressArray.count>0)
        {
            Address *add = [addressArray firstObject];
            
            NSString *address = [NSString stringWithFormat:@"%@:%@",add.store_name,add.attr];
            addressLab.text = address;
        }
    } failure:^(NSError *error) {
        [ToastUtils show:[error localizedDescription]];
    }];
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
 * 设置StatusBar颜色为白色
 */
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

/**
 * 滚动时调整HeaderView的背景色透明度
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (scrollView.contentOffset.y < 0) {
//        //[headerView setBackgroundAlpha:0.0];
//        [addressView setAlpha: 0.5];
//        return;
//    }
//    if (scrollView.contentOffset.y > kTopHeight) {
//      //  [headerView setBackgroundAlpha:0.8];
//        [addressView setAlpha:  1.0];
//        return;
//    }
   // [headerView setBackgroundAlpha:(scrollView.contentOffset.y / kHomeAdvHeight)];
   // [addressView setAlpha: (scrollView.contentOffset.y / kTopHeight)+0.5];
}

/**
 * 扫一扫
 */
- (void)scanAction {
    ScanViewController *scanViewController = [ScanViewController new];
    [[self rdv_tabBarController].navigationController pushViewController:scanViewController animated:YES];
}

/**
 * 定位
 */
- (void)dressAction {
    StoreAddressListViewController *vc = [StoreAddressListViewController new];
    [[self rdv_tabBarController].navigationController pushViewController:vc animated:YES];
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
    [webView.scrollView.header endRefreshing];
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
            [self showList:[vals[1] intValue] name:vals[2]];
        } else if ([vals[0] isEqualToString:@"changetab"]) {
            [self changeTab:vals[1]];
        } else if ([vals[0] isEqualToString:@"myorder"]) {
            [self myorder];
        } else if ([vals[0] isEqualToString:@"showbrand"]) {
            [self showBrand:[vals[1] intValue]];
        }else if ([vals[0] isEqualToString:@"ShowSkillList"]) {
            [self showSkillList];
        }else if ([vals[0] isEqualToString:@"ShowGroupList"]) {
            [self showGroupList];
        }else if ([vals[0] isEqualToString:@"ShowGroupDetail"]) {
//            [self showGroupDetail];
        }else if ([vals[0] isEqualToString:@"Getinlist"]) {
                        [self showList:[vals[1]intValue] name:vals[2]];
        }
        else if ([vals[0] isEqualToString:@"Addtocat"]) {
            [self addToCarids:[vals[1]integerValue] nums:[vals[2]integerValue]];
        }
        else {
            [webView stringByEvaluatingJavaScriptFromString:@"alert('未定义操作');"];
        }
        return NO;
    }
    return YES;
}
/**
 * 加入购物车
 */
-(void)addToCarids:(NSInteger)ids nums:(NSInteger)nums
{
    [ToastUtils showLoading:@"正在加入购物车..."];
  //  __weak typeof(self) weakSelf = self;
    [cartApi add:ids count:nums success:^(NSInteger cartItemCount) {
        [ToastUtils hideLoading];
       // [weakSelf changeTab:@"3"];
        [ToastUtils show:@"添加到购物车成功!"];
        [[NSNotificationCenter defaultCenter] postNotificationName:nAddCart object:nil];
    }    failure:^(NSError *error) {
        [ToastUtils hideLoading];
        [ToastUtils show:[error localizedDescription]];
    }];
}

/**
 * 秒杀商品
 */
- (void)showSkillList {
    LBMoreSecKillVC *vc = [[LBMoreSecKillVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
/**
 * 拼团列表
 */
- (void)showGroupList {
    PintuanListViewController *vc = [[PintuanListViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
/**
 * 拼团详情
 */
- (void)showGroupDetail {
//    FightgroupsViewController *pintuan = [[FightgroupsViewController alloc]initWithGoods:goods delegate:nil];;
//    [self.navigationController pushViewController:pintuan animated:YES];
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
- (void)showList:(int)catid name:(NSString*)names{
    [[self rdv_tabBarController].navigationController pushViewController:[ControllerHelper createGoodsListViewController:catid categoryName:names keyword:@"" brandId:0] animated:YES];
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



//定位

#pragma mark - 懒加载
-(CLLocationManager *)manager {
    
    if ([CLLocationManager locationServicesEnabled]) {
        _manager = [[CLLocationManager alloc]init];
        _manager.delegate = self;
        _manager.distanceFilter = 100.0f;//这个表示在地图上每隔1000m才更新一次定位信息
        _manager.desiredAccuracy = kCLLocationAccuracyBest;
        [_manager requestWhenInUseAuthorization];
    }
    
    return _manager;
}

-(void)openLocation
{
    self.latDoubleStr = [NSString stringWithFormat:@"%f",self.latDouble];
    self.longDoubleStr = [NSString stringWithFormat:@"%f",self.longDouble];
    
}

#pragma mark - CLLocationManager 代理
/**
 * 当定位到用户的位置时，就会调用（调用的频率比较频繁）
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *location =  [locations lastObject];
    self.longDouble = location.coordinate.longitude;
    self.latDouble = location.coordinate.latitude;
    NSLog(@"%f--%f",self.longDouble,self.latDouble);
    [self loadaddress];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    [self loadaddress];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请前往:设置 > 隐私 > 定位服务 开启定位功能" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    
}


// 当前定位授权状态发生改变时调用
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    switch (status) {
        case kCLAuthorizationStatusAuthorizedAlways:// 始终
            self.dingWeiStatus = YES;
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:// 使用应用期间
            self.dingWeiStatus = YES;
            break;
        case kCLAuthorizationStatusDenied://永不
            self.dingWeiStatus = NO;
            break;
        case kCLAuthorizationStatusNotDetermined:
            NSLog(@"not Determined");
            break;
        case kCLAuthorizationStatusRestricted:
            NSLog(@"Restricted");
            break;
        default:
            break;
    }
}


@end
