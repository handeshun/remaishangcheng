//
//  PintuanlistTableViewCell.h
//  JavaMall
//
//  Created by Cheerue on 2017/11/27.
//  Copyright © 2017年 Enation. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Goods;
@interface PintuanlistTableViewCell : UITableViewCell
@property(nonatomic,assign) NSInteger setRemindStatus;// 0 成功

@property (nonatomic,copy) void(^refreshTableVlewFromLBHomeSecKillCell)();

- (void)configData:(Goods *)model;
@end
