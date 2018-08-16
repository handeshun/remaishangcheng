//
// Created by Dawei on 7/13/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"

@class Order;


@interface CancelOrderViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic) Order *order;

@end