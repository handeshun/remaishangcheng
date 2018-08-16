//
// Created by Dawei on 3/23/17.
// Copyright (c) 2017 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NumberChangedDelegate <NSObject>

- (void) numberChanged:(NSInteger)number tag:(NSInteger)tag;

@end