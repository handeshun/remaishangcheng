//
// Created by Dawei on 7/5/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"
#import "ImagePicker.h"

@class Member;


@interface PersonEditViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource, ImagePickerDelegate>

@property(strong, nonatomic) Member *member;

@end