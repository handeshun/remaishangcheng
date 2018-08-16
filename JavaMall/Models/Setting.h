//
// Created by Dawei on 10/14/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Setting : NSObject

/**
 * 客服人员列表
 */
@property (strong, nonatomic) NSMutableArray *services;

/**
 * 当前客服
 */
@property (strong, nonatomic) NSString *currentService;

@end