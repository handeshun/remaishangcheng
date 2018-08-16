//
// Created by Dawei on 7/3/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ESTextView;
@class ESLabel;

#define kCellIdentifier_InputTextViewCell @"InputTextViewCell"

@interface InputTextViewCell : UITableViewCell

@property(strong, nonatomic) ESTextView *remarkTV;

@property(strong, nonatomic) ESLabel *titleLbl;

@end