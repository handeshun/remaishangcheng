//
// Created by Dawei on 6/30/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OrderItem;
@class ESButton;
@class Order;

#define kCellIdentifier_ReturnedOrderCell @"ReturnedOrderCell"

@interface ReturnedOrderCell : UITableViewCell

- (void)configData:(OrderItem *)orderItem order:(Order *)order;

@end