//
// Created by Dawei on 5/30/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseView.h"

@class ESButton;


@interface CartEditView : BaseView

/**
 * 设置全选按钮状态
 */
- (void)setChecked:(BOOL)checked;

/**
 * 设置全选事件
 */
- (void)setCheckAction:(SEL)action;

/**
 * 设置移入关注事件
 */
- (void)setFavoriteAction:(SEL)action;

/**
 * 设置删除事件
 */
- (void)setDeleteAction:(SEL)action;

@end