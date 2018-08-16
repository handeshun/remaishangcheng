//
// Created by Dawei on 3/24/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ESNumberView : UIView<UITextFieldDelegate>

- (instancetype)initWithMin:(NSInteger)minNumber max:(NSInteger)maxNumber value:(NSInteger)value;

@property (assign, nonatomic) NSInteger value;

@property (nonatomic, copy) void(^numberChanged)(NSInteger number);

@end