//
// Created by Dawei on 11/8/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Store;
@class ESButton;

#define kCellIdentifier_StoreCell @"StoreCell"

@interface StoreCell : UITableViewCell <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property(strong, nonatomic) ESButton *toStoreBtn;

- (void)configData:(Store *)store;

@end