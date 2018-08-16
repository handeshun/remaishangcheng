//
// Created by Dawei on 9/22/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EaseMessageViewController.h"

#define KNOTIFICATIONNAME_DELETEALLMESSAGE @"RemoveAllMessages"
#define kHaveUnreadAtMessage    @"kHaveAtMessage"

@interface ChatViewController : EaseMessageViewController <EaseMessageViewControllerDelegate, EaseMessageViewControllerDataSource>


@end