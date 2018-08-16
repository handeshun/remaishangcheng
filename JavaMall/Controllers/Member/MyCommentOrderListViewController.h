//
// Created by Dawei on 6/30/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"

@interface MyCommentOrderListViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>

@property(assign, nonatomic) NSInteger orderId;

@end