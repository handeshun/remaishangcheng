//
// Created by Dawei on 11/2/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseApi.h"

@class Store;


@interface StoreApi : BaseApi

/**
 * 载入店铺详情
 * @param storeId
 * @param success
 * @param failure
 */
- (void)detail:(NSInteger)storeId success:(void (^)(Store *store))success failure:(void (^)(NSError *error))failure;

/**
 * 获取店铺的优惠券列表
 * @param storeId
 * @param success
 * @param failure
 */
- (void)bonusList:(NSInteger)storeId success:(void (^)(NSMutableArray *bonuses))success failure:(void (^)(NSError *error))failure;

/**
 * 领取优惠券
 * @param storeId
 * @param type_id
 * @param success
 * @param failure
 */
- (void)getBonus:(NSInteger)storeId type_id:(NSInteger)type_id success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 * 获取店铺首页的商品列表
 * @param storeId
 * @param success
 * @param failure
 */
- (void)indexGoods:(NSInteger)storeId success:(void (^)(NSMutableDictionary *goodsDic))success failure:(void (^)(NSError *error))failure;

/**
 * 按标签获取店铺的商品
 * @param storeId
 * @param tag
 * @param page
 * @param success
 * @param failure
 */
- (void)tagGoods:(NSInteger)storeId tag:(NSString *)tag page:(NSInteger)page success:(void (^)(NSMutableArray *goodsList))success failure:(void (^)(NSError *error))failure;

/**
 * 获取店铺所有商品
 * @param storeId
 * @param parameters
 * @param success
 * @param failure
 */
- (void)goodsList:(NSInteger)storeId parameters:(NSMutableDictionary *)parameters success:(void (^)(NSMutableArray *goodsList))success failure:(void (^)(NSError *error))failure;

/**
 * 关注店铺
 * @param storeId
 * @param success
 * @param failure
 */
- (void)collect:(NSInteger)storeId success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 * 取消关注店铺
 * @param storeId
 * @param success
 * @param failure
 */
- (void)uncollect:(NSInteger)storeId success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 * 获取店铺商品分类
 * @param storeId
 * @param success
 * @param failure
 */
- (void)category:(NSInteger)storeId success:(void (^)(NSMutableArray *catgories))success failure:(void (^)(NSError *error))failure;

/**
 * 搜索店铺
 * @param keyword
 * @param page
 * @param success
 * @param failure
 */
- (void)search:(NSString *)keyword page:(NSInteger)page success:(void (^)(NSMutableArray *storeList))success failure:(void (^)(NSError *error))failure;


@end