//
// Created by Dawei on 7/3/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"
#import "NumberChangedDelegate.h"

@class OrderItem;
@class Order;


@interface ReturnedOrderViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, NumberChangedDelegate>

@property(strong, nonatomic) Order *order;
@property(strong, nonatomic) NSString *orderPaymentName;
@end