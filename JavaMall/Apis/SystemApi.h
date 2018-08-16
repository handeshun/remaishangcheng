//
// Created by Dawei on 7/17/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseApi.h"

@class Setting;


@interface SystemApi : BaseApi

/**
 * 获取热门搜索关键词
 */
- (void)hotKeyword:(void (^)(NSMutableArray *keywordArray))success failure:(void (^)(NSError *error))failure;

/**
 * 获取系统设置
 * @param setting
 * @param failure
 */
- (void)setting:(void (^)(Setting *setting))success failure:(void (^)(NSError *error))failure;

@end