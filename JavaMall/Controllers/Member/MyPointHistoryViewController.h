//
// Created by Dawei on 7/5/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"


@interface MyPointHistoryViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>

/**
 * 类型:1为等级积分 2为消费积分
 */
@property(assign, nonatomic) NSInteger type;

@end