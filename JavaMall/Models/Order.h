//
// Created by Dawei on 6/26/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ActivityGift;
@class Bonus;

typedef enum {
    OrderStatus_ALL = -1,         //全部订单
    OrderStatus_NOPAY = 0,          //新订单，货到付款需确认
    OrderStatus_CONFIRM = 1,        //已确认
    OrderStatus_PAY = 2,            //已支付
    OrderStatus_SHIP = 3,           //已发货
    OrderStatus_ROG = 4,            //已收货
    OrderStatus_COMPLETE = 5,       //已完成
    OrderStatus_CANCELLATION = 6,   //订单取消（货到付款审核未通过、新建订单取消、订单发货前取消）
    OrderStatus_MAINTENANCE = 7     //交易成功已申请售后申请
} OrderStatus;

typedef enum{
    PayStatus_NO = 0,               //未付款
    PayStatus_PARTIAL_PAYED = 1,    //部分付款
    PayStatus_YES = 2               //全部支付
} PayStatus;

typedef enum{
    ShipStatus_NO = 0,              //未发货
    ShipStatus_YES = 1,             //已发货
    ShipStatus_ROG = 2              //已收货
} ShipStatus;

@interface Order : NSObject

/**
 * 店铺地址
 */
@property (strong, nonatomic) NSString *storeAddr;
/**
 * 订单id
 */
@property (assign, nonatomic) NSInteger id;

/**
 * 订单号
 */
@property (strong, nonatomic) NSString *sn;

/**
 * 订单金额
 */
@property (assign, nonatomic) double orderAmount;

/**
 * 商品金额
 */
@property (assign, nonatomic) double goodsAmount;

/**
 * 配送费用
 */
@property (assign, nonatomic) double shippingAmount;

/**
 * 优惠金额
 */
@property (assign, nonatomic) double discount;

/**
 * 促销优惠金额
 */
@property (assign, nonatomic) double actDiscount;

/**
 * 应付金额
 */
@property (assign, nonatomic) double needPayMoney;

/**
 * 订单状态
 */
@property (assign, nonatomic) NSInteger status;

/**
 * 支付状态
 */
@property (assign, nonatomic) NSInteger paymentStatus;

/**
 * 物流状态
 */
@property (assign, nonatomic) NSInteger shippingStatus;

/**
 * 付款方式id
 */
@property (assign, nonatomic) NSInteger paymentId;

/**
 * 支付方式名称
 */
@property (strong, nonatomic) NSString *paymentName;

/**
 * 支付方式类型
 */
@property (strong, nonatomic) NSString *paymentType;

/**
 * 配送方式id
 */
@property (assign, nonatomic) NSInteger shippingId;

/**
 * 配送方式名称
 */
@property (strong, nonatomic) NSString *shippingName;

/**
 * 货运单号
 */
@property (strong, nonatomic) NSString *shippingNumber;

/**
 * 地址id
 */
@property (assign, nonatomic) NSInteger addressId;

/**
 * 订单创建时间
 */
@property (strong, nonatomic) NSDate *createTime;

/**
 * 订单取消原因
 */
@property (strong, nonatomic) NSString *cancelReason;

/**
 * 收货省
 */
@property (assign, nonatomic) NSInteger provinceId;

/**
 * 收货市
 */
@property (assign, nonatomic) NSInteger cityId;

/**
 * 收货县
 */
@property (assign, nonatomic) NSInteger regionId;

/**
 * 收货地址区域
 */
@property (strong, nonatomic) NSString *area;

/**
 * 收货详细地址
 */
@property (strong, nonatomic) NSString *address;

/**
 * 收货手机号码
 */
@property (strong, nonatomic) NSString *mobile;

/**
 * 收货人姓名
 */
@property (strong, nonatomic) NSString *name;

/**
 * 配送时间
 */
@property (strong, nonatomic) NSString *shippingTime;

/**
 * 订单备注
 */
@property (strong, nonatomic) NSString *remark;

/**
 * 是否已取消
 */
@property (assign, nonatomic) NSInteger is_cancel;

/**
 * 订单项
 */
@property (strong, nonatomic) NSMutableArray *orderItems;

/**
 * 订单状态名称
 */
@property (strong, nonatomic) NSString *statusString;

/**
 * 是否是货到付款
 */
@property (assign, nonatomic) BOOL isCod;

/***
 * 订单赠品
 */
@property (strong, nonatomic) ActivityGift *gift;

/**
 * 订单赠送优惠券
 */
@property (strong, nonatomic) Bonus *bonus;

/**
 * 订单类型
 */
@property (assign,nonatomic) long order_type;

@end
