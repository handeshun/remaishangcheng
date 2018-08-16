//
// Created by Dawei on 7/3/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Order;

#define kCellIdentifier_MyOrderTitleCell @"MyOrderTitleCell"

@interface MyOrderTitleCell : UITableViewCell

- (void)configData:(NSString *)title value:(NSString *)value  content:(NSString *)content duby:(NSString *)duby headerLine:(BOOL)showHeaderLine footerLine:(BOOL)showFooterLine;

- (void)configData:(NSString *)title value:(NSString *)value  headerLine:(BOOL)showHeaderLine footerLine:(BOOL)showFooterLine;
-(void) configData:(NSString *)title value:(NSString *)value content:(NSString *)content headerLine:(BOOL)showHeaderLine footerLine:(BOOL)showFooterLine;
- (void)showArrow;

@end