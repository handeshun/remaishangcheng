//
// Created by Dawei on 11/1/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ShipType : NSObject

/**
 * 配送类型名称
 */
@property (strong, nonatomic) NSString *name;

/**
 * 配送费用
 */
@property (assign, nonatomic) double shipPrice;

/**
 * 类型id
 */
@property (assign, nonatomic) NSInteger type_id;

@end