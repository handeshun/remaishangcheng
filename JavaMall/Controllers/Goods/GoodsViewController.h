//
// Created by Dawei on 1/27/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"
#import "ViewPagerController.h"
#import "GoodsIntroViewController.h"
#import "GoodsSpecViewController.h"

@class Goods;


@interface GoodsViewController : ViewPagerController<GoodsIntroDelegate, GoodsSpecDelegate>

@property (strong, nonatomic) Goods *goods;

@end