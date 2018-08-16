//
// Created by Dawei on 2/2/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImagePlayerView.h"
@class Goods;

#define kCellIdentifier_GoodsGalleryCell @"GoodsGalleryCell"

@interface GoodsGalleryCell : UITableViewCell

- (void) setDelegate:(id<ImagePlayerViewDelegate>)delegate;

- (void) reloadData;

+ (CGFloat)cellHeightWithObj:(id)obj;

@end