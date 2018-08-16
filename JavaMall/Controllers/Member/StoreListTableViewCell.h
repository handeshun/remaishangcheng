//
//  StoreListTableViewCell.h
//  JavaMall
//
//  Created by Cheerue on 2018/4/13.
//  Copyright © 2018年 Enation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreListModel.h"

@class Address;

#define kCellIdentifier_StoreListTableViewCell @"StoreListTableViewCell"

@interface StoreListTableViewCell : UITableViewCell
@property (nonatomic,strong)UILabel *titleName;
@property (nonatomic,strong)UILabel *adreessLab;
@property (nonatomic,strong)UILabel *juliLab;
@property (nonatomic,strong)UIImageView *titleImg;
- (void)configData:(Address *)address;
@end
