//
// Created by Dawei on 2/2/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Goods;

#define kCellIdentifier_GoodsNameCell @"GoodsNameCell"

@interface GoodsNameCell : UITableViewCell

- (void) configData:(Goods *)goods;

+ (CGFloat)cellHeightWithObj:(id)obj;

@end