//
// Created by Dawei on 6/30/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"

@class Order;


@interface ReturnedOrderListViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic) Order *order;

@end