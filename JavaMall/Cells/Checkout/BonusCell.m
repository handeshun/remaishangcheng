//
// Created by Dawei on 6/22/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "BonusCell.h"
#import "Masonry.h"
#import "ESLabel.h"
#import "Bonus.h"
#import "DateUtils.h"
#import "ESRadioButton.h"

@implementation BonusCell {
    UIImageView *containerView;

    ESLabel *rmbLbl;
    ESLabel *moneyLbl;

    ESLabel *minAmountLbl;

    ESLabel *dateLbl;

    ESLabel *storeNameLbl;
}

@synthesize radioBtn;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        containerView = [UIImageView new];
        containerView.userInteractionEnabled = YES;
        containerView.image = [UIImage imageNamed:@"bonus_bg.png"];
        [self addSubview:containerView];
        [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self).offset(5);
            make.right.equalTo(self).offset(-10);
            make.height.equalTo(@((kScreen_Width-20) / 300 * 100));
        }];

        radioBtn = [[ESRadioButton alloc] init];
        [containerView addSubview:radioBtn];
        [radioBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(containerView);
            make.left.equalTo(containerView).offset(10);
        }];

        rmbLbl = [[ESLabel alloc] initWithText:@"￥" textColor:[UIColor colorWithHexString:@"#fe6a8a"] fontSize:16];
        [containerView addSubview:rmbLbl];
        [rmbLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(radioBtn.mas_right).offset(10);
            make.top.equalTo(containerView).offset(50);
        }];

        moneyLbl = [[ESLabel alloc] initWithText:@"20" textColor:[UIColor colorWithHexString:@"#fe6a8a"] fontSize:45];
        [containerView addSubview:moneyLbl];
        [moneyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(rmbLbl.mas_right).offset(5);
            make.top.equalTo(containerView).offset(25);
        }];

        minAmountLbl = [[ESLabel alloc] initWithText:@"满1500元可用" textColor:[UIColor darkGrayColor] fontSize:14];
        minAmountLbl.textAlignment = NSTextAlignmentCenter;
        [containerView addSubview:minAmountLbl];
        [minAmountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(rmbLbl.mas_bottom).offset(15);
            make.left.equalTo(rmbLbl);
        }];

        storeNameLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor darkGrayColor] fontSize:14];
        [containerView addSubview:storeNameLbl];
        [storeNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(moneyLbl.mas_right).offset(20);
            make.top.equalTo(moneyLbl).offset(20);
        }];

        dateLbl = [[ESLabel alloc] initWithText:@"2015.25.25 - 2015.25.365" textColor:[UIColor darkGrayColor] fontSize:12];
        [containerView addSubview:dateLbl];
        [dateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(containerView).offset(-10);
            make.bottom.equalTo(containerView).offset(-10);
        }];

    }
    return self;
}

- (void)configData:(Bonus *)bonus {
    moneyLbl.text = [NSString stringWithFormat:@"%.0f", bonus.money];
    minAmountLbl.text = [NSString stringWithFormat:@"满%.0f元可用", bonus.minAmount];
    storeNameLbl.text = bonus.store_name;
    dateLbl.text = [NSString stringWithFormat:@"%@ - %@", [DateUtils dateToString:bonus.startDate withFormat:@"yyyy.MM.dd"], [DateUtils dateToString:bonus.endDate withFormat:@"yyyy.MM.dd"]];
    NSDate *currentDate = [NSDate date];
    if([currentDate compare:bonus.endDate] == NSOrderedDescending || [bonus.startDate compare:currentDate] == NSOrderedDescending){
        containerView.image = [UIImage imageNamed:@"bonus_bg_nostart.png"];
        rmbLbl.textColor = [UIColor colorWithHexString:@"#c2c2c2"];
        moneyLbl.textColor = [UIColor colorWithHexString:@"#c2c2c2"];
        return;
    }
    [radioBtn setSelected:bonus.selected];
}

+ (CGFloat)cellHeightWithObj:(Bonus *)bonus {
    return (kScreen_Width-20) / 300 * 100 + 10;
}

@end
