//
// Created by Dawei on 1/4/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "HotGoodsDelegate.h"


@interface CartViewController : BaseViewController<HotGoodsDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
@end