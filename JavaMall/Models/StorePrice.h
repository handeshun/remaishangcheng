//
// Created by Dawei on 11/1/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface StorePrice : NSObject

/**
 * 商品价格
 */
@property (assign, nonatomic) double goodsPrice;

/**
 * 订单总价
 */
@property (assign, nonatomic) double orderPrice;

/**
 * 运费
 */
@property (assign, nonatomic) double shippingPrice;

/**
 * 需要付款
 */
@property (assign, nonatomic) double needPayMoney;

/**
 * 折扣费用
 */
@property (assign, nonatomic) double discountPrice;

/**
 * 商品重量
 */
@property (assign, nonatomic) double weight;

/**
 * 积分
 */
@property (assign, nonatomic) NSInteger point;

/**
 * 活动折扣
 */
@property (assign, nonatomic) double actDiscount;

/**
 * 赠品id
 */
@property (assign, nonatomic) NSInteger gift_id;

/**
 * 优惠券id
 */
@property (assign, nonatomic) NSInteger bonus_id;

/**
 * 是否免运费
 */
@property (assign, nonatomic) NSInteger is_free_ship;

/**
 * 是否促销免运费
 */
@property (assign, nonatomic) NSInteger act_free_ship;

@property (assign, nonatomic) NSInteger exchange_point;

@property (assign, nonatomic) NSInteger activity_point;

@end