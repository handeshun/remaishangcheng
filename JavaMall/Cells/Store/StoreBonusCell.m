//
// Created by Dawei on 11/5/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "StoreBonusCell.h"
#import "ESLabel.h"
#import "View+MASAdditions.h"
#import "Bonus.h"


@implementation StoreBonusCell {
    UIImageView *backImageView;

    ESLabel *titleLbl;
    ESLabel *nameLbl;
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"store_bonus_bg.png"]];
        [self addSubview:backImageView];
        [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.width.equalTo(@100);
            make.height.equalTo(@45);
        }];

        titleLbl = [[ESLabel alloc] initWithText:@"优惠券" textColor:[UIColor colorWithHexString:@"#46b0da"] fontSize:12];
        [self addSubview:titleLbl];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).offset(8);
        }];

        nameLbl = [[ESLabel alloc] initWithText:@"￥1056减800" textColor:[UIColor colorWithHexString:@"#46b0da"] fontSize:14];
        [self addSubview:nameLbl];
        [nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(titleLbl.mas_bottom).offset(2);
        }];
    }
    return self;
}

- (void)configData:(Bonus *)bonus {
    NSString *str = @"￥";
    if(bonus.minAmount > 0){
        str = [str stringByAppendingFormat:@"%.0f", bonus.minAmount];
    }else{
        str = [str stringByAppendingFormat:@"%.1f", bonus.minAmount];
    }
    str = [str stringByAppendingString:@"减"];
    if(bonus.money > 0){
        str = [str stringByAppendingFormat:@"%.0f", bonus.money];
    }else{
        str = [str stringByAppendingFormat:@"%.1f", bonus.money];
    }
    nameLbl.text = str;
}



@end