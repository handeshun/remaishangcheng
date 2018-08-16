//
// Created by Dawei on 2/2/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "Masonry.h"
#import "GoodsNameCell.h"
#import "Goods.h"
#import "ImagePlayerView.h"
#import "UIView+Common.h"
#import "NSString+Common.h"


@implementation GoodsNameCell {
    UILabel *name;
    UILabel *price;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        name = [UILabel new];
        name.font = [UIFont systemFontOfSize:16];
        name.textColor = [UIColor blackColor];
        name.numberOfLines = 2;


        UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right_arrow"]];

        price = [UILabel new];
        price.font = [UIFont fontWithName:@"Helvetica-Bold" size:22];
        price.textColor = [UIColor redColor];

        UIView *line = [UIView new];
        line.backgroundColor = [UIColor colorWithHexString:kBorderLineColor];

        [self addSubview:name];
        [self addSubview:price];
        [self addSubview:arrow];
        [self addSubview:line];

        [name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.right.equalTo(self).offset(-30);
            make.top.equalTo(self).offset(10);
        }];

        [price mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(name);
            make.top.equalTo(name.mas_bottom).offset(10);
            make.width.equalTo(@200);
        }];

        [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(name).offset(5);
            make.right.equalTo(self).offset(-10);
        }];

        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0.5f);
            make.left.right.bottom.equalTo(self);
        }];
    }
    return self;
}

/**
 * 设置商品数据
 */
- (void) configData:(Goods *)goods{
    name.text = goods.name;
    price.text = [NSString stringWithFormat:@"￥%.2f", goods.price];
}

+ (CGFloat)cellHeightWithObj:(id)obj{
    CGFloat cellHeight = 0;
    if ([obj isKindOfClass:[Goods class]]) {
        Goods *goods = (Goods *)obj;
        cellHeight = [goods.name getSizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(kScreen_Width - 40, 100)].height;
        cellHeight += 55;
    }
    return cellHeight;
}

@end