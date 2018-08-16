//
//  GroupNumTableViewCell.h
//  JavaMall
//
//  Created by Cheerue on 2017/11/25.
//  Copyright © 2017年 Enation. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Goods;

#define kCellIdentifier_GroupSpecCell @"GroupNumCell"
@interface GroupNumTableViewCell : UITableViewCell
- (void) configData:(Goods *)goods;

+ (CGFloat)cellHeightWithObj:(id)obj;
@end
