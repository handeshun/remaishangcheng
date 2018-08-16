//
// Created by Dawei on 9/22/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"


@interface PaymentManager : NSObject <WXApiDelegate>

+ (instancetype)sharedManager;

/**
 * 处理支付宝支付结果
 * @param status
 */
+ (void)alipayResult:(int)status;

/**
 * 处理银联支付结果
 * @param code
 * @param data
 */
+ (void)unionpayResult:(NSString *)code data:(NSDictionary *)data;

@end