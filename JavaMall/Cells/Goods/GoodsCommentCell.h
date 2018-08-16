//
// Created by Dawei on 2/3/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GoodsComment;
@protocol GoodsCommentImageDelegate;

#define kCellIdentifier_GoodsCommentCell @"GoodsCommentCell"

@interface GoodsCommentCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

- (void) configData:(GoodsComment *)comment;

- (void) setDelegate:(id<GoodsCommentImageDelegate>)delegate;

+ (CGFloat)cellHeightWithObj:(id)obj;

@end