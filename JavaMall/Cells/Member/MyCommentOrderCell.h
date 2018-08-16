//
// Created by Dawei on 6/30/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ESButton;
@class Goods;

#define kCellIdentifier_MyCommentOrderCell @"MyCommentOrderCell"

@interface MyCommentOrderCell : UITableViewCell

@property(strong, nonatomic) ESButton *commentBtn;

- (void)configData:(Goods *)goods;

@end