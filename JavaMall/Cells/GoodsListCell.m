//
// Created by Dawei on 1/28/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "GoodsListCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "UIView+Common.h"
#import "UIColor+HexString.h"
#import "Goods.h"


@implementation GoodsListCell {

}

@synthesize nameLabel, priceLabel, buyCountLabel, thumbnailImageView, cartBtn;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#FAFAFA"];

        thumbnailImageView = [UIImageView new];
        thumbnailImageView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:thumbnailImageView];

        nameLabel = [UILabel new];
        [nameLabel setTextColor:[UIColor blackColor]];
        [nameLabel setFont:[UIFont systemFontOfSize:14]];
        [nameLabel setNumberOfLines:2];
        [self.contentView addSubview:nameLabel];

        priceLabel = [UILabel new];
        [priceLabel setTextColor:[UIColor redColor]];
        [priceLabel setFont:[UIFont systemFontOfSize:14]];
        [self.contentView addSubview:priceLabel];

        buyCountLabel = [UILabel new];
        [buyCountLabel setTextColor:[UIColor colorWithHexString:@"#666666"]];
        [buyCountLabel setFont:[UIFont systemFontOfSize:12]];
        [self.contentView addSubview:buyCountLabel];

        cartBtn = [UIButton new];
        [cartBtn setImage:[UIImage imageNamed:@"cell_cart"] forState:UIControlStateNormal];
        [self.contentView addSubview:cartBtn];

        [thumbnailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.top.equalTo(self.contentView).offset(7.5);
            make.size.mas_equalTo(CGSizeMake(85, 85));
        }];

        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(5);
            make.left.equalTo(self.contentView).offset(100);
            make.right.equalTo(self.contentView).offset(-10);
            make.height.equalTo(@40);
        }];

        [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(nameLabel);
            make.top.equalTo(nameLabel.mas_bottom).offset(2);
            make.height.equalTo(@20);
        }];

        [buyCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(nameLabel);
            make.top.equalTo(priceLabel.mas_bottom);
            make.height.equalTo(@20);
        }];

        [cartBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView).offset(-10);
            make.right.equalTo(self.contentView).offset(-10);
        }];

        [self bottomBorder:[UIColor colorWithHexString:@"#cdcdcd"]];
    }
    return self;
}

- (void)config:(Goods *)goods {
    nameLabel.text = goods.name;
    priceLabel.text = [NSString stringWithFormat:@"￥%.2f", goods.price];
    buyCountLabel.text = [NSString stringWithFormat:@"%d人已购买", goods.buyCount];
    [thumbnailImageView sd_setImageWithURL:[NSURL URLWithString:goods.thumbnail]
                  placeholderImage:[UIImage imageNamed:@"image_empty"]];
    cartBtn.tag = goods.id;
}


@end