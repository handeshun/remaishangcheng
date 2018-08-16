//
// Created by Dawei on 7/3/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OrderItem;

#define kCellIdentifier_MyOrderGoodsCell @"MyOrderGoodsCell"

@interface MyOrderGoodsCell : UITableViewCell

- (void)configData:(OrderItem *)orderItem;

@end