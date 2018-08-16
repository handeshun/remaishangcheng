//
// Created by Dawei on 2/3/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "GoodsPropCell.h"
#import "Masonry.h"
#import "UIView+Common.h"
#import "NSString+Common.h"
#import "Goods.h"

@implementation GoodsPropCell {
    UILabel *storeLabel;
    UILabel *weightLabel;

    NSInteger height;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *storeTitleLabel = [UILabel new];
        storeTitleLabel.font = [UIFont systemFontOfSize:13];
        storeTitleLabel.textColor = [UIColor darkGrayColor];
        storeTitleLabel.text = @"库存";

        storeLabel = [UILabel new];
        storeLabel.font = [UIFont systemFontOfSize:14];
        storeLabel.textColor = [UIColor blackColor];

        [self addSubview:storeTitleLabel];
        [self addSubview:storeLabel];

        UILabel *weightTitleLabel = [UILabel new];
        weightTitleLabel.font = [UIFont systemFontOfSize:13];
        weightTitleLabel.textColor = [UIColor darkGrayColor];
        weightTitleLabel.text = @"重量";

        weightLabel = [UILabel new];
        weightLabel.font = [UIFont systemFontOfSize:14];
        weightLabel.textColor = [UIColor blackColor];

        UIView *line = [UIView new];
        line.backgroundColor = [UIColor colorWithHexString:kBorderLineColor];

        [self addSubview:weightTitleLabel];
        [self addSubview:weightLabel];
        [self addSubview:line];


        CGFloat titleHeight = [@"" getSizeWithFont:[UIFont systemFontOfSize:13]].height;
        CGFloat valueHeight = [@"" getSizeWithFont:[UIFont systemFontOfSize:14]].height;

        [storeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(self).offset((30 - titleHeight) / 2);
            make.width.equalTo(@30);
        }];
        [storeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset((30 - valueHeight) / 2);
            make.left.equalTo(storeTitleLabel.mas_right).offset(10);
            make.right.equalTo(self).offset(-30);
        }];

        [weightTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(storeTitleLabel);
            make.top.equalTo(storeTitleLabel.mas_bottom).offset((30 - titleHeight) / 2);
            make.width.equalTo(storeTitleLabel);
        }];
        [weightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weightTitleLabel);
            make.left.equalTo(storeLabel);
            make.right.equalTo(storeLabel);
        }];

        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0.5f);
            make.left.right.bottom.equalTo(self);
        }];

    }
    return self;
}

- (void) configData:(Goods *) goods{
    storeLabel.text = [NSString stringWithFormat:@"%d", goods.store];
    weightLabel.text = [NSString stringWithFormat:@"%.2f g", goods.weight];
}

+ (CGFloat)cellHeightWithObj:(id)obj{
    return 60;
}


@end