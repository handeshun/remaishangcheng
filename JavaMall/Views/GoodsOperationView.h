//
// Created by Dawei on 3/23/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseView.h"


@interface GoodsOperationView : BaseView

- (instancetype)initWithFrame:(CGRect)frame;

/**
 * 设置是否已经关注
 */
- (void)setFavorited:(BOOL)favorited;

/**
 * 设置购物车商品数量
 */
- (void)setCartCount:(NSInteger)cartCount;

/**
 * 设置添加到购物车事件
 */
- (void)setAddCartAction:(SEL)action;

/**
 * 设置店铺事件
 */
- (void)setStoreAction:(SEL)action;

/**
 * 设置购物车事件
 */
- (void)setCartAction:(SEL)action;

/**
 * 设置关注事件
 */
- (void)setFavoriteAction:(SEL)action;



@end
