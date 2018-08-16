//
//  LBSeckill.h
//  JavaMall
//
//  Created by 李斌 on 2017/11/26.
//  Copyright © 2017年 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBSeckill : NSObject
/**
 * 商品ID
 */
@property(assign, nonatomic) NSInteger goods_id;

/**
 * 商品名
 */
@property(strong, nonatomic) NSString *name;

/**
 * 开始时间
 */
@property(assign, nonatomic) long long start_time;

/**
 * 结束时间
 */
@property(assign, nonatomic) long long end_time;

/**
 * 图片路径
 */
@property(strong, nonatomic) NSString *thumbnail;

/**
 * 秒杀价格
 */
@property(assign, nonatomic) double seckill_price;

/**
 * 原价
 */
@property(assign, nonatomic) double price;

/**
 * 秒杀活动ID
 */
@property(assign, nonatomic) NSInteger avtivity_id;

/**
 * 秒杀可用库存
 */
@property(assign, nonatomic) NSInteger enable_store;
@end
