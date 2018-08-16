//
// Created by Dawei on 6/21/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ESButton.h"


@interface ESCheckButton : ESButton

@property(strong, nonatomic) id value;
@property(nonatomic,assign) NSInteger typeids;

/**
 * 设置标题
 */
- (void)setTitle:(NSString *)title;

@end
