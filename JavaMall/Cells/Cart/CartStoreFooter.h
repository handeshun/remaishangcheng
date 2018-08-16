//
// Created by Dawei on 11/10/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Store;


@interface CartStoreFooter : UIControl

+ (float)heightWithObject:(Store *)store;

- (void)configData:(Store *)store;

@end