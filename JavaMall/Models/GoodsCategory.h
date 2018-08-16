//
// Created by Dawei on 1/27/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GoodsCategory : NSObject

/**
 * 分类ID
 */
@property (assign, nonatomic) NSInteger id;

/**
 * 分类名称
 */
@property (strong, nonatomic) NSString *name;

/**
 * 第几级
 */
@property (assign, nonatomic) NSInteger level;

/**
 * 分类图片
 */
@property (strong, nonatomic) NSString *image;

/**
 * 子分类
 */
@property (strong, nonatomic) NSMutableArray *children;

@end