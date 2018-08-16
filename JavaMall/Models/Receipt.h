//
// Created by Dawei on 6/22/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Receipt : NSObject


@property (assign, nonatomic) NSInteger id;

/**
 * 发票类型:0为不开发票; 1:个人; 2:公司
 */
@property (assign, nonatomic) NSInteger type;

/**
 * 发票抬头
 */
@property (strong, nonatomic) NSString *title;

/**
 * 发票内容
 */
@property (strong, nonatomic) NSString *content;

@property (strong, nonatomic) NSString *duby;
@end