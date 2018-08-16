//
// Created by Dawei on 6/22/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"

@class Cart;


@interface CheckoutBonusViewController : BaseViewController

@property (strong, nonatomic) Cart *cart;

/**
 * 配送地址区域id
 */
@property (assign, nonatomic) NSInteger regionId;

@end