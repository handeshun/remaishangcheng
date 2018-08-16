//
// Created by Dawei on 5/31/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ESTextField;
@class ESLabel;


#define kCellIdentifier_InputTextCell @"InputTextCell"

@interface InputTextCell : UITableViewCell

@property(strong, nonatomic) ESTextField *textField;

@property(strong, nonatomic) ESLabel *titleLbl;

@property(nonatomic, copy) void(^textValueChangedBlock)(NSString *);

@property(nonatomic, copy) void(^editDidEndBlock)(NSString *);

- (void)setTitle:(NSString *)title andPlaceHolder:(NSString *)placeHolder;

- (void)setValue:(NSString *)value;

/**
 * 是否显示上边框和下边框
 */
- (void)showLine:(BOOL)showHeaderLine footerLine:(BOOL)showFooterLine;

@end