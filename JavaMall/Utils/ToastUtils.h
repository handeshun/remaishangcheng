//
// Created by Dawei on 5/11/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ToastUtils : NSObject

/**
 * 显示提示信息,并在几秒之后关闭
 */
+ (void) show:(NSString *)text hideAfterDelay:(NSTimeInterval) interval;

/**
 * 显示提示信息并在2秒之后关闭
 */
+ (void) show:(NSString *)text;

/**
 * 显示Loading
 */
+ (void) showLoading;

/**
 * 显示Loading及提示文本
 */
+ (void)showLoading:(NSString *)text;

/**
 * 隐藏Loading
 */
+ (void) hideLoading;

@end