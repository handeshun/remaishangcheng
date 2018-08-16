//
// Created by Dawei on 5/30/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseView.h"


@interface CartCheckoutView : BaseView

/**
 * 设置合计金额
 */
- (void)setTotalPrice:(double)totalPrice;

/**
 * 设置点击去结算的事件
 */
- (void)setCheckoutAction:(SEL)action;

/**
 * 全选按钮是否选中
 * @return
 */
- (BOOL)isChecked;

/**
 * 设置全选按钮状态
 * @param checked
 */
- (void)setChecked:(BOOL)checked;

/**
 * 设置全选事件
 */
- (void)setCheckAction:(SEL)action;

@end