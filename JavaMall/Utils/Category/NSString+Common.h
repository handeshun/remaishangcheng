//
// Created by Dawei on 10/20/15.
// Copyright (c) 2015 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Common)

/**
 * 根据字体及大小获取占用的位置大小
 */
- (CGSize) getSizeWithFont:(UIFont *)font;

- (CGSize)getSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

/**
 * 过滤赶紧空格
 */
- (NSString *) trimWhiteSpace;

/**
 * 是否为空
 */
- (BOOL) isEmpty;

/**
 * 是否为整形
 */
- (BOOL) isInt;

/**
 * 是否为浮点型
 */
- (BOOL) isFloat;

/**
 * 转换为拼音
 */
- (NSString *) transformToPinyin;

/**
 * 是否为手机号码
 */
- (BOOL)isMobile;

@end