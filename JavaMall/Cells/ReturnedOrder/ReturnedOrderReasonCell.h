//
// Created by Dawei on 7/3/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OrderItem;

#define kCellIdentifier_ReturnedOrderReasonCell @"ReturnedOrderReasonCell"

@interface ReturnedOrderReasonCell : UITableViewCell

@property(strong, nonatomic) NSString *reason;

- (void)setTitle:(NSString *)title;

- (void)setValue:(NSString *)value;

@end