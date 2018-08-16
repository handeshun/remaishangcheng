//
// Created by Dawei on 3/20/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GoodsComment : NSObject

/**
 * 评论ID
 */
@property(assign, nonatomic) NSInteger id;

/**
 * 评论的商品ID
 */
@property(assign, nonatomic) NSInteger goodsId;

/**
 * 会员ID
 */
@property(assign, nonatomic) NSInteger memberId;

/**
 * 会员名称
 */
@property(strong, nonatomic) NSString *memberName;

/**
 * 会员头像
 */
@property(strong, nonatomic) NSString *memberFace;

/**
 * 评分
 */
@property(assign, nonatomic) NSInteger grade;

/**
 * 评论内容
 */
@property(strong, nonatomic) NSString *content;

/**
 * 评论时间
 */
@property(strong, nonatomic) NSDate *date;

/**
 * 评论图片
 */
@property(strong, nonatomic) NSMutableArray *images;

/**
 * 发表评论时用到的图片
 */
@property(strong, nonatomic) NSMutableArray<UIImage *> *imageFiles;

@end