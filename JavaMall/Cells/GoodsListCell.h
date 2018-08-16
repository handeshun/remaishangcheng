//
// Created by Dawei on 1/28/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Goods;

@interface GoodsListCell : UICollectionViewCell

@property (strong, nonatomic) UILabel *nameLabel;

@property (strong, nonatomic) UILabel *priceLabel;

@property (strong, nonatomic) UILabel *buyCountLabel;

@property (strong, nonatomic) UIImageView *thumbnailImageView;

@property (strong, nonatomic) UIButton *cartBtn;

- (void) config:(Goods *) goods;

@end