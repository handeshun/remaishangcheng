//
// Created by Dawei on 6/22/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ESButton.h"


@interface ESRadioButton : ESButton

@property(strong, nonatomic) id value;

/**
 * 设置标题
 */
- (void)setTitle:(NSString *)title;

@end