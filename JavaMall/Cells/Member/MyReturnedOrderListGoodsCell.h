//
// Created by Dawei on 7/5/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Favorite;
@class ReturnedOrderItem;

#define kCellIdentifier_MyReturnedOrderListGoodsCell @"MyReturnedOrderListGoodsCell"

@interface MyReturnedOrderListGoodsCell : UITableViewCell

- (void)configData:(ReturnedOrderItem *)returnedOrderItem;

@end