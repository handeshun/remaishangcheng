//
// Created by Dawei on 5/31/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Shipping;
@class Payment;
@class Cart;

#define kCellIdentifier_CheckoutPaymentCell @"CheckoutPaymentCell"

@interface CheckoutPaymentCell : UITableViewCell

- (void)configData:(Payment *)payment cart:(Cart *)cart shippingTime:(NSInteger)shippingTime;

@end