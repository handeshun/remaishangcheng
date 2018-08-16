//
// Created by Dawei on 11/5/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Bonus;

#define kCellIdentifier_StoreBonusCell @"StoreBonusCell"

@interface StoreBonusCell : UICollectionViewCell

- (void)configData:(Bonus *)bonus;

@end