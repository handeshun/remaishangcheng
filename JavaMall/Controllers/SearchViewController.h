//
// Created by Dawei on 7/17/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"
#import "DropMenuView.h"

@protocol SearchDelegate;


@interface SearchViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, DropMenuViewDelegate>

@property(nonatomic, strong) NSObject <SearchDelegate> *delegate;

@end