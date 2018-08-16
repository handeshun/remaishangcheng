//
// Created by Dawei on 1/4/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDVTabBarController.h"


@interface RootTabViewController : RDVTabBarController<RDVTabBarControllerDelegate>

/**
 * 更新购物车角标
 */
- (void)updateCartBadge;

@end