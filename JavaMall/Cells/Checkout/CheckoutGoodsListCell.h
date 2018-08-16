//
// Created by Dawei on 6/20/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CartGoods;

#define kCellIdentifier_CheckoutGoodsListCell @"CheckoutGoodsListCell"
@interface CheckoutGoodsListCell : UITableViewCell

-(void)configData:(CartGoods *)goods;

@end