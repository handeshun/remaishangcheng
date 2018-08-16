//
// Created by Dawei on 7/12/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ESLabel;

#define kCellIdentifier_ShowTextCell @"ShowTextCell"

@interface ShowTextCell : UITableViewCell

@property(strong, nonatomic) ESLabel *titleLbl;

@property(strong, nonatomic) UITextView *textView;

- (void)setTitle:(NSString *)title;

- (void)setText:(NSString *)text;

- (void)showLine:(BOOL)headerLine footerLine:(BOOL)footerLine;

+ (CGFloat)cellHeightWithTitle:(NSString *)title text:(NSString *)text;

@end