//
// Created by Dawei on 5/25/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseApi.h"

@class Ad;


@interface AdApi : BaseApi

/**
 * 根据广告位获取一个首屏广告
 */
-(void)detail:(NSInteger) advid success:(void (^)(Ad *ad))success failure:(void (^) (NSError *error)) failure;

@end