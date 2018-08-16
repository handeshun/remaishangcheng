//
// Created by Dawei on 5/31/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Cart;

#define kCellIdentifier_CheckoutGoodsCell @"CheckoutGoodsCell"

@interface CheckoutGoodsCell : UITableViewCell

- (void)configData:(Cart *)cart;

@end