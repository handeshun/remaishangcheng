//
// Created by Dawei on 1/5/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseView.h"


@interface StoreListHeaderView : BaseView

@property(strong, nonatomic) UILabel *titleLbl;

- (instancetype)init;

/**
 * 设置搜索事件
 */
- (void)setSearchAction:(SEL)action;

/**
 * 设置后退事件
 * @param action
 */
- (void)setBackAction:(SEL)action;

@end