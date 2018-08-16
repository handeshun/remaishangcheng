//
// Created by Dawei on 11/8/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "StoreGoodsCell.h"
#import "Goods.h"
#import "Masonry.h"
#import "UIImageView+EMWebCache.h"


@implementation StoreGoodsCell {

}
@synthesize priceLabel, thumbnailImageView;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#FAFAFA"];

        thumbnailImageView = [UIImageView new];
        thumbnailImageView.backgroundColor = [UIColor whiteColor];
        [self addSubview:thumbnailImageView];

        priceLabel = [UILabel new];
        [priceLabel setTextColor:[UIColor darkGrayColor]];
        [priceLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:priceLabel];

        [thumbnailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(5);
            make.centerX.equalTo(self);
            make.size.mas_equalTo(CGSizeMake((kScreen_Width-30)/3,(kScreen_Width-30)/3));
        }];

        [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(thumbnailImageView.mas_bottom).offset(5);
        }];
    }

    return self;
}

- (void)config:(Goods *)goods {
    priceLabel.text = [NSString stringWithFormat:@"￥%.2f", goods.price];
    [thumbnailImageView sd_setImageWithURL:[NSURL URLWithString:goods.thumbnail]
                          placeholderImage:[UIImage imageNamed:@"image_empty"]];
}

@end