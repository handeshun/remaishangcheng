//
// Created by Dawei on 7/17/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kCellIdentifier_SearchHistoryCell @"SearchHistoryCell"

@interface SearchHistoryCell : UITableViewCell

- (void)configData:(NSString *)keyword;

@end