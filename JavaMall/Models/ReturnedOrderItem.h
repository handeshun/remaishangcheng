//
// Created by Dawei on 7/11/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ReturnedOrderItem : NSObject

@property(assign, nonatomic) NSInteger id;

/**
 * 订单项ID
 */
@property(assign, nonatomic) NSInteger itemId;

/**
 * 商品id
 */
@property(assign, nonatomic) NSInteger goodsId;

/**
 * 商品名称
 */
@property(strong, nonatomic) NSString *goodsName;

/**
 * 货品id
 */
@property(assign, nonatomic) NSInteger productId;

/**
 * 退货数量
 */
@property(assign, nonatomic) NSInteger returnNumber;

/**
 * 购买数量
 */
@property(assign, nonatomic) NSInteger buyNumber;

/**
 * 购买价格
 */
@property(assign, nonatomic) double price;

/**
 * 商品图片
 */
@property(strong, nonatomic) NSString *thumbnail;

@end