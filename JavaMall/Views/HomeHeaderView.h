//
// Created by Dawei on 1/5/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseView.h"


@interface HomeHeaderView : BaseView

- (instancetype)init;

/**
 * 设置背景色透明度
 */
- (void)setBackgroundAlpha:(float)alpha;

/**
 * 设置扫一扫的事件
 */
- (void)setScanAction:(SEL)action;

/**
 * 设置搜索事件
 */
- (void)setSearchAction:(SEL)action;

/**
 * 设置消息事件
 */
- (void)setIMAction:(SEL)action;

/**
 * 设置地图的事件
 */
- (void)setDressAction:(SEL)action;

/**
 * 隐藏消息图标
 */
- (void)hideIM;

/**
 * 设置是否有新消息
 * @param have
 */
-(void)setHaveMessage:(BOOL)have;

@end
