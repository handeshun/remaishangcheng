//
// Created by Dawei on 6/30/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ESTextView;

#define kCellIdentifier_PostCommentContentCell @"PostCommentContentCell"

@interface PostCommentContentCell : UITableViewCell <UITextViewDelegate>

@property(strong, nonatomic) ESTextView *contentTV;

@end