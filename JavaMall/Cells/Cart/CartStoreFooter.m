//
// Created by Dawei on 11/10/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "CartStoreFooter.h"
#import "Store.h"
#import "Activity.h"
#import "ESLabel.h"
#import "ActivityGift.h"


@implementation CartStoreFooter {

}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder])
        [self setupUI];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame])
        [self setupUI];
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor colorWithHexString:@"#fff9f9"];
}

+ (float)heightWithObject:(Store *)store {
    if(store.activity == nil){
        return 0.01f;
    }
    Activity *activity = store.activity;
    float height = 5;
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

- (void)configData:(Store *)store {
    Activity *activity = store.activity;

    NSMutableArray *contentArray = [NSMutableArray arrayWithCapacity:0];
    if(activity.full_minus){
        [contentArray addObject:@{@"title":@"满减", @"content":[NSString stringWithFormat:@"满%.2f元减%.2f元", activity.full_money, activity.minus_value]}];
    }
    if(activity.send_point){
        [contentArray addObject:@{@"title":@"满送", @"content":[NSString stringWithFormat:@"满%.2f元送%d积分", activity.full_money, activity.point_value]}];
    }
    if(activity.send_gift && activity.gift != nil){
        [contentArray addObject:@{@"title":@"满送", @"content":[NSString stringWithFormat:@"满%.2f元送%@", activity.full_money, activity.gift.name]}];
    }
    if(activity.send_bonus){
        [contentArray addObject:@{@"title":@"满送", @"content":[NSString stringWithFormat:@"满%.2f元送优惠券", activity.full_money]}];
    }
    if(activity.free_ship){
        [contentArray addObject:@{@"title":@"免邮", @"content":[NSString stringWithFormat:@"满%.2f元免邮费", activity.full_money]}];
    }

    int top = 5;
    BOOL giftTitleCreated = NO;
    for(NSDictionary *dic in contentArray){
        if(!giftTitleCreated || ![[dic objectForKey:@"title"] isEqualToString:@"满送"]) {
            ESLabel *titleLbl = [[ESLabel alloc] initWithText:[dic objectForKey:@"title"] textColor:[UIColor colorWithHexString:@"#333333"] fontSize:12];
            [self addSubview:titleLbl];
            [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(40);
                make.top.equalTo(self).offset(top);
                make.width.equalTo(@30);
            }];
            if([[dic objectForKey:@"title"] isEqualToString:@"满送"]){
                giftTitleCreated = YES;
            }
        }

        ESLabel *contentLbl = [[ESLabel alloc] initWithText:[dic objectForKey:@"content"]
                                                  textColor:[UIColor colorWithHexString:@"#666666"] fontSize:12];
        [self addSubview:contentLbl];
        [contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(top);
            make.left.equalTo(self).offset(80);
            make.right.equalTo(self).offset(-10);
        }];

        top += 25;
    }
}

@end