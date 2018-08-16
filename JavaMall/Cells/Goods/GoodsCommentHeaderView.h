//
// Created by Dawei on 2/3/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Goods;


@interface GoodsCommentHeaderView : UIView

- (instancetype) initWithGoods:(Goods *) goods;

- (void) configData:(Goods *)goods;

@end