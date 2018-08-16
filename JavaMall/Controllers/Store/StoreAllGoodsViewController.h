//
// Created by Dawei on 11/5/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"

@protocol StoreDelegate;


@interface StoreAllGoodsViewController : BaseViewController

@property(strong, nonatomic) id <StoreDelegate> delegate;

@property (assign, nonatomic) NSInteger storeid;

@property (strong, nonatomic) NSString *keyword;

@property (assign, nonatomic) NSInteger catid;

@end