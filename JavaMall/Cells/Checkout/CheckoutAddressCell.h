//
// Created by Dawei on 5/31/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Address;
@class ESButton;

#define kCellIdentifier_CheckoutAddressCell @"CheckoutAddressCell"

@interface CheckoutAddressCell : UITableViewCell

- (void)configData:(Address *)address;

@end