//
//  LeftTimeTableViewCell.h
//  JavaMall
//
//  Created by Cheerue on 2017/11/26.
//  Copyright © 2017年 Enation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Activity.h"
@class Goods;
#define kCellIdentifier_LeftTimeCell @"LeftTimeCell"
@interface LeftTimeTableViewCell : UITableViewCell
- (void) configData:(Goods *)goods;

+ (CGFloat)cellHeightWithObj:(Activity *)activity;
@end
