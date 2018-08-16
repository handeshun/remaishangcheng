//
// Created by Dawei on 11/3/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"
#import "ViewPagerController.h"
#import "StoreDelegate.h"


@interface StoreViewController : ViewPagerController<StoreDelegate>

/**
 * 店铺id
 */
@property (assign, nonatomic) NSInteger storeid;

@end