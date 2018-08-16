//
// Created by Dawei on 7/11/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReturnedOrder : NSObject

@property(assign, nonatomic) NSInteger id;

/**
 * 订单ID
 */
@property(assign, nonatomic) NSInteger orderId;

/**
 * 状态
 */
@property(assign, nonatomic) NSInteger status;

/**
 * 状态
 */
@property(strong, nonatomic) NSString *statusString;

/**
 * 申请时间
 */
@property(strong, nonatomic) NSDate *createTime;

/**
 * 订单号
 */
@property(strong, nonatomic) NSString *sn;

/**
 * 退款支付方式名称
 */
@property(strong, nonatomic) NSString *refundWay;

/**
 * 退款账号
 */
@property(strong, nonatomic) NSString *returnAccount;

/**
 * 说明
 */
@property(strong, nonatomic) NSString *remark;

/**
 * 客服回复
 */
@property(strong, nonatomic) NSString *sellerRemark;

/**
 * 退货原因
 */
@property (strong, nonatomic) NSString *reason;

/**
 * 是否已收到货:0为未收到;1为已收到
 */
@property (assign, nonatomic) NSInteger ship_status;

/**
 * 退款金额
 */
@property (assign, nonatomic) double apply_alltotal;

/**
 * 1为退款；2为退货
 */
@property (assign, nonatomic) NSInteger type;

/**
 * 退货项
 */
@property(strong, nonatomic) NSMutableArray *returnedOrderItems;

@end