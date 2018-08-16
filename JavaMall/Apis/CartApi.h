//
// Created by Dawei on 5/15/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseApi.h"

@class Cart;


@interface CartApi : BaseApi
/**
 * 添加秒杀商品到购物车
 * @param productId
 * @param count
 * @param success
 * @param failure
 */
- (void)addSeckill:(NSInteger)productId count:(NSInteger)count activity_id:(NSInteger)activity_id success:(void (^)(NSInteger cartItemCount))success failure:(void (^)(NSError *error))failure ;

/**
 * 添加商品到购物车
 * @param productId
 * @param count
 * @param success
 * @param failure
 */
- (void)add:(NSInteger)productId count:(NSInteger)count success:(void (^)(NSInteger cartItemCount))success failure:(void (^)(NSError *error))failure;

/**
 * 获取购物车商品数量
 * @param success
 * @param failure
 */
- (void)count:(void (^)(NSInteger cartItemCount))success failure:(void (^)(NSError *error))failure;

/**
 * 获取购物车商品列表
 * @param success
 * @param failure
 */
- (void)list:(void (^)(Cart *cart))success failure:(void (^)(NSError *error))failure;

/**
 * 获取购物车中选中结算的商品列表
 * @param success
 * @param failure
 */
- (void)listSelected:(void (^)(Cart *cart))success failure:(void (^)(NSError *error))failure;

/**
 * 从购物车中删除商品
 * @param cartIds
 * @param success
 * @param failure
 */
- (void)delete:(NSMutableArray *)cartIds success:(void (^)(NSInteger cartItemCount))success failure:(void (^)(NSError *error))failure;

/**
 * 更新购物车商品数量
 * @param cartId
 * @param number
 * @param productId
 * @param success
 * @param failure
 */
- (void)updateNumber:(NSInteger)cartId number:(NSInteger)number productId:(NSInteger)productId success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 * 选择或取消选择要结算的商品
 * @param productId
 * @param checked
 * @param success
 * @param failure
 */
- (void)check:(NSInteger)productId checked:(BOOL)checked success:(void (^)(BOOL result))success failure:(void (^)(NSError *error))failure;

/**
 * 全选或取消全选要结算的商品
 * @param checked
 * @param success
 * @param failure
 */
- (void)checkAll:(BOOL)checked success:(void (^)(BOOL result))success failure:(void (^)(NSError *error))failure;

/**
 * 选择或取消选择要结算的店铺
 * @param storeId
 * @param checked
 * @param success
 * @param failure
 */
- (void)checkStore:(NSInteger)storeId checked:(BOOL)checked success:(void (^)(BOOL result))success failure:(void (^)(NSError *error))failure;

@end
