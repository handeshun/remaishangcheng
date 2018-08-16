//
// Created by Dawei on 1/31/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"
#import "GoodsCommentImageDelegate.h"


@interface GoodsCommentViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource, GoodsCommentImageDelegate>

@property (assign, nonatomic) NSInteger goodsId;

@end