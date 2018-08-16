//
// Created by Dawei on 6/26/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"
#import "WXApi.h"

@class Payment;
@class Order;


@interface PaymentViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, WXApiDelegate>

@property(assign, nonatomic) NSInteger orderId;

/**
 * 类型：0为结算时的支付，1为订单列表时的支付
 */
@property (assign, nonatomic) NSInteger type;

@end