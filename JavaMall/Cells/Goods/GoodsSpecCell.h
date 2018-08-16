//
// Created by Dawei on 2/3/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Goods;

#define kCellIdentifier_GoodsSpecCell @"GoodsSpecCell"


@interface GoodsSpecCell : UITableViewCell

@property (nonatomic,weak)UIImageView *arrow;

- (void) configData:(Goods *)goods;

+ (CGFloat)cellHeightWithObj:(Goods *)goods;

@end
