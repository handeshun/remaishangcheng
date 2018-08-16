//
// Created by Dawei on 1/28/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Activity;


@interface Goods : NSObject

/**
 * 商品ID
 */
@property (assign, nonatomic) NSInteger id;

/**
 * 产品ID
 */
@property (assign, nonatomic) NSInteger productId;

/**
 * 名称
 */
@property (strong, nonatomic) NSString *name;

/**
 * 价格
 */
@property (assign, nonatomic) double price;

/**
 * 市场价
 */
@property (assign, nonatomic) double marketPrice;

/**
 * 评论数量
 */
@property (assign, nonatomic) NSInteger commentCount;

/**
 * 购买数量
 */
@property (assign, nonatomic) NSInteger buyCount;

/**
 * 缩略图
 */
@property (strong, nonatomic) NSString *thumbnail;

/**
 * 可用库存
 */
@property (assign, nonatomic) NSInteger store;

/**
 * 商品编码
 */
@property (strong, nonatomic) NSString *sn;

/**
 * 重量
 */
@property (assign, nonatomic) double weight;

/**
 * 好评率
 */
@property (strong, nonatomic) NSString *goodCommentPercent;

/**
 * 当前用户是否已收藏此商品
 */
@property (assign, nonatomic) BOOL favorited;

/**
 * 规格名称
 */
@property (strong, nonatomic) NSString *specs;

/**
 * 规格值作为key,如1-1-2
 */
@property (strong, nonatomic) NSString *specKey;

/**
 * 此商品的规格字典
 */
@property (strong, nonatomic) NSMutableDictionary *specDic;

/**
 * 商品参加的促销活动
 */
@property (strong, nonatomic) Activity *activity;

/**
 * 店铺id
 */
@property (assign, nonatomic) NSInteger store_id;

/**
 * 拼团相关
 */
#pragma mark 拼团相关
/**
 * 轮播图
 */
@property (strong, nonatomic) NSArray * goodsGalleryList;

/**
 * 是否拼团
 */
@property (assign, nonatomic) int is_pintuan;

/**
 * 拼团价
 */
@property (assign, nonatomic) float pintuan_price;

/**
 * 开始时间
 */
@property (assign, nonatomic) long pintuan_start_time;

/**
 * 结束时间
 */
@property (assign, nonatomic) long pintuan_end_time;

/**
 * 当前拼团人数
 */
@property (assign, nonatomic) int pintuan_peoplecount;

/**
 * 押金
 */
@property (assign, nonatomic) float deposit;

/**
 * 分享链接
 */
@property (copy, nonatomic) NSString * shareurl;

/**
 * 拼团规则
 */
@property (strong, nonatomic) NSArray *modelList;

/**
 * 要到达的人数
 */
@property (assign, nonatomic) int peoplecount;

/**
 * 拼团价
 */



/**
 * 是否是秒杀是商品
 */
@property(assign, nonatomic) NSInteger is_seckill;
/**
 * 商品ID
 */
@property(assign, nonatomic) NSInteger goods_id;

/**
 * 开始时间
 */
@property(assign, nonatomic) long long start_time;

/**
 * 结束时间
 */
@property(assign, nonatomic) long long end_time;

/**
 * 秒杀价格
 */
@property(assign, nonatomic) double seckill_price;

/**
 * 秒杀活动ID
 */
@property(assign, nonatomic) NSInteger activity_id;

/**
 * 秒杀可用库存
 */
@property(assign, nonatomic) NSInteger enable_store;


@end
