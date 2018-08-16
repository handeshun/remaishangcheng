//
// Created by Dawei on 7/14/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "UIAlertController+SupportedInterfaceOrientations.h"


@implementation UIAlertController (SupportedInterfaceOrientations)

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 90000
- (NSUInteger)supportedInterfaceOrientations; {
    return UIInterfaceOrientationMaskPortrait;
}
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
#endif

@end