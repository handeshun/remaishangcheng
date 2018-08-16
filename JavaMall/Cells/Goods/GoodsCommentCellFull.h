//
// Created by Dawei on 2/3/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GoodsComment;
@protocol GoodsCommentImageDelegate;

#define kCellIdentifier_GoodsCommentCellFull @"GoodsCommentCellFull"

@interface GoodsCommentCellFull : UITableViewCell

- (void) configData:(GoodsComment *)comment;

- (void) setDelegate:(id<GoodsCommentImageDelegate>)delegate;

+ (CGFloat)cellHeightWithObj:(id)obj;

@end