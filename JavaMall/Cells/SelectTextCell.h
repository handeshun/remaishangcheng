//
// Created by Dawei on 5/31/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kCellIdentifier_SelectTextCell @"SelectTextCell"

@interface SelectTextCell : UITableViewCell

- (void)setTitle:(NSString *)title;

- (void)setValue:(NSString *)value;

@end