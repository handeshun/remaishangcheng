//
// Created by Dawei on 5/25/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Member : NSObject<NSCoding>

@property (assign, nonatomic) NSInteger id;

/**
 * 昵称
 */
@property (strong, nonatomic) NSString *nickName;

/**
 * 用户名
 */
@property (strong, nonatomic) NSString *userName;

/**
 * 真实姓名
 */
@property (strong, nonatomic) NSString *name;

/**
 * 头像URL地址
 */
@property (strong, nonatomic) NSString *face;

/**
 * 头像图片文件
 */
@property (strong, nonatomic) UIImage *faceImage;

/**
 * 等级id
 */
@property (assign, nonatomic) NSInteger levelId;

/**
 * 等级名称
 */
@property (strong, nonatomic) NSString *levelName;

/**
 * 性别:1男2女0保密
 */
@property (assign, nonatomic) NSInteger sex;

/**
 * 生日
 */
@property (strong, nonatomic) NSDate *birthday;

/**
 * 省份ID
 */
@property (assign, nonatomic) NSInteger provinceId;

/**
 * 省
 */
@property (strong, nonatomic) NSString *province;

/**
 * 市id
 */
@property (assign, nonatomic) NSInteger cityId;

/**
 * 市
 */
@property (strong, nonatomic) NSString *city;

/**
 * 县id
 */
@property (assign, nonatomic) NSInteger regionId;

/**
 * 县
 */
@property (strong, nonatomic) NSString *region;

/**
 * 详细地址
 */
@property (strong, nonatomic) NSString *address;

/**
 * 邮编
 */
@property (strong, nonatomic) NSString *zip;

/**
 * 手机机号码
 */
@property (strong, nonatomic) NSString *mobile;

/**
 * 固定电话
 */
@property (strong, nonatomic) NSString *tel;

/**
 * 收藏的商品数
 */
@property (assign, nonatomic) NSInteger favoriteCount;

/**
 * 关注的店铺数
 */
@property (assign, nonatomic) NSInteger favoriteStoreCount;

/**
 * 等级积分
 */
@property (assign, nonatomic) NSInteger point;

/**
 * 消费积分
 */
@property (assign, nonatomic) NSInteger mp;

/**
 * 待付款订单数
 */
@property (assign, nonatomic) NSInteger paymentOrderCount;

/**
 * 待收货订单数
 */
@property (assign, nonatomic) NSInteger shippingOrderCount;

/**
 * 待评论订单数
 */
@property (assign, nonatomic) NSInteger commentOrderCount;

/**
 * 退换货单数量
 */
@property (assign, nonatomic) NSInteger returnedOrderCount;

/**
 * 在环信IM里的用户名
 */
@property (strong, nonatomic) NSString *imUser;

/**
 * 在环信IM里的密码
 */
@property (strong, nonatomic) NSString *imPass;
/**
 * 打卡
 */
@property (assign, nonatomic) NSInteger issign;
/**
 * 是否开店
 */
@property (assign, nonatomic) NSInteger ishavestore;

@end
