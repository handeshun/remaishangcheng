//
// Created by Dawei on 1/4/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "RootTabViewController.h"
#import "HomeViewController.h"
#import "RDVTabBarItem.h"
#import "CategoryViewController.h"
#import "CartViewController.h"
#import "CartApi.h"
#import "MemberApi.h"
#import "ToastUtils.h"
#import "Constants.h"
#import "PersonViewController.h"
#import "ControllerHelper.h"
#import "HttpUtils.h"


@implementation RootTabViewController {
    RDVTabBarItem *cartTabItem;

    CartApi *cartApi;
    MemberApi *memberApi;
}

- (void)viewDidLoad {
    [super viewDidLoad];

//    NSString *url = @"https://m.win.javamall.com.cn/api/mobile/cart/list.do";
//    [HttpUtils get:url success:^(NSString *responseString) {
//        NSLog(@"成功了：%@", responseString);
//    }      failure:^(NSError *error) {
//        NSLog(@"失败了：%@", error);
//    }];


    self.navigationController.navigationBarHidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cartChangedCompletion:) name:nAddCart object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cartChangedCompletion:) name:nDeleteCart object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cartChangedCompletion:) name:nLogin object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cartChangedCompletion:) name:nLogout object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cartChangedCompletion:) name:nCheckout object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toRootNotification:) name:nToRoot object:nil];
    cartApi = [CartApi new];
    memberApi = [MemberApi new];

    [self setupViewControllers];

    [self checkLogin];
    [self updateCartBadge];
}


/**
 * 初始化ViewControllers
 */
- (void)setupViewControllers {
    HomeViewController *homeViewController = [[HomeViewController alloc] init];
    CategoryViewController *categoryViewController = [[CategoryViewController alloc] init];
    CartViewController *cartViewController = [[CartViewController alloc] init];
    PersonViewController *personViewController = [[PersonViewController alloc] init];

    [self setViewControllers:@[homeViewController, categoryViewController, cartViewController, personViewController]];

    //设置tabitem的图片
    UIImage *backgroundImage = [UIImage imageNamed:@"tabbar_background"];
    NSArray *tabBarItemImages = @[@"home", @"category", @"cart", @"me"];
    NSArray *tabBarTitles = @[@"首页", @"分类", @"购物车", @"我的"];

    NSDictionary *selectedTitleAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#ff5252"]};
    NSDictionary *unselectedTitleAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};

    NSInteger index = 0;
    for (RDVTabBarItem *item in [[self tabBar] items]){
        [item setBackgroundSelectedImage:backgroundImage withUnselectedImage:backgroundImage];
        UIImage *selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"tabbar_%@_selected",
                                                                                [tabBarItemImages objectAtIndex:index]]];
        UIImage *normalImage = [UIImage imageNamed:[NSString stringWithFormat:@"tabbar_%@_normal",
                                                                                  [tabBarItemImages objectAtIndex:index]]];
        [item setFinishedSelectedImage:selectedImage withFinishedUnselectedImage:normalImage];
        [item setTitle:[tabBarTitles objectAtIndex:index]];
        [item setSelectedTitleAttributes:selectedTitleAttributes];
        [item setUnselectedTitleAttributes:unselectedTitleAttributes];

        if(index == 2){
            cartTabItem = item;
        }

        index++;
    }
}

/*
 * 检查登录状态
 */
- (void)checkLogin {
    [memberApi isLogin:^(BOOL logined) {
        if(logined){
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSData *memberData = [defaults objectForKey:kCurrentMemberKey];
            if(!memberData){
                [ControllerHelper clearLoginInfo];
                return;
            }
            Member *member = [NSKeyedUnarchiver unarchiveObjectWithData:memberData];
            if(!member){
                [ControllerHelper clearLoginInfo];
                return;
            }
            [Constants setMember:member];
            return;
        }
        [ControllerHelper clearLoginInfo];
    } failure:^(NSError *error) {
        [ToastUtils show:error.localizedDescription];
    }];
}

/*
 * 更新购物车角标
 */
- (void)updateCartBadge {
    //载入购物车数里
    [cartApi count:^(NSInteger cartItemCount) {
        [self updateCartBadge:cartItemCount];
    } failure:^(NSError *error) {

    }];
}

/*
 * 更新购物车角标
 */
- (void)updateCartBadge:(int)_count {
    if(_count > 0) {
        [cartTabItem setBadgeValue:[NSString stringWithFormat:@"%d", _count]];
        return;
    }
    [cartTabItem setBadgeValue:nil];
}

/**
 * 响应购物车商品变化的通知
 */
- (void)cartChangedCompletion:(NSNotification *)notification {
    [self updateCartBadge];
}

/**
 * 响应跳转到首页的通知
 */
- (void)toRootNotification:(NSNotification *)notification {
    int index = [[notification.userInfo objectForKey:@"index"] intValue];
    if(index >= 0 && index < 4) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        self.selectedIndex = index;
    }
}

@end