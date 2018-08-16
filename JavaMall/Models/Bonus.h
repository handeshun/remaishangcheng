//
// Created by Dawei on 6/22/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Bonus : NSObject

@property (assign, nonatomic) NSInteger id;

/**
 * 优惠券名称
 */
@property (strong, nonatomic) NSString *name;

/**
 * 优惠券金额
 */
@property (assign, nonatomic) double money;

/**
 * 满多少可用
 */
@property (assign, nonatomic) double minAmount;

/**
 * 优惠券开始时间
 */
@property (strong, nonatomic) NSDate *startDate;

/**
 * 优惠券结束时间
 */
@property (strong, nonatomic) NSDate *endDate;

/**
 * 优惠券发放类型:1:会员发放; 2:商品发放; 3:订单发放; 4:线下发放红包
 */
@property (assign, nonatomic) NSInteger type;

/**
 * 优惠券序列号
 */
@property (strong, nonatomic) NSString *sn;

/**
 * 店铺id
 */
@property (assign, nonatomic) NSInteger store_id;

/**
 * 店铺名称
 */
@property (strong, nonatomic) NSString *store_name;

/**
 * 是否选中
 */
@property (assign, nonatomic) BOOL selected;

/**
 * 是否已使用
 */
@property (assign, nonatomic) BOOL used;

@end