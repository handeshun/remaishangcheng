//
// Created by Dawei on 1/22/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ErrorView : UIView

- (instancetype)initWithTitle:(NSString *) errorText;

- (void) setGestureRecognizer:(UITapGestureRecognizer *)gestureRecognizer;

@end