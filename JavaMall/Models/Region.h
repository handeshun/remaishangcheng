//
// Created by Dawei on 6/3/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Region : NSObject

@property (assign, nonatomic) NSInteger id;

@property (strong, nonatomic) NSString *name;

@property (strong, nonatomic) NSString *zipcode;

/**
 * 是否支持货到付款
 */
@property (assign, nonatomic) BOOL cod;

@end