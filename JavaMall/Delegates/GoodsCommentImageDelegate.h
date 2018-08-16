//
// Created by Dawei on 3/21/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GoodsComment;

@protocol GoodsCommentImageDelegate <NSObject>

@optional
- (void) didTapImageAtIndex:(NSInteger)index comment:(GoodsComment *)comment;

@end