//
// Created by Dawei on 7/5/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PointHistory;

#define kCellIdentifier_MyPointHistoryCell @"MyPointHistoryCell"

@interface MyPointHistoryCell : UITableViewCell

- (void)configData:(PointHistory *)pointHistory andType:(NSInteger)type;

@end