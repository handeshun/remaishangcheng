//
// Created by Dawei on 6/29/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ReturnedOrder;


#define kCellIdentifier_MyReturnedOrderListStatusCell @"MyReturnedOrderListStatusCell"

@interface MyReturnedOrderListStatusCell : UITableViewCell

- (void)configData:(ReturnedOrder *)returnedOrder;

@end