//
// Created by Dawei on 3/24/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GoodsSpec : NSObject

/**
 * 规格id
 */
@property (assign, nonatomic) NSInteger id;

/**
 * 规格名称
 */
@property (strong, nonatomic) NSString *name;

/**
 * 规格值
 */
@property (strong, nonatomic) NSMutableArray *specValues;

@end