//
// Created by Dawei on 6/20/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    Payment_Alipay,
    Payment_Wechat,
    Payment_UnionPay,
    Payment_Cod
} PaymentType;

@interface Payment : NSObject

@property(nonatomic, assign) NSInteger id;

@property(strong, nonatomic) NSString *name;

@property(strong, nonatomic) NSString *config;

/**
 * 支付方式类型:alipay、wechat、unionpay
 */
@property(assign, nonatomic) PaymentType type;

@end