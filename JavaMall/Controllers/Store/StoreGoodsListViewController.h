//
// Created by Dawei on 11/6/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"
#import "MaskDelegate.h"
#import "SearchDelegate.h"


@interface StoreGoodsListViewController : BaseViewController<MaskDelegate, SearchDelegate>

@property(assign, nonatomic) NSInteger storeid;

@property (assign, nonatomic) NSInteger categoryId;

@property (strong, nonatomic) NSString *keyword;

@end