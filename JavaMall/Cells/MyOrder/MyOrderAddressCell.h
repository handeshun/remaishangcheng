//
// Created by Dawei on 5/31/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ESButton;
@class Order;

#define kCellIdentifier_MyOrderAddressCell @"MyOrderAddressCell"

@interface MyOrderAddressCell : UITableViewCell

- (void)configData:(Order *)order;

@end