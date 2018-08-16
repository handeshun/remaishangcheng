//
// Created by Dawei on 7/5/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PointHistory : NSObject

@property (assign, nonatomic) NSInteger id;

/**
 * 时间
 */
@property (strong, nonatomic) NSDate *time;

/**
 * 原因
 */
@property (strong, nonatomic) NSString *reason;

/**
 * 等级积分
 */
@property (assign, nonatomic) NSInteger point;

/**
 * 消费积分
 */
@property (assign, nonatomic) NSInteger mp;

@end