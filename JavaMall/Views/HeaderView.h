//
// Created by Dawei on 12/28/15.
// Copyright (c) 2015 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseView.h"



@interface HeaderView : BaseView

@property (strong, nonatomic) UILabel *titleLbl;

@property (strong, nonatomic) CALayer *lineLayer;

- (instancetype)initWithTitle:(NSString *) _title;

/**
 * 添加后退按钮事件
 */
- (void)setBackAction:(SEL)action;

/**
 * 添加取消按钮及事件
 */
- (void)setCancelAction:(SEL)action;

@end