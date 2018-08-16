//
// Created by Dawei on 5/25/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Cart : NSObject

/**
 * 购物车商品数量
 */
@property (assign, nonatomic) NSInteger count;

/**
 * 商品总价
 */
@property (assign, nonatomic) double total;

/**
 * 购物车店铺列表(店铺里包含商品列表)
 */
@property (strong, nonatomic) NSMutableArray *storeList;

@end