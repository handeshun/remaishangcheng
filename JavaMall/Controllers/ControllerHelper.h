//
// Created by Dawei on 5/11/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class REFrostedViewController;
@class Goods;
@class ChatViewController;


@interface ControllerHelper : NSObject

/**
 * 创建商品列表视图控制器
 * @param categoryId        分类id
 * @param categoryName      分类名称
 * @param keyword           搜索关键词
 * @param brandId           品牌id
 * @return
 */
+ (UINavigationController *)createGoodsListViewController:(NSInteger)categoryId
                                             categoryName:(NSString *)categoryName
                                                  keyword:(NSString *)keyword
                                                  brandId:(NSInteger)brandId;

/**
 * 创建商品详情视图控制器
 */
+ (REFrostedViewController *)createGoodsViewController:(Goods *)goods;

/**
 * 创建商品详情视图控制器
 * @param goodsId
 * @return
 */
+ (REFrostedViewController *)createGoodsViewControllerWithId:(NSInteger) goodsId;

/**
 * 创建登录视图控制器
 */
+ (UINavigationController *)createLoginViewController;

/**
 * 创建客服聊天窗口
 * @return
 */
+(ChatViewController *)createChatViewController;

/**
 * 是否已登录
 */
+ (BOOL)isLogined;

/**
 * 清除登录信息
 */
+ (void)clearLoginInfo;

@end