//
// Created by Dawei on 3/23/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Store;

#define kCellIdentifier_GoodsStoreCell @"GoodsStoreCell"

@interface GoodsStoreCell : UITableViewCell

@property(strong, nonatomic) UIButton *gotoStoreBtn;

- (void)configData:(Store *)store;

@end