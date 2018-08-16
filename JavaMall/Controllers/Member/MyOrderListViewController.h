//
// Created by Dawei on 6/29/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"


@interface MyOrderListViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>

/**
 * 要加载的订单状态
 */
@property(assign, nonatomic) NSInteger status;

@end