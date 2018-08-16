//
// Created by Dawei on 1/29/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"
#import "GoodsFilterSelectDelegate.h"
#import "SearchDelegate.h"


@interface GoodsListViewController : BaseViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, GoodsFilterSelectDelegate, SearchDelegate>

@property (assign, nonatomic) NSInteger categoryId;

@property (strong, nonatomic) NSString *categoryName;

@property (strong, nonatomic) NSString *keyword;

@property (assign, nonatomic) NSInteger brandId;

@end