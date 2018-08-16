//
// Created by Dawei on 11/3/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Goods.h"

@protocol StoreDelegate <NSObject>

- (void)scroll:(CGPoint)offset;

- (void)showGoods:(Goods *)goods;

@end