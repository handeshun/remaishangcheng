//
// Created by Dawei on 5/26/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HotGoodsDelegate;

#define kCellIdentifier_CartMoreGoodsCell @"CartMoreGoodsCell"

@interface CartMoreGoodsCell : UITableViewCell

@property(nonatomic, strong) id <HotGoodsDelegate> delegate;

- (void) configData:(NSMutableArray *)goodsArray;

+ (CGFloat)cellHeightWithObj:(NSMutableArray *)goodsArray;

@end