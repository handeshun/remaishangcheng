//
// Created by Dawei on 6/20/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "CheckoutGoodsListCell.h"
#import "ESLabel.h"
#import "UIView+Common.h"
#import "Masonry.h"
#import "CartGoods.h"


@implementation CheckoutGoodsListCell {
    UIView *footerView;

    UIImageView *thumbnailIV;
    ESLabel *nameLbl;
    ESLabel *priceLbl;
    ESLabel *specLbl;
    ESLabel *totalLbl;

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        thumbnailIV = [UIImageView new];
        [thumbnailIV borderWidth:1.0 color:[UIColor colorWithHexString:@"#d7d7d7"] cornerRadius:8];
        [self addSubview:thumbnailIV];

        nameLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor darkGrayColor] fontSize:16];
        nameLbl.numberOfLines = 2;
        [self addSubview:nameLbl];

        priceLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor redColor] fontSize:14];
        [self addSubview:priceLbl];

        specLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor grayColor] fontSize:12];
        [self addSubview:specLbl];

        totalLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor grayColor] fontSize:12];
        [self addSubview:totalLbl];

        footerView = [UIView new];
        footerView.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
        [self addSubview:footerView];

        //开始布局
        [thumbnailIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(10);
            make.left.equalTo(self).offset(10);
            make.width.height.equalTo(@80);
        }];

        [nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(thumbnailIV.mas_right).offset(10);
            make.right.equalTo(self).offset(-10);
            make.top.equalTo(thumbnailIV);
        }];

        [specLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(nameLbl);
            make.top.equalTo(nameLbl.mas_bottom).offset(10);
        }];

        [priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(nameLbl);
            make.bottom.equalTo(thumbnailIV).offset(-5);
        }];

        [totalLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-10);
            make.centerY.equalTo(self);
        }];

        [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(0.5f);
            make.height.equalTo(@0.5f);
            make.left.right.equalTo(self);
        }];

    }
    return self;
}

- (void)configData:(CartGoods *)goods {
    totalLbl.text = [NSString stringWithFormat:@"x%d", goods.buyCount];
    nameLbl.text = goods.name;
    priceLbl.text = [NSString stringWithFormat:@"￥%.2f", goods.price];
    [thumbnailIV sd_setImageWithURL:[NSURL URLWithString:goods.thumbnail]
                          placeholderImage:[UIImage imageNamed:@"image_empty"]];
    if(goods.specs.length > 0){
        [specLbl setHidden:NO];
        specLbl.text = goods.specs;
    }else{
        [specLbl setHidden:YES];
    }
}


@end