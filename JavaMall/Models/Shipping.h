//
// Created by Dawei on 6/20/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Shipping : NSObject

@property (assign, nonatomic) NSInteger id;

@property (strong, nonatomic) NSString *name;

/**
 * 是否支持货到付款
 */
@property (assign, nonatomic) BOOL cod;

/**
 * 配送费用
 */
@property (assign, nonatomic) double price;


@end