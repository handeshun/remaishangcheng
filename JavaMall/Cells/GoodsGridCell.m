//
// Created by Dawei on 1/29/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "GoodsGridCell.h"
#import "Goods.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "UIColor+HexString.h"


@implementation GoodsGridCell {

}

@synthesize nameLabel, priceLabel, thumbnailImageView;

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
        nameLabel.numberOfLines = 2;
        [self.contentView addSubview:nameLabel];

        priceLabel = [UILabel new];
        [priceLabel setTextColor:[UIColor redColor]];
        [priceLabel setFont:[UIFont systemFontOfSize:14]];
        [self.contentView addSubview:priceLabel];

        [thumbnailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(5);
            make.centerX.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake((kScreen_Width-30)/2,(kScreen_Width-30)/2));
        }];

        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(2);
            make.right.equalTo(self.contentView).offset(-2);
            make.top.equalTo(thumbnailImageView.mas_bottom).offset(2);
        }];

        [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(nameLabel);
            make.top.equalTo(nameLabel.mas_bottom);
            make.height.equalTo(@18);
        }];
    }

    return self;
}

- (void)config:(Goods *)goods {
    nameLabel.text = goods.name;
    priceLabel.text = [NSString stringWithFormat:@"￥%.2f", goods.price];
    [thumbnailImageView sd_setImageWithURL:[NSURL URLWithString:goods.thumbnail]
                          placeholderImage:[UIImage imageNamed:@"image_empty"]];
}


@end