//
// Created by Dawei on 6/3/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseView.h"

@class Region;


@interface SelectRegionView : BaseView <UIPickerViewDataSource, UIPickerViewDelegate>

- (void)show;

- (void)hide;

@property(nonatomic, copy) void(^complete)(Region *province, Region *city, Region *region);

@end