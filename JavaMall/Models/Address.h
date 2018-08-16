//
// Created by Dawei on 5/31/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Address : NSObject

/**
 * Id
 */
@property (assign, nonatomic) NSInteger id;

/**
 * 收货人名称
 */
@property (strong, nonatomic) NSString *name;

/**
 * 省
 */
@property (strong, nonatomic) NSString *province;

/**
 * 省id
 */
@property (assign, nonatomic) NSInteger provinceId;

/**
 * 市
 */
@property (strong, nonatomic) NSString *city;

/**
 * 市id
 */
@property (assign, nonatomic) NSInteger cityId;

/**
 * 区/县
 */
@property (strong, nonatomic) NSString *region;

/**
 * 区/县id
 */
@property (assign, nonatomic) NSInteger regionId;

/**
 * 详细地址
 */
@property (strong, nonatomic) NSString *address;

/**
 * 邮编
 */
@property (strong, nonatomic) NSString *zip;

/**
 * 手机号码
 */
@property (strong, nonatomic) NSString *mobile;

/**
 * 固定电话
 */
@property (strong, nonatomic) NSString *tel;

/**
 * 是否为默认地址
 */
@property (assign, nonatomic) BOOL isDefault;

/**
 * 备注
 */
@property (strong, nonatomic) NSString *remark;

/**
 * 店铺地址
 */
@property (copy, nonatomic) NSString *attr;

/**
 * 店铺id
 */
@property (assign, nonatomic) NSInteger store_id;

/**
 * 店铺类型名称
 */
@property (copy, nonatomic) NSString *store_name;

/**
 * 店铺logo
 */
@property (copy, nonatomic) NSString *store_logo;

/**
 * 店铺经度
 */
@property (assign, nonatomic) CGFloat latitude;

/**
 * 店铺维度
 */
@property (assign, nonatomic) CGFloat longitude;

/**
 * 店铺距离
 */
@property (copy, nonatomic) NSString *distance;

@end
