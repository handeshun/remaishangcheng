//
// Created by Dawei on 6/30/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Goods;

#define kCellIdentifier_PostCommentGradeCell @"PostCommentGradeCell"

@interface PostCommentGradeCell : UITableViewCell

@property(assign, nonatomic) NSInteger grade;

- (void)configData:(Goods *)goods;

@end