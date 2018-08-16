//
// Created by Dawei on 1/31/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GoodsGallery : NSObject

/**
 * 所属商品ID
 */
@property (assign, nonatomic) NSInteger goodsId;

/**
 * 图片ID
 */
@property (assign, nonatomic) NSInteger imageId;

/**
 * 缩略图
 */
@property (strong, nonatomic) NSString *thumbnail;

/**
 * 小图
 */
@property (strong, nonatomic) NSString *small;

/**
 * 大图
 */
@property (strong, nonatomic) NSString *big;

/**
 * 原图
 */
@property (strong, nonatomic) NSString *original;

@end