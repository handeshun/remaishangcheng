//
// Created by Dawei on 10/28/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ActivityGift;


@interface Activity : NSObject

/**
 * 活动id
 */
@property (assign, nonatomic) NSInteger id;

/**
 * 促销活动名称
 */
@property (strong, nonatomic) NSString *name;

/**
 * 开始时间
 */
@property (strong, nonatomic) NSDate *startTime;

/**
 * 结束时间
 */
@property (strong, nonatomic) NSDate *endTime;

/**
 * 活动描述
 */
@property (strong, nonatomic) NSString *desc;

/**
 * 活动门槛(满多少钱)
 */
@property (assign, nonatomic) double full_money;

/**
 * 满减-减多少钱
 */
@property(assign, nonatomic) double minus_value;

/**
 * 满送-送多少积分
 */
@property(assign, nonatomic) NSInteger point_value;

/**
 * 是否包含满减现金，默认为不包含
 */
@property(assign, nonatomic) BOOL full_minus;

/**
 * 是否包邮,默认为不包邮
 */
@property(assign, nonatomic) BOOL free_ship;

/**
 * 是否包含满送积分，默认为不包含
 */
@property(assign, nonatomic) BOOL send_point;

/**
 * 是否包含满送赠品，默认为不包含
 */
@property(assign, nonatomic) BOOL send_gift;

/**
 * 是否包含满送优惠券，默认为不包含
 */
@property(assign, nonatomic) BOOL send_bonus;

/**
 * 赠品ID
 */
@property(assign, nonatomic) NSInteger gift_id;

/**
 * 优惠券ID
 */
@property(assign, nonatomic) NSInteger bonus_id;

/**
 * 赠品
 */
@property (strong, nonatomic) ActivityGift *gift;

@end
