//
// Created by Dawei on 11/1/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class StorePrice;
@class ShipType;
@class Bonus;
@class Activity;


@interface Store : NSObject

/**
 * 店铺id
 */
@property (assign, nonatomic) NSInteger id;

/**
 * 店铺名称
 */
@property (strong, nonatomic) NSString *name;

/**
 * 店铺等级
 */
@property (assign, nonatomic) NSInteger store_level;

/**
 * 店铺logo
 */
@property (strong, nonatomic) NSString *store_logo;

/**
 * 店铺横幅
 */
@property (strong, nonatomic) NSString *store_banner;

/**
 * 店铺简介
 */
@property (strong, nonatomic) NSString *desc;

/**
 * 是否推荐
 */
@property (assign, nonatomic) NSInteger store_recommend;

/**
 * 店铺信用
 */
@property (assign, nonatomic) NSInteger store_credit;

/**
 * 店铺好评率
 */
@property (assign, nonatomic) double praise_rate;

/**
 * 描述相符度
 */
@property (assign, nonatomic) double store_desccredit;

/**
 * 服务态度分数
 */
@property (assign, nonatomic) double store_servicecredit;

/**
 * 发货速度分数
 */
@property (assign, nonatomic) double store_deliverycredit;

/**
 * 店铺收藏数量
 */
@property (assign, nonatomic) NSInteger store_collect;

/**
 * 店铺商品数量
 */
@property (assign, nonatomic) NSInteger goods_num;

/**
 * 是否选中结算
 */
@property (nonatomic, assign) BOOL checked;

/**
 * 是否选中
 */
@property (assign, nonatomic) BOOL selected;

/**
 * 购物车中商品价格
 */
@property (strong, nonatomic) StorePrice *storePrice;

/**
 * 购物车商品列表
 */
@property (strong, nonatomic) NSMutableArray *goodsList;

/**
 * 配送方式列表
 */
@property (strong, nonatomic) NSMutableArray *shipList;

/**
 * 优惠券列表
 */
@property (strong, nonatomic) NSMutableArray *bonusList;

/**
 * 使用的优惠券id
 */
@property (assign, nonatomic) Bonus *bonus;

/**
 * 使用的配送方式
 */
@property (strong, nonatomic) ShipType *shipType;

/**
 * 当前用户是否已关注此店铺
 */
@property (assign, nonatomic) BOOL favorited;

/**
 * 最新上架商品数量
 */
@property (assign, nonatomic) NSInteger new_num;

/**
 * 热卖商品数量
 */
@property (assign, nonatomic) NSInteger hot_num;

/**
 * 推荐商品数量
 */
@property (assign, nonatomic) NSInteger recommend_num;

/**
 * 当前活动id
 */
@property (assign, nonatomic) NSInteger activity_id;

/**
 * 当前活动名称
 */
@property (strong, nonatomic) NSString *activity_name;

/**
 * 活动
 */
@property (strong, nonatomic) Activity *activity;
/**
 * 店铺地址
 */
@property (strong, nonatomic) NSString *storeAddr;

@end
