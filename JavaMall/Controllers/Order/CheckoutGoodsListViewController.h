//
// Created by Dawei on 6/20/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"

@class Cart;


@interface CheckoutGoodsListViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic) Cart *cart;

@end