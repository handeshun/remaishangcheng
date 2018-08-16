//
// Created by Dawei on 1/5/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseView.h"

@protocol MaskDelegate;
@protocol SearchDelegate;


@interface StoreHeaderView : BaseView <UITextFieldDelegate>

- (instancetype)init;

/**
 * 设置后退事件
 */
- (void)setBackAction:(SEL)action;

/**
 * 设置分类事件
 */
- (void)setCategoryAction:(SEL)action;

/**
 * 取消
 */
- (IBAction)cancel;

@property(strong, nonatomic) id <MaskDelegate> maskDelegate;

@property(strong, nonatomic) id <SearchDelegate> searchDelegate;

@end