//
// Created by Dawei on 8/14/15.
// Copyright (c) 2015 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "AlipayOrder.h"
#import "DataSigner.h"
#import "APAuthV2Info.h"

@class Payment;
@class Order;

@interface AlipayPaymentHelper : NSObject

/**
* 支付宝移动支付
*/
+ (NSString *) generateOrderString:(Order *)order withPayment:(Payment *)payment;

@end