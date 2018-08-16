//
// Created by Dawei on 6/20/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseApi.h"


@interface PaymentShippingApi : BaseApi

/**
 * 获取支付方式和配送方式列表
 */
- (void)list:(void (^)(NSMutableArray *paymentArray, NSMutableArray *shippingArray))success failure:(void (^)(NSError *error))failure;

/**
 * 获取由服务端发起支付后,获取到的参数,目前只用于银联支付
 */
-(void)payment:(NSInteger)orderId paymentId:(NSInteger)paymentId success:(void (^)(NSString *payhtml))success failure:(void (^)(NSError *error))failure;

@end