//
// Created by Dawei on 5/18/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Goods.h"

@protocol HotGoodsDelegate <NSObject>

/**
 * 点击商品
 */
- (void)selectHotGoods:(Goods *)goods;

@end