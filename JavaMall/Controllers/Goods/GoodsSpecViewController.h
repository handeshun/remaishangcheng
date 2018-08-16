//
// Created by Dawei on 3/24/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"

@class Goods;
@protocol GoodsSpecDelegate;


@interface GoodsSpecViewController : BaseViewController

@property (strong, nonatomic) id<GoodsSpecDelegate> delegate;

@end

@protocol GoodsSpecDelegate <NSObject>

@optional
- (Goods *) getGoods;

- (void) selectSpec:(Goods *) goods;

- (void) addToCart;

@end
