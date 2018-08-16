//
// Created by Dawei on 3/24/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GoodsSpecValue : NSObject

/**
 * 值的ID
 */
@property (assign, nonatomic) NSInteger valueId;

/**
 * 规格值的名称
 */
@property (strong, nonatomic) NSString *name;

/**
 * 规格值的图片
 */
@property (strong, nonatomic) NSString *image;

@end