//
// Created by Dawei on 3/23/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DateUtils : NSObject

/**
 * 将时间转换为字符串
 */
+ (NSString *) dateToString:(NSDate *)date;

/**
 * 将时间转换成指定格式的字符串
 */
+ (NSString *) dateToString:(NSDate *)date withFormat:(NSString *)format;

/**
 * 将字符串转换为日期对象
 */
+ (NSString *) stringToDate:(NSString *)string withFormat:(NSString *)format;

/**
 * 将时间戳转换为日期对象
 */
+ (NSDate *) timestampToDate:(NSInteger)timestamp;

/**
 * 将日期对象转换为时间戳
 */
+ (NSInteger) dateToTimestamp:(NSDate *)date;

@end