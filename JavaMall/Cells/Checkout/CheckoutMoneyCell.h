//
// Created by Dawei on 5/31/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OrderPrice;

#define kCellIdentifier_CheckoutMoneyCell @"CheckoutMoneyCell"

@interface CheckoutMoneyCell : UITableViewCell

- (void)configData:(OrderPrice *)orderPrice;

@end