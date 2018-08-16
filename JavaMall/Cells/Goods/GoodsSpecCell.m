//
// Created by Dawei on 2/3/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "GoodsSpecCell.h"
#import "Masonry.h"
#import "NSString+Common.h"
#import "Goods.h"
#import "UIView+Common.h"

@implementation GoodsSpecCell {
    UILabel *titleLabel;
    UILabel *valueLabel;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        titleLabel = [UILabel new];
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.textColor = [UIColor darkGrayColor];
        titleLabel.text = @"规格";

        valueLabel = [UILabel new];
        valueLabel.font = [UIFont systemFontOfSize:14];
        valueLabel.textColor = [UIColor blackColor];

        UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right_arrow"]];
        self.arrow = arrow;
        UIView *line = [UIView new];
        line.backgroundColor = [UIColor colorWithHexString:kBorderLineColor];

        [self addSubview:titleLabel];
        [self addSubview:valueLabel];
        [self addSubview:arrow];
        [self addSubview:line];

        CGFloat titleHeight = [@"" getSizeWithFont:[UIFont systemFontOfSize:13]].height;

        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.centerY.equalTo(self);
            make.width.equalTo(@30);
        }];

        [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(titleLabel.mas_right).offset(10);
            make.right.equalTo(self).offset(-30);
        }];

        [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-10);
        }];

        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0.5f);
            make.left.right.bottom.equalTo(self);
        }];
    }
    return self;
}

- (void)configData:(Goods *)goods{
    if([goods.specs isKindOfClass:[NSString class]] && goods.specs.length > 0) {
        valueLabel.text = [NSString stringWithFormat:@"%@ %d件", goods.specs, goods.buyCount];
    }else{
        valueLabel.text = [NSString stringWithFormat:@"%d 件", goods.buyCount];
    }
}

+ (CGFloat)cellHeightWithObj:(Goods *)goods{
    return goods.is_seckill == 1 ? 0 : 40;
}

@end
