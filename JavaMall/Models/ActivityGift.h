//
// Created by Dawei on 10/29/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ActivityGift : NSObject

/**
 * 赠品id
 */
@property (assign, nonatomic) NSInteger id;

/**
 * 赠品名称
 */
@property (strong, nonatomic) NSString *name;

/**
 * 赠品价格
 */
@property (assign, nonatomic) double price;

/**
 * 赠品图片
 */
@property (strong, nonatomic) NSString *img;

/**
 * 可用库存
 */
@property (assign, nonatomic) NSInteger enableStore;

@end