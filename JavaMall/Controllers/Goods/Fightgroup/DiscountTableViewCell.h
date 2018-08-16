//
//  DiscountTableViewCell.h
//  JavaMall
//
//  Created by Cheerue on 2017/11/26.
//  Copyright © 2017年 Enation. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Goods;

#define kCellIdentifier_DiscountCell @"DiscountCell"
@interface DiscountTableViewCell : UITableViewCell
- (void) configData:(Goods *) goods;

+ (CGFloat)cellHeightWithObj:(id)obj;
@end
