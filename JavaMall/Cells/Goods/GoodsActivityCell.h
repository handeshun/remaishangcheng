//
//  GoodsActivityCellTableViewCell.h
//  JavaMall
//
//  Created by Dawei on 10/28/16.
//  Copyright © 2016 Enation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Activity.h"

#define kCellIdentifier_GoodsActivityCell @"GoodsActivityCell"

@interface GoodsActivityCell : UITableViewCell

- (void) configData:(Activity *)activity;

+ (CGFloat)cellHeightWithObj:(Activity *)activity;

@end
