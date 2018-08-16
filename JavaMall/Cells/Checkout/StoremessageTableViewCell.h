//
//  StoremessageTableViewCell.h
//  JavaMall
//
//  Created by Cheerue on 2018/4/13.
//  Copyright © 2018年 Enation. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ESLabel;

#define kkCellIdentifier_CheckoutSelectCell @"storeSelectCell"
@interface StoremessageTableViewCell : UITableViewCell
@property(strong, nonatomic) ESLabel *titleLbl;

@property(strong, nonatomic) NSMutableArray *buttons;

@property (nonatomic ,strong) UILabel *storeAdressLab;

- (void)setTitle:(NSString *)title;
- (void)setAddress:(NSString *)address;

- (void)configData:(NSMutableArray *)nameArray typeArr:(NSMutableArray *)typeArray;

- (void)showLine:(BOOL)header footer:(BOOL)footer;

+ (CGFloat)cellHeightWithObj:(NSMutableArray *)nameArray address:(NSString *)addresss;
@end
