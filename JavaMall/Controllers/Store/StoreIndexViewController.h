//
// Created by Dawei on 11/3/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"

@protocol StoreDelegate;


@interface StoreIndexViewController : BaseViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

/**
 * 店铺id
 */
@property (assign, nonatomic) NSInteger storeid;

@property(strong, nonatomic) id <StoreDelegate> delegate;

@end