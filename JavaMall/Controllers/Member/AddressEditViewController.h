//
// Created by Dawei on 5/31/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"

@class Address;


@interface AddressEditViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) Address *address;

@end