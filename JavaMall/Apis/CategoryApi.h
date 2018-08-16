//
// Created by Dawei on 1/22/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseApi.h"


@interface CategoryApi : BaseApi

/**
 * 载入所有分类
 */
- (void) loadAll:(void (^) (NSMutableArray *categories))success failure:(void (^) (NSError *error)) failure;

@end