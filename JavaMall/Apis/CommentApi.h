//
// Created by Dawei on 3/27/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseApi.h"

@class GoodsComment;


@interface CommentApi : BaseApi

/**
 * 取商品评论列表
 */
- (void)list:(NSInteger)goodsId type:(NSInteger)type page:(NSInteger)page success:(void (^)(NSMutableArray *commentArray))success failure:(void (^)(NSError *error))failure;

/**
 * 取热门评论
 */
- (void)hot:(NSInteger)goodsId success:(void (^)(NSMutableArray *commentArray))success failure:(void (^)(NSError *error))failure;

/**
 * 取评论数量
 */
- (void)count:(NSInteger)goodsId success:(void (^)(NSMutableArray *commentCountArray))success failure:(void (^)(NSError *error))failure;

/**
 * 待评论商品
 */
- (void)waitList:(NSInteger)page orderId:(NSInteger)orderId success:(void (^)(NSMutableArray *goodsArray))success failure:(void (^)(NSError *error))failure;

/**
 * 发表评论
 */
- (void)create:(GoodsComment *)comment success:(void (^)())success failure:(void (^)(NSError *error))failure;

@end