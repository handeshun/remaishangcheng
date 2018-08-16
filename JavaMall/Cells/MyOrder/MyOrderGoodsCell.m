//
// Created by Dawei on 7/3/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "MyOrderGoodsCell.h"
#import "Masonry.h"
#import "OrderItem.h"
#import "ESLabel.h"
#import "UIView+Common.h"
#import "UIView+Layout.h"


@implementation MyOrderGoodsCell {
    UIView *footerLine;

    UIImageView *thumbnailIV;
    ESLabel *nameLbl;
    ESLabel *priceLbl;
    ESLabel *specLbl;
    ESLabel *totalLbl;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        footerLine = [UIView new];
        footerLine.backgroundColor = [UIColor colorWithHexString:@"#e4e5e7"];
        [self addSubview:footerLine];
        [footerLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self);
            make.height.equalTo(@0.5f);
        }];

        thumbnailIV = [UIImageView new];
        [thumbnailIV borderWidth:1.0 color:[UIColor colorWithHexString:@"#d7d7d7"] cornerRadius:8];
        [self addSubview:thumbnailIV];

        nameLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor darkGrayColor] fontSize:14];
        nameLbl.numberOfLines = 2;
        [self addSubview:nameLbl];

        priceLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor redColor] fontSize:14];
        priceLbl.textAlignment = NSTextAlignmentRight;
        [self addSubview:priceLbl];

        specLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor grayColor] fontSize:12];
        [self addSubview:specLbl];

        totalLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor grayColor] fontSize:12];
        [self addSubview:totalLbl];

        //开始布局
        [thumbnailIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(10);
            make.left.equalTo(self).offset(10);
            make.width.height.equalTo(@60);
        }];

        [priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(nameLbl);
            make.right.equalTo(self).offset(-10);
            make.width.equalTo(@70);
        }];

        [nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(thumbnailIV.mas_right).offset(10);
            make.right.equalTo(priceLbl.mas_left).offset(-10);
            make.top.equalTo(thumbnailIV);
        }];

        [totalLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nameLbl);
            make.top.equalTo(nameLbl.mas_bottom).offset(10);
            make.width.equalTo(@30);
        }];

        [specLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(totalLbl.mas_right).offset(10);
            make.top.equalTo(totalLbl);
            make.right.equalTo(self).offset(-10);
        }];


    }
    return self;
}

- (void)configData:(OrderItem *)orderItem {
    [thumbnailIV sd_setImageWithURL:[NSURL URLWithString:orderItem.thumbnail]
                   placeholderImage:[UIImage imageNamed:@"image_empty"]];
    nameLbl.text = orderItem.name;
    totalLbl.text = [NSString stringWithFormat:@"x %d", orderItem.number];
    priceLbl.text = [NSString stringWithFormat:@"￥%.2f", orderItem.price];
    if(orderItem.addon != nil && orderItem.addon.count > 0){
        NSString *addon = @"";
        for(NSString *ad in orderItem.addon){
            addon = [addon stringByAppendingFormat:@"%@ ", ad];
        }
        specLbl.text = addon;
    }
}


@end