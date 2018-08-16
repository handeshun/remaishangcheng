//
// Created by Dawei on 7/3/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Order;

#define kCellIdentifier_MyOrderAmountCell @"MyOrderAmountCell"

@interface MyOrderAmountCell : UITableViewCell

- (void)configData:(Order *)order;

@end