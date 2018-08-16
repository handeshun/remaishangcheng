//
// Created by Dawei on 11/8/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"
#import "SearchDelegate.h"


@interface StoreListViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource, SearchDelegate>

/**
 * 搜索关键词
 */
@property (strong, nonatomic) NSString *keyword;

@end