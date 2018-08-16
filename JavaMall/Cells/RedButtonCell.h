//
// Created by Dawei on 6/3/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ESRedButton;


#define kCellIdentifier_RedButtonCell @"RedButtonCell"

@interface RedButtonCell : UITableViewCell

@property(strong, nonatomic) ESRedButton *button;

@end