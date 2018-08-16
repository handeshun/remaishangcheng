//
// Created by Dawei on 5/15/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseApi.h"


@interface FavoriteApi : BaseApi

/**
 * 收藏某个商品
 */
-(void)favorite:(NSInteger)goodsId success:(void (^)())success failure:(void (^) (NSError *error)) failure;


/**
 * 批量收藏商品
 */
-(void)batchFavorite:(NSMutableArray *)goodsIdArray success:(void (^)())success failure:(void (^) (NSError *error)) failure;

/**
 * 取消收藏某个商品
 */
-(void)unfavorite:(NSInteger)goodsId success:(void (^)())success failure:(void (^) (NSError *error)) failure;

/**
 * 获取收藏列表
 */
-(void)list:(NSInteger)page success:(void (^)(NSMutableArray *favoriteArray))success failure:(void (^)(NSError *error))failure;

/**
 * 获取收藏的店铺列表
 */
-(void)storeList:(NSInteger)page success:(void (^)(NSMutableArray *storeArray))success failure:(void (^)(NSError *error))failure;


@end