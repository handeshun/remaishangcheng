//
// Created by Dawei on 6/26/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface OrderPrice : NSObject

/**
 * 商品金额
 */
@property (assign, nonatomic) double goodsPrice;

/**
 * 运费
 */
@property (assign, nonatomic) double shippingPrice;

/**
 * 优惠金额
 */
@property (assign, nonatomic) double discountPrice;

/**
 * 促销活动优惠金额
 */
@property (assign, nonatomic) double actDiscount;

/**
 * 需要支付的费用=商品金额+运费-优惠金额
 */
@property (assign, nonatomic) double paymentMoney;

@end