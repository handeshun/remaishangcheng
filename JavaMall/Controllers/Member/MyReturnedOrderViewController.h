//
// Created by Dawei on 7/13/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"

@class ReturnedOrder;


@interface MyReturnedOrderViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>

/**
 * 退货单ID
 */
@property (assign, nonatomic) NSInteger id;

/**
 * 订单ID
 */
@property (assign, nonatomic) NSInteger orderId;

@end