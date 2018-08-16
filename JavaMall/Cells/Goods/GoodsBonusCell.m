//
// Created by Dawei on 11/10/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "GoodsBonusCell.h"
#import "ESLabel.h"
#import "Masonry.h"
#import "ESButton.h"
#import "Bonus.h"
#import "UIView+Common.h"

@implementation GoodsBonusCell {
    ESLabel *titleLabel;
    UIView *containerView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        titleLabel = [[ESLabel alloc] initWithText:@"领券" textColor:[UIColor darkGrayColor] fontSize:13];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.centerY.equalTo(self);
            make.width.equalTo(@30);
        }];

        UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right_arrow"]];
        [self addSubview:arrow];
        [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-10);
            make.width.equalTo(@9);
            make.height.equalTo(@15);
        }];

        UIView *line = [UIView new];
        line.backgroundColor = [UIColor colorWithHexString:kBorderLineColor];
        [self addSubview:line];
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

+ (CGFloat)cellHeightWithObj:(NSMutableArray *)bonusList {
    if(bonusList == nil || bonusList.count == 0)
        return 0.01f;
    return 40;
}

- (void)configData:(NSMutableArray *)bonusList {
    for(UIView *view in containerView.subviews){
        [view removeFromSuperview];
    }
    int left = 0;
    for(Bonus *bonus in bonusList){
        NSString *minAmountStr = [NSString stringWithFormat:@"%.1f", bonus.minAmount];
        if(bonus.minAmount > 1){
            minAmountStr = [NSString stringWithFormat:@"%.0f", bonus.minAmount];
        }
        NSString *moneyStr = [NSString stringWithFormat:@"%.1f", bonus.money];
        if(bonus.money > 1){
            moneyStr = [NSString stringWithFormat:@"%.0f", bonus.money];
        }

        ESButton *btn = [[ESButton alloc] initWithTitle:[NSString stringWithFormat:@"满%@减%@", minAmountStr, moneyStr] color:[UIColor whiteColor] fontSize:12];
        [btn borderWidth:1 color:[UIColor whiteColor] cornerRadius:5];
        btn.backgroundColor = [UIColor colorWithHexString:@"#e1321f"];
        btn.userInteractionEnabled = NO;
        [containerView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(containerView).offset(left);
            make.centerY.equalTo(containerView);
            make.height.equalTo(@20);
            make.width.equalTo(@80);
        }];
        left += 90;
        if(left+80 > containerView.frame.size.width){
            break;
        }
    }
}


@end