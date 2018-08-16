//
// Created by Dawei on 10/21/15.
// Copyright (c) 2015 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView (Common)

/**
 * 将view设置为圆型
 */
- (void) circleFrame;

/**
 * 设置边框
 */
- (void) borderWidth:(CGFloat)width color:(UIColor *)color cornerRadius:(CGFloat)cornerRadius;

/**
 * 添加下边框
 */
- (void) bottomBorder:(UIColor *)color;

/**
 * 添加下边框
 */
- (void) bottomBorder:(UIColor *)color size:(CGSize) size;

/**
 * 添加上边框
 */
- (void) topBorder:(UIColor *)color;

/**
 * 添加上边框
 */
- (void) topBorder:(UIColor *)color size:(CGSize) size;

- (void)setY:(CGFloat)y;
- (void)setX:(CGFloat)x;
- (void)setOrigin:(CGPoint)origin;
- (void)setHeight:(CGFloat)height;
- (void)setWidth:(CGFloat)width;
- (void)setSize:(CGSize)size;

@end