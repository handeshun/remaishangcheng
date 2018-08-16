//
// Created by Dawei on 5/31/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kCellIdentifier_SelectImageCell @"SelectImageCell"

@interface SelectImageCell : UITableViewCell

- (void)setTitle:(NSString *)title;

- (void)setImageURL:(NSString *)imageUrl;

- (void)setImage:(UIImage *)image;

- (void)setImageBorder:(UIColor *)color circle:(BOOL)circle width:(float)width;

/**
 * 是否显示上边框和下边框
 */
- (void)showLine:(BOOL)showHeaderLine footerLine:(BOOL)showFooterLine;

@end