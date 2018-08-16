//
// Created by Dawei on 1/30/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GoodsFilterSelectDelegate <NSObject>

@optional
- (void) selectFilter:(NSMutableDictionary *) parameters;

@end