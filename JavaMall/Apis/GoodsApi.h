//
// Created by Dawei on 1/28/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseApi.h"

@class Goods;
@class Activity;


@interface GoodsApi : BaseApi

/**
 * 载入商品列表
 */
- (void) list:(NSMutableDictionary *)parameters success:(void (^) (NSMutableArray *goodsArray))success failure:(void (^) (NSError *error)) failure;

/**
 * 载入商品筛选列表
 */
- (void) filters:(NSInteger)categoryId keyword:(NSString *)keyword success:(void (^) (NSMutableArray *filterArray))success failure:(void (^) (NSError *error)) failure;

/**
 * 载入商品相册
 */
- (void) gallery:(NSInteger)goodsId success:(void (^) (NSMutableArray *galleryArray))success failure:(void (^) (NSError *error)) failure;

/**
 * 载入商品详情
 */
- (void) detail:(NSInteger)goodsId success:(void (^) (Goods *goods))success failure:(void (^) (NSError *error)) failure;

/**
 * 获取拼团详情
 */
- (void) pintuan:(NSInteger)goodsId productid:(NSInteger)productid success:(void (^) (Goods *goods))success failure:(void (^) (NSError *error)) failure;

/**
 * 获取一个商品的规格
 */
- (void) spec:(NSInteger)goodsId success:(void (^) (NSMutableArray *specs, NSMutableDictionary *productDic))success failure:(void (^) (NSError *error)) failure;

/**
 * 将选择的筛选器格式化成参数
 */
- (NSMutableDictionary *) formatFilter:(NSMutableArray *)filters;

/**
 * 载入热卖商品列表
 */
- (void) hotlist:(NSInteger)page success:(void (^) (NSMutableArray *goodsArray))success failure:(void (^) (NSError *error)) failure;

/**
 * 载入促销活动详情
 */
- (void) activity:(NSInteger)activityId success:(void (^) (Activity *activity))success failure:(void (^) (NSError *error)) failure;

/**
 * 加入购物车
 */
- (void) addcar:(NSInteger)pintuan product:(NSInteger)productid num:(NSInteger)nums success:(void (^) (NSDictionary *resultDict))success failure:(void (^) (NSError *error)) failure;

/**
 * 通过SN获取goodid
 */
- (void) bySNgetGoodid:(NSInteger)sn success:(void (^)(Goods *))success failure:(void (^)(NSError *))failure;
@end
