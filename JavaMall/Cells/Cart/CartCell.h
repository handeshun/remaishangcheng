//
// Created by Dawei on 5/25/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CartGoods;
@class ESButton;
@class ESTextField;

#define kCellIdentifier_CartCell @"CartCell"
@interface CartCell : UITableViewCell

//是否处于编辑模式
@property (assign, nonatomic) BOOL isEditing;

@property (strong, nonatomic) ESButton *selectBtn;

@property (strong, nonatomic) ESButton *numberLessBtn;
@property (strong, nonatomic) ESTextField *numberTf;
@property (strong, nonatomic) ESButton *numberAddBtn;

- (void) configData:(CartGoods *)goods;

+ (CGFloat)cellHeightWithObj:(id)obj;

@end