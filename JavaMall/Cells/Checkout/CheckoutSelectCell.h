//
// Created by Dawei on 6/21/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ESLabel;

#define kCellIdentifier_CheckoutSelectCell @"CheckoutSelectCell"

@interface CheckoutSelectCell : UITableViewCell

@property(strong, nonatomic) ESLabel *titleLbl;

@property(strong, nonatomic) NSMutableArray *buttons;

- (void)setTitle:(NSString *)title;

- (void)configData:(NSMutableArray *)nameArray;

- (void)showLine:(BOOL)header footer:(BOOL)footer;

+ (CGFloat)cellHeightWithObj:(NSMutableArray *)nameArray;

@end