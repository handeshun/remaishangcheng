//
// Created by Dawei on 3/23/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CommentHeaderView : UIView

- (instancetype) initWithFrame:(CGRect) frame;

@property (assign, nonatomic) NSInteger allNumber;
@property (assign, nonatomic) NSInteger goodNumber;
@property (assign, nonatomic) NSInteger generalNumber;
@property (assign, nonatomic) NSInteger poorNumber;
@property (assign, nonatomic) NSInteger imageNumber;

@property (nonatomic, copy) void(^touchAtIndex)(NSInteger index);

@end