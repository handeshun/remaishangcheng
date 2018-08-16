//
// Created by Dawei on 5/31/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Bonus;
@class Cart;

#define kCellIdentifier_CheckoutCouponCell @"CheckoutCouponCell"

@interface CheckoutCouponCell : UITableViewCell

- (void)configData:(Cart *)cart;

@end