//
// Created by Dawei on 11/3/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseView.h"

@class ESButton;
@class Store;


@interface StoreBannerView : BaseView

/**
 * 关注按钮
 */
@property(strong, nonatomic) ESButton *collectBtn;

- (void)configData:(Store *)store;

@end