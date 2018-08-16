//
// Created by Dawei on 6/26/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"

@class Payment;
@class Order;


@interface CheckoutSuccessViewController : BaseViewController

@property (assign, nonatomic) NSInteger type;

@property (strong, nonatomic) Order *order;

@property (strong, nonatomic) Payment *payment;

@end