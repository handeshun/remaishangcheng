//
// Created by Dawei on 6/22/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseApi.h"

@class OrderPrice;
@class Address;
@class Payment;
@class Shipping;
@class Receipt;
@class Order;
@class ReturnedOrder;
@class Delivery;
@class Cart;
@class ReceiptModel;


@interface OrderApi : BaseApi

/**
 * 获取订单金额信息
 */
- (void)orderPrice:(NSInteger)regionid shippingId:(NSInteger)shippingid success:(void (^)(OrderPrice *orderPrice))success failure:(void (^)(NSError *error))failure;

/**
 * 使用一张优惠券
 */
- (void)useBonus:(NSInteger)bonusId success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 * 提交订单
 */
- (void)create:(Order *)order receipt:(Receipt *)receipt success:(void (^)(Order *order))success failure:(void (^)(NSError *error))failure;

/**
 * 获取订单列表
 */
- (void)list:(NSInteger)status page:(NSInteger)page success:(void (^)(NSMutableArray *orderArray))success failure:(void (^)(NSError *error))failure;

/**
 * 获取订单详情
 */
- (void)detail:(NSInteger)orderId success:(void (^)(Order *order, Receipt *receipt))success failure:(void (^)(NSError *error))failure;

/**
 * 取消订单
 */
- (void)cancel:(NSInteger)orderId reason:(NSString *)reason success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 * 确认收货
 */
- (void)rogConfirm:(NSInteger)orderId success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 * 申请退货
 */
- (void)returned:(ReturnedOrder *)returnedOrder success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 * 申请退款
 * @param returnedOrder
 * @param success
 * @param failure
 */
- (void)refund:(ReturnedOrder *)returnedOrder success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 * 退货申请列表
 */
- (void)returnedOrderList:(NSInteger)page success:(void (^)(NSMutableArray *orderList))success failure:(void (^)(NSError *error))failure;

/**
 * 退货申请详情
 * @param id
 * @param orderId
 * @param success
 * @param failure
 */
- (void)returnedOrder:(NSInteger)id orderId:(NSInteger)orderId success:(void (^)(ReturnedOrder *returnedOrder))success failure:(void (^)(NSError *error))failure;

/**
 * 查询订单物流信息
 * @param orderId
 * @param success
 * @param failure
 */
- (void)delivery:(NSInteger)orderId success:(void (^)(Delivery *delivery, NSMutableArray *expressArray))success failure:(void (^)(NSError *error))failure;

/**
 *  获取用户发票列表
 *
 *  @param success
 *  @param failure
 */
-(void)getReceiptList:(void(^)( NSMutableArray *receiptList))success failure:(void (^)(NSError *error))failure;

/**
 *  添加发票
 *
 *  @param success
 *  @param failure
 */
-(void)addReceipt:(Receipt *)receiptmodel success:(void(^)(ReceiptModel *receiptList))success failure:(void (^)(NSError *error))failure;

/**
 *  获取发票内容
 *
 *  @param success
 *  @param failure
 */
-(void)getReceiptContent:(void(^)(NSMutableArray *receiptList))success failure:(void (^)(NSError *error))failure;


/**
 * 修改配送方式或优惠卷
 * @param regionid
 * @param cart
 * @param success
 * @param failure
 */
- (void)changeShipBonus:(NSInteger)regionid Cart:(Cart *)cart success:(void (^)(OrderPrice *orderPrice))success failure:(void (^)(NSError *error))failure;

@end