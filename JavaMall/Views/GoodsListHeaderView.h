//
// Created by Dawei on 3/18/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseView.h"

typedef enum {
    List,
    Grid
} ListStyle;

typedef void(^GoodsListHeaderStyleBlock)(ListStyle style);

@interface GoodsListHeaderView : BaseView

- (instancetype)initWithFrame:(CGRect)frame;

/**
 * 设置切换样式的事件
 */
- (void)setStyleBlock:(GoodsListHeaderStyleBlock)block;

- (void)setBackAction:(SEL)action;

- (void)setSearchAction:(SEL)action;

- (void)setTitle:(NSString *)title;

@end