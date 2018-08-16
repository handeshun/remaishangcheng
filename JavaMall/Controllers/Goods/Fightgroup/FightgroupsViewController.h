//
//  FightgroupsViewController.h
//  JavaMall
//
//  Created by Cheerue on 2017/11/25.
//  Copyright © 2017年 Enation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ImagePlayerView.h"
#import "GoodsCommentImageDelegate.h"
#import "GoodsSpecViewController.h"

@class Goods;
@protocol GoodsIntroDelegate;
@class Store;
@interface FightgroupsViewController : UIViewController<ImagePlayerViewDelegate, UITableViewDelegate, UITableViewDataSource, GoodsCommentImageDelegate, GoodsSpecDelegate>

- (instancetype)initWithGoods:(Goods *)goods delegate:(id <GoodsIntroDelegate>)_delegate;

- (void)setGoods:(Goods *)goods;

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
