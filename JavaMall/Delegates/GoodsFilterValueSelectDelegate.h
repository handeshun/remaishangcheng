//
// Created by Dawei on 1/30/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GoodsFilter;

@protocol GoodsFilterValueSelectDelegate <NSObject>

@optional
- (void) selectValue:(GoodsFilter *) goodsFilter;

@end