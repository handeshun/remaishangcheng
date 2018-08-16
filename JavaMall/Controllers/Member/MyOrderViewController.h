//
// Created by Dawei on 7/3/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"


@interface MyOrderViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>

@property(assign, nonatomic) NSInteger orderId;

@end