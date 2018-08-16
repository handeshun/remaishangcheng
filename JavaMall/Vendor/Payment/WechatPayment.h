//
//  WechatPayment.h
//  JavaMall
//
//  Created by Dawei on 9/2/15.
//  Copyright (c) 2015 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Order;
@class Payment;

@interface WechatPayment : NSObject

-(BOOL) init:(Order *)_order withPayment:(Payment *)payment;

- ( NSMutableDictionary *)pay;

@end
