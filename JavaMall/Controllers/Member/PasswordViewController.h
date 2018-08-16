//
// Created by Dawei on 7/5/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"


@interface PasswordViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>

@property(strong, nonatomic) NSString *oldPass;

@property(strong, nonatomic) NSString *nPass;

@property(strong, nonatomic) NSString *rePass;

@end