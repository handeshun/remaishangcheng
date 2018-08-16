//
// Created by Dawei on 6/30/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"
#import "ImagePicker.h"

@class Goods;


@interface PostCommentViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic) Goods *goods;

@end