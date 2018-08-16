//
// Created by Dawei on 1/28/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"
#import "BaseNavigationController.h"
#import "GoodsFilterValueSelectDelegate.h"

@protocol GoodsFilterSelectDelegate;

@interface GoodsFilterViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, GoodsFilterValueSelectDelegate>

@property (assign, nonatomic) id<GoodsFilterSelectDelegate> delegate;

@property (assign, nonatomic) NSInteger categoryId;

@property (strong, nonatomic) NSString *keyword;

@end