//
// Created by Dawei on 6/26/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kCellIdentifier_PaymentTitleCell @"PaymentTitleCell"
@interface PaymentTitleCell : UITableViewCell

- (void)configData:(double)amount;

@end