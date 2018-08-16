//
// Created by Dawei on 5/10/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "BaseView.h"


@implementation BaseView {

}

/**
 * 获取UIView对象所属的ViewController
 */
- (UIViewController *)viewController {
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *) nextResponder;
        }
    }
    return nil;
}

@end