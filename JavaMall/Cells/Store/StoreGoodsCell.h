//
// Created by Dawei on 11/8/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Goods;

#define kCellIdentifier_StoreGoodsCell @"StoreGoodsCell"
@interface StoreGoodsCell : UICollectionViewCell

@property (strong, nonatomic) UILabel *priceLabel;

@property (strong, nonatomic) UIImageView *thumbnailImageView;

- (void) config:(Goods *) goods;

@end