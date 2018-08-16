//
// Created by Dawei on 5/11/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "ControllerHelper.h"
#import "BaseNavigationController.h"
#import "REFrostedViewController.h"
#import "GoodsListViewController.h"
#import "GoodsFilterViewController.h"
#import "Goods.h"
#import "GoodsSpecViewController.h"
#import "GoodsViewController.h"
#import "LoginViewController.h"
#import "Constants.h"
#import "ChatViewController.h"
#import "Setting.h"


@implementation ControllerHelper {

}

/**
 * 创建商品列表视图控制器
 * @param categoryId        分类id
 * @param categoryName      分类名称
 * @param keyword           搜索关键词
 * @param brandId           品牌id
 * @return
 */
+ (REFrostedViewController *)createGoodsListViewController:(NSInteger)categoryId categoryName:(NSString *)categoryName keyword:(NSString *)keyword brandId:(NSInteger)brandId {
    GoodsListViewController *goodsListViewController = [[GoodsListViewController alloc] init];
    goodsListViewController.categoryId = categoryId;
    goodsListViewController.categoryName = categoryName;
    goodsListViewController.keyword = keyword;
    goodsListViewController.brandId = brandId;

    GoodsFilterViewController *goodsFilterViewController = [GoodsFilterViewController new];
    goodsFilterViewController.categoryId = categoryId;
    goodsFilterViewController.keyword = keyword;
    goodsFilterViewController.delegate = goodsListViewController;
    UINavigationController *goodsFilterNav = [[BaseNavigationController alloc] initWithRootViewController:goodsFilterViewController];

    REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:goodsListViewController menuViewController:goodsFilterNav];
    frostedViewController.direction = REFrostedViewControllerDirectionRight;

    return frostedViewController;
}

/**
 * 创建商品详情视图控制器
 */
+ (REFrostedViewController *)createGoodsViewController:(Goods *)goods {
    GoodsViewController *goodsViewController = [GoodsViewController new];
    goodsViewController.goods = goods;

    GoodsSpecViewController *goodsSpecViewController = [GoodsSpecViewController new];
    goodsSpecViewController.delegate = goodsViewController;


    REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:goodsViewController menuViewController:goodsSpecViewController];
    frostedViewController.direction = REFrostedViewControllerDirectionRight;
    return frostedViewController;
}

/**
 * 创建商品详情视图控制器
 */
+ (REFrostedViewController *)createGoodsViewControllerWithId:(NSInteger) goodsId {
    Goods *goods = [Goods new];
    goods.id = goodsId;

    GoodsViewController *goodsViewController = [GoodsViewController new];
    goodsViewController.goods = goods;

    GoodsSpecViewController *goodsSpecViewController = [GoodsSpecViewController new];
    goodsSpecViewController.delegate = goodsViewController;


    REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:goodsViewController menuViewController:goodsSpecViewController];
    frostedViewController.direction = REFrostedViewControllerDirectionRight;
    return frostedViewController;
}

/**
 * 创建客服聊天窗口
 * @return
 */
+ (ChatViewController *)createChatViewController{
    if([Constants setting] == nil || ![[Constants setting].currentService isKindOfClass:[NSString class]] || [Constants setting].currentService.length <= 0)
        return nil;

    ChatViewController *chatViewController = [[ChatViewController alloc] initWithConversationChatter:[Constants setting].currentService conversationType:EMConversationTypeChat];
    chatViewController.title = @"在线客服";
    return chatViewController;
}

/**
 * 创建登录视图控制器
 */
+ (UINavigationController *)createLoginViewController {
    return [[BaseNavigationController alloc] initWithRootViewController:[LoginViewController new]];
}

/**
 * 是否已登录
 */
+ (BOOL)isLogined {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *memberData = [defaults objectForKey:kCurrentMemberKey];
    if(!memberData){
        return NO;
    }
    return YES;
}

+ (void)clearLoginInfo {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:kCurrentMemberKey];
    [defaults synchronize];
    [Constants setMember:nil];
}


@end