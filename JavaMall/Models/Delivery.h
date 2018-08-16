//
// Created by Dawei on 9/22/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Delivery : NSObject

/**
 * 货运单id
 */
@property (assign, nonatomic) NSInteger deliveryId;

/**
 * 快递单号
 */
@property (strong, nonatomic) NSString *logicNumber;

/**
 * 快递公司名称
 */
@property (strong, nonatomic) NSString *logicName;

@end