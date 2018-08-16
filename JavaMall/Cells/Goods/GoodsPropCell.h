//
// Created by Dawei on 2/3/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Goods;

#define kCellIdentifier_GoodsPropCell @"GoodsPropCell"


@interface GoodsPropCell : UITableViewCell

- (void) configData:(Goods *) goods;

+ (CGFloat)cellHeightWithObj:(id)obj;

@end