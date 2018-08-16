//
// Created by Dawei on 1/30/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GoodsFilterValue : NSObject

/**
 * 筛选器值名称
 */
@property (strong, nonatomic) NSString *name;

/**
 * 筛选器值
 */
@property (strong, nonatomic) NSString *value;

/**
 * 是否选中了此筛选器值
 */
@property (assign, nonatomic) BOOL selected;


@end