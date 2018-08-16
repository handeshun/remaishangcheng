//
// Created by Dawei on 5/31/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Receipt;

#define kCellIdentifier_CheckoutReceiptCell @"CheckoutReceiptCell"

@interface CheckoutReceiptCell : UITableViewCell

- (void)configData:(Receipt *)receipt;

@end