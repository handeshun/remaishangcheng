//
// Created by Dawei on 5/31/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseApi.h"

@class Address;


@interface AddressApi : BaseApi

/**
 * 获取默认收货地址
 */
- (void)getDefault:(void (^)(Address *address))success failure:(void (^)(NSError *error))failure;

/**
 * 获取区域列表
 */
- (void)getRegions:(NSInteger)parentid success:(void (^)(NSMutableArray *regions))success failure:(void (^)(NSError *error))failure;

/**
 * 添加收货地址
 */
- (void)add:(Address *)address success:(void (^)(Address *address))success failure:(void (^)(NSError *error))failure;

/**
 * 编辑收货地址
 */
- (void)edit:(Address *)address success:(void (^)(Address *address))success failure:(void (^)(NSError *error))failure;

/**
 * 获取收货地址列表
 */
- (void)list:(void (^)(NSMutableArray *addressArray))success failure:(void (^)(NSError *error))failure;

/**
 * 删除收货地址
 */
- (void)delete:(NSInteger)addressId success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 * 设置默认地址
 */
- (void)setDefault:(NSInteger)addressId success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 * 获取附近店铺地址
 */
- (void)getAddress:(CGFloat)lat lon:(CGFloat)lon success:(void (^)(NSMutableArray *address))success failure:(void (^)(NSError *error))failure;

@end
