//
// Created by Dawei on 6/20/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"

@class Shipping;
@class Payment;
@class Cart;


@interface PaymentShippingViewController : BaseViewController

@property(strong, nonatomic) NSMutableArray *paymentArray;

@property(strong, nonatomic) Cart *cart;

@property(strong, nonatomic) NSArray *shippingTimeArray;

@property(strong, nonatomic) Payment *payment;

@property(assign, nonatomic) NSInteger shippingTime;

/**
 * 配送地址区域id
 */
@property (assign, nonatomic) NSInteger regionId;

@end