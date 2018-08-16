//
// Created by Dawei on 7/5/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "MyFavoriteCell.h"
#import "ESLabel.h"
#import "Masonry.h"
#import "UIView+Common.h"
#import "Favorite.h"
#import "Goods.h"


@implementation MyFavoriteCell {
    UIView *headerLine;
    UIView *footerLine;

    UIImageView *thumbnailIV;
    ESLabel *nameLbl;
    ESLabel *priceLbl;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        headerLine = [UIView new];
        headerLine.backgroundColor = [UIColor colorWithHexString:@"#e4e5e7"];
        [self addSubview:headerLine];

        footerLine = [UIView new];
        footerLine.backgroundColor = [UIColor colorWithHexString:@"#e4e5e7"];
        [self addSubview:footerLine];

        [headerLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.equalTo(@0.5f);
        }];
        [footerLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.equalTo(self);
            make.left.equalTo(self).offset(10);
            make.height.equalTo(headerLine);
        }];

        thumbnailIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image_empty.png"]];
        [thumbnailIV borderWidth:0.5f color:[UIColor colorWithHexString:@"#EEEEEE"] cornerRadius:4];
        [self addSubview:thumbnailIV];
        [thumbnailIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(self).offset(10);
            make.width.height.equalTo(@80);
        }];

        nameLbl = [[ESLabel alloc] initWithText:@"这里是商品标题啊地冷风机打最成功里郾城； 昔都照顾jfda里啊减肥大赛a" textColor:[UIColor darkGrayColor] fontSize:14];
        nameLbl.numberOfLines = 2;
        [self addSubview:nameLbl];
        [nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(thumbnailIV.mas_right).offset(10);
            make.right.equalTo(self).offset(-10);
            make.top.equalTo(self).offset(20);
        }];

        priceLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor colorWithHexString:@"#f0566e"] fontSize:14];
        [self addSubview:priceLbl];
        [priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(nameLbl.mas_bottom).offset(10);
            make.left.right.equalTo(nameLbl);
        }];

    }
    return self;
}

- (void)configData:(Favorite *)favorite {
    [thumbnailIV sd_setImageWithURL:[NSURL URLWithString:favorite.goods.thumbnail]
                          placeholderImage:[UIImage imageNamed:@"image_empty"]];
    nameLbl.text = favorite.goods.name;
    priceLbl.text = [NSString stringWithFormat:@"￥%.2f", favorite.goods.price];;
}


@end