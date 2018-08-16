//
// Created by Dawei on 5/26/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Goods.h"


@interface CartGoods : Goods

/**
 * 购物车ID
 */
@property(nonatomic, assign) NSInteger cartId;

/**
 * 小计
 */
@property(nonatomic, assign) double subTotal;

/**
 * 是否选中结算
 */
@property (nonatomic, assign) BOOL checked;

/**
 * 是否选中
 */
@property(nonatomic, assign) BOOL selected;

/**
 * 活动id
 */
@property (assign, nonatomic) NSInteger activity_id;

@end