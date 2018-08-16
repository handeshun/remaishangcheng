//
//  ReceiptModel.h
//  JavaMall
//
//  Created by LDD on 17/7/6.
//  Copyright © 2017年 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReceiptModel : NSObject

/**
 *  发票类型
 */
@property (assign, nonatomic) NSInteger type;

/**
 *  发票Id
 */
@property (assign, nonatomic) NSInteger id;

/**
 *  发票抬头
 */
@property (strong, nonatomic) NSString *title;

/**
 *  发票内容
 */
@property (strong, nonatomic) NSString *content;

/**
 *  纳税号
 */
@property (strong, nonatomic) NSString *duty;

@end
