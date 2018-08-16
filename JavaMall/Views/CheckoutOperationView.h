//
// Created by Dawei on 5/30/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseView.h"


@interface CheckoutOperationView : BaseView

/**
 * 设置合计金额
 */
- (void)setTotalPrice:(double)totalPrice;

/**
 * 设置点击去结算的事件
 */
- (void)setCheckoutAction:(SEL)action;

@end