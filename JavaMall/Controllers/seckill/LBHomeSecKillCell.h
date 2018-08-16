//
//  LBHomeSecKillCell.h
//  yingXiongReNv
//
//  Created by 斌  李 on 2016/10/19.
//  Copyright © 2016年 李斌. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Goods;

@interface LBHomeSecKillCell : UITableViewCell

@property(nonatomic,assign) NSInteger setRemindStatus;// 0 成功

@property (nonatomic,copy) void(^refreshTableVlewFromLBHomeSecKillCell)();

- (void)configData:(Goods *)model;

@end


