//
// Created by Dawei on 6/26/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Payment;

#define kCellIdentifier_PaymentCell @"PaymentCell"

@interface PaymentCell : UITableViewCell

- (void)configData:(Payment *)payment;

@end