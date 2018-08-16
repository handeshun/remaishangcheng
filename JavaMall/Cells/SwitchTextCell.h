//
// Created by Dawei on 5/31/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kCellIdentifier_SwitchTextCell @"SwitchTextCell"
@interface SwitchTextCell : UITableViewCell

- (void)setSwitchOn:(BOOL)on;

- (void)setTitle:(NSString *)title;

@property(nonatomic, copy) void(^switchChangedBlock)(BOOL);

@end