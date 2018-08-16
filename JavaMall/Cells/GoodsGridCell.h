//
// Created by Dawei on 1/29/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Goods;


@interface GoodsGridCell : UICollectionViewCell

@property (strong, nonatomic) UILabel *nameLabel;

@property (strong, nonatomic) UILabel *priceLabel;

@property (strong, nonatomic) UIImageView *thumbnailImageView;

- (void) config:(Goods *) goods;

@end