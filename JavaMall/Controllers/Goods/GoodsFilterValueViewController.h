//
// Created by Dawei on 1/29/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"

@class GoodsFilter;
@protocol GoodsFilterValueSelectDelegate;


@interface GoodsFilterValueViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>

@property (assign, nonatomic) id<GoodsFilterValueSelectDelegate> delegate;

@property (strong, nonatomic) GoodsFilter *filter;

@end