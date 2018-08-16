//
// Created by Dawei on 6/28/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kCellIdentifier_PersonItemCell @"PersonItemCell"

@interface PersonItemCell : UITableViewCell

- (void)configData:(NSString *)title icon:(UIImage *)icon remark:(NSString *)remark headLine:(BOOL)showHeaderLine footerLine:(BOOL)showFooterLine;

@end