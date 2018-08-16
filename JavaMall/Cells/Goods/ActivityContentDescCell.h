//
// Created by Dawei on 10/29/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kCellIdentifier_ActivityContentDescCell @"ActivityContentDescCell"
@interface ActivityContentDescCell : UITableViewCell

- (void)configData:(NSString *)title content:(NSString *)content icon:(UIImage *)icon;

@end