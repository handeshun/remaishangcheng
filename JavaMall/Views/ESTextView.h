//
// Created by Dawei on 6/30/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ESTextView : UITextView

@property(nonatomic, retain) IBInspectable NSString *placeholder;
@property(nonatomic, retain) IBInspectable UIColor *placeholderColor;

- (void)textChanged:(NSNotification *)notification;

@end