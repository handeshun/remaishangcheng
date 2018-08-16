//
// Created by Dawei on 11/7/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "MyBonusCell.h"
#import "View+MASAdditions.h"
#import "ESLabel.h"
#import "ESButton.h"
#import "UIView+Common.h"
#import "UIImage+Common.h"
#import "Bonus.h"
#import "DateUtils.h"


@implementation MyBonusCell {
    UIView *view;
    UIImageView *bgIv;

    ESLabel *rmbLbl;
    ESLabel *moneyLbl;
    ESLabel *minAmountLbl;

    ESLabel *storeNameLbl;
    ESLabel *timeLbl;

    UIImageView *signIv;
}

@synthesize useBtn;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor colorWithHexString:@"#f1f2f7"];

        view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.right.equalTo(self).offset(-10);
            make.top.bottom.equalTo(self);
        }];

        UIImage *bgImage = [UIImage imageNamed:@"my_bonus_bg.png"];
        bgIv = [[UIImageView alloc] initWithImage:bgImage];
        [view addSubview:bgIv];
        [bgIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo(view);
            make.width.equalTo(@125);
        }];

        rmbLbl = [[ESLabel alloc] initWithText:@"￥" textColor:[UIColor whiteColor] fontSize:18];
        [bgIv addSubview:rmbLbl];
        [rmbLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgIv).offset(10);
            make.centerY.equalTo(bgIv);
        }];

        moneyLbl = [[ESLabel alloc] initWithText:@"1588" textColor:[UIColor whiteColor] fontSize:32];
        [bgIv addSubview:moneyLbl];
        [moneyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(rmbLbl.mas_right).offset(5);
            make.top.equalTo(rmbLbl).offset(-15);
        }];

        minAmountLbl = [[ESLabel alloc] initWithText:@"满1588元可用" textColor:[UIColor whiteColor] fontSize:14];
        [bgIv addSubview:minAmountLbl];
        [minAmountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(bgIv);
            make.top.equalTo(moneyLbl.mas_bottom).offset(5);
        }];

        signIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"my_bonus_used_sign.png"]];
        [signIv setHidden:YES];
        [view addSubview:signIv];
        [signIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(view);
            make.width.height.equalTo(@75);
        }];

        storeNameLbl = [[ESLabel alloc] initWithText:@"店铺名称店铺名称店铺名称" textColor:[UIColor colorWithHexString:@"#666666"] fontSize:14];
        [view addSubview:storeNameLbl];
        [storeNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgIv.mas_right).offset(10);
            make.top.equalTo(self).offset(10);
        }];

        timeLbl = [[ESLabel alloc] initWithText:@"2016.10.02 - 2016.10.05" textColor:[UIColor grayColor] fontSize:12];
        [view addSubview:timeLbl];
        [timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(storeNameLbl);
            make.top.equalTo(storeNameLbl.mas_bottom).offset(20);
        }];

        useBtn = [[ESButton alloc] initWithTitle:@"立即使用" color:[UIColor colorWithHexString:@"#6788bb"] fontSize:12];
        [useBtn borderWidth:1.5f color:[UIColor colorWithHexString:@"#6788bb"] cornerRadius:10];
        [self addSubview:useBtn];
        [useBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(timeLbl).offset(-5);
            make.right.equalTo(view).offset(-10);
            make.width.equalTo(@65);
            make.height.equalTo(@25);
        }];

    }
    return self;
}

-(void)configData:(Bonus *)bonus{
    if(bonus.money > 1){
        moneyLbl.text = [NSString stringWithFormat:@"%.0f", bonus.money];
    }else{
        moneyLbl.text = [NSString stringWithFormat:@"%.1f", bonus.money];
    }
    if(bonus.minAmount > 1){
        minAmountLbl.text = [NSString stringWithFormat:@"满%.0f元可用", bonus.minAmount];
    }else{
        minAmountLbl.text = [NSString stringWithFormat:@"满%.1f元可用", bonus.minAmount];
    }
    storeNameLbl.text = bonus.store_name;
    timeLbl.text = [NSString stringWithFormat:@"%@ - %@", [DateUtils dateToString:bonus.startDate withFormat:@"yyyy.MM.dd"],
                    [DateUtils dateToString:bonus.endDate withFormat:@"yyyy.MM.dd"]];

    if(bonus.used || [bonus.endDate compare:[NSDate date]] == NSOrderedAscending) {
        [signIv setHidden:NO];
        [useBtn setHidden:YES];
        [bgIv setImage:[[UIImage imageNamed:@"my_bonus_bg.png"] imageWithTintColor:[UIColor colorWithHexString:@"#c2c2c2"]]];
    }else{
        [signIv setHidden:YES];
        [useBtn setHidden:NO];
        [bgIv setImage:[UIImage imageNamed:@"my_bonus_bg.png"]];
    }

    if(bonus.used){
        [signIv setImage:[UIImage imageNamed:@"my_bonus_used_sign.png"]];
    }else if([bonus.endDate compare:[NSDate date]] == NSOrderedAscending){
        [signIv setImage:[UIImage imageNamed:@"my_bonus_expired_sign.png"]];
    }

}

@end