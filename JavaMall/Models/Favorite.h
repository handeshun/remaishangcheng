//
// Created by Dawei on 7/5/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Goods;


@interface Favorite : NSObject

@property (assign, nonatomic) NSInteger id;

@property (strong, nonatomic) Goods *goods;

@end