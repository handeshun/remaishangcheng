//
// Created by Dawei on 1/30/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GoodsFilterValue;


@interface GoodsFilter : NSObject

/**
 * 筛选器名称
 */
@property (strong, nonatomic) NSString *name;

/**
 * 筛选器类型:brand, price, prop
 */
@property (strong, nonatomic) NSString *type;

/**
 * 选中的筛选器值
 */
@property (strong, nonatomic) GoodsFilterValue *selectedValue;

/**
 * 筛选器值列表
 */
@property (strong, nonatomic) NSMutableArray *values;

@end