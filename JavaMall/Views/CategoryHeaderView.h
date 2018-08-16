//
// Created by Dawei on 1/5/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseView.h"


@interface CategoryHeaderView : BaseView

- (instancetype)init;

/**
 * 设置搜索事件
 */
- (void)setSearchAction:(SEL)action;

@end