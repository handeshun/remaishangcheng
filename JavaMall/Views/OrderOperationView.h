//
// Created by Dawei on 5/30/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseView.h"

@class ESButton;
@class Order;


@interface OrderOperationView : BaseView

@property(strong, nonatomic) ESButton *paymentBtn;

//@property(strong, nonatomic) ESButton *commentBtn;

@property(strong, nonatomic) ESButton *rogBtn;

@property(strong, nonatomic) ESButton *returnedBtn;

@property (strong, nonatomic) ESButton *cancelBtn;

@property (strong, nonatomic) ESButton *viewReturnedBtn;

- (void)configData:(Order *)order;

@end