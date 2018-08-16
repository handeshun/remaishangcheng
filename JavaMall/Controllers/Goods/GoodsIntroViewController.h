//
// Created by Dawei on 1/31/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"
#import "ImagePlayerView.h"
#import "GoodsCommentImageDelegate.h"
#import "GoodsSpecViewController.h"

@class Goods;
@protocol GoodsIntroDelegate;
@class Store;


@interface GoodsIntroViewController : BaseViewController <ImagePlayerViewDelegate, UITableViewDelegate, UITableViewDataSource, GoodsCommentImageDelegate, GoodsSpecDelegate>

- (instancetype)initWithGoods:(Goods *)goods delegate:(id <GoodsIntroDelegate>)_delegate;

- (void)setGoods:(Goods *)goods;

@property (nonatomic,copy) void(^backOprationView)(NSInteger is_seckill, NSString *status);

@end


#pragma mark dataSource

@protocol GoodsIntroDelegate <NSObject>

/**
 * 显示详情
 */
- (void)showDetail;

/**
 * 显示评论
 */
- (void)showComment;

/**
 * 设置商品
 */
- (void)setGoods:(Goods *)goods;

/**
 * 设置店铺信息
 * @param store
 */
- (void)setStore:(Store *)store;

/**
 * 进入店铺
 */
- (void)gotoStore;

/**
 * 联系客服
 */
- (void)connectService;

@end
