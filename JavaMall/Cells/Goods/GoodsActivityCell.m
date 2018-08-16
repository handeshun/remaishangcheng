//
//  GoodsActivityCellTableViewCell.m
//  JavaMall
//
//  Created by Dawei on 10/28/16.
//  Copyright © 2016 Enation. All rights reserved.
//

#import "GoodsActivityCell.h"
#import "Activity.h"
#import "ActivityGift.h"
#import "ESLabel.h"
#import "Masonry.h"
#import "UIView+Common.h"

@implementation GoodsActivityCell{
    ESLabel *titleLabel;
    UIView *containerView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        titleLabel = [[ESLabel alloc] initWithText:@"促销" textColor:[UIColor darkGrayColor] fontSize:13];
        [self addSubview:titleLabel];

        UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right_arrow"]];
        [self addSubview:arrow];
        
        UIView *line = [UIView new];
        line.backgroundColor = [UIColor colorWithHexString:kBorderLineColor];
        [self addSubview:line];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.centerY.equalTo(self);
            make.width.equalTo(@30);
        }];

        [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-10);
            make.width.equalTo(@9);
            make.height.equalTo(@15);
        }];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0.5f);
            make.left.right.bottom.equalTo(self);
        }];

        containerView = [UIView new];
        [self addSubview:containerView];
        [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel.mas_right).offset(10);
            make.right.equalTo(arrow.mas_left).offset(-10);
            make.top.bottom.equalTo(self);
        }];
    }
    return self;
}

- (void)configData:(Activity *)activity{
    for(UIView *view in containerView.subviews){
        [view removeFromSuperview];
    }
    NSMutableArray *contentArray = [NSMutableArray arrayWithCapacity:0];
    if(activity.full_minus){
        [contentArray addObject:@{@"title":@"满减", @"content":[NSString stringWithFormat:@"满%.2f元减%.2f元", activity.full_money, activity.minus_value]}];
    }
    if(activity.send_point){
        [contentArray addObject:@{@"title":@"满送", @"content":[NSString stringWithFormat:@"满%.2f元送%d积分", activity.full_money, activity.point_value]}];
    }
    if(activity.free_ship){
        [contentArray addObject:@{@"title":@"免邮", @"content":[NSString stringWithFormat:@"满%.2f元免邮费", activity.full_money]}];
    }
    if(activity.send_gift && activity.gift != nil){
        [contentArray addObject:@{@"title":@"满送", @"content":[NSString stringWithFormat:@"满%.2f元送%@", activity.full_money, activity.gift.name]}];
    }
    if(activity.send_bonus){
        [contentArray addObject:@{@"title":@"满送", @"content":[NSString stringWithFormat:@"满%.2f元送优惠券", activity.full_money]}];
    }

    int top = 10;
    for(NSDictionary *dic in contentArray){
        ESLabel *signLbl = [[ESLabel alloc] initWithText:[dic objectForKey:@"title"] textColor:[UIColor colorWithHexString:@"#e1321f"] fontSize:12];
        signLbl.textAlignment = NSTextAlignmentCenter;
        [signLbl borderWidth:1 color:[UIColor colorWithHexString:@"#e1321f"] cornerRadius:4];
        [containerView addSubview:signLbl];
        [signLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(containerView);
            make.top.equalTo(containerView).offset(top);
            make.width.equalTo(@30);
            make.height.equalTo(@18);
        }];

        ESLabel *contentLbl = [[ESLabel alloc] initWithText:[dic objectForKey:@"content"] textColor:[UIColor darkGrayColor] fontSize:12];
        [containerView addSubview:contentLbl];
        [contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(signLbl.mas_right).offset(5);
            make.top.equalTo(signLbl);
            make.right.equalTo(containerView);
        }];

        top += 25;
    }

}

+ (CGFloat)cellHeightWithObj:(Activity *)activity{
    if(activity == nil){
        return 0.01f;
    }
    float height = 15;
    if(activity.full_minus){
        height += 25;
    }
    if(activity.send_point){
        height += 25;
    }
    if(activity.free_ship){
        height += 25;
    }
    if(activity.send_gift && activity.gift != nil){
        height += 25;
    }
    if(activity.send_bonus){
        height += 25;
    }
    return height;
}

@end
