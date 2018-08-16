//
//  PintuanRuleTableViewCell.h
//  JavaMall
//
//  Created by Cheerue on 2017/11/26.
//  Copyright © 2017年 Enation. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Store;

#define kCellIdentifier_pintuanRuleCell @"pintuanRuleCell"
@interface PintuanRuleTableViewCell : UITableViewCell
+ (CGFloat)cellHeightWithObj:(id)obj;
@end
