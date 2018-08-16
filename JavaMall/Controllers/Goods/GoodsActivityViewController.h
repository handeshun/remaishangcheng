//
// Created by Dawei on 10/28/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"


@interface GoodsActivityViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>

/**
 * 活动id
 */
@property (assign, nonatomic) NSInteger activity_id;

@end