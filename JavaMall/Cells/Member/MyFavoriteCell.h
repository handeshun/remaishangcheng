//
// Created by Dawei on 7/5/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Favorite;

#define kCellIdentifier_MyFavoriteCell @"MyFavoriteCell"

@interface MyFavoriteCell : UITableViewCell

- (void)configData:(Favorite *)favorite;

@end