//
// Created by Dawei on 11/7/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"


@interface MyBonusListViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>

@property(assign, nonatomic) NSInteger type;

@end