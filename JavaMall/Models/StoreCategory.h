//
// Created by Dawei on 11/6/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface StoreCategory : NSObject

/**
 * 分类id
 */
@property (assign, nonatomic) NSInteger cat_id;

/**
 * 上级分类id
 */
@property (assign, nonatomic) NSInteger parent_id;

/**
 * 分类名称
 */
@property (strong, nonatomic) NSString *name;

@end