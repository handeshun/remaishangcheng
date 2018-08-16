//
// Created by Dawei on 7/5/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "MyReturnedOrderListGoodsCell.h"
#import "ESLabel.h"
#import "Masonry.h"
#import "UIView+Common.h"
#import "Favorite.h"
#import "Goods.h"
#import "ReturnedOrderItem.h"


@implementation MyReturnedOrderListGoodsCell {
    UIView *headerLine;

    UIImageView *thumbnailIV;
    ESLabel *nameLbl;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        headerLine = [UIView new];
        headerLine.backgroundColor = [UIColor colorWithHexString:@"#e4e5e7"];
        [self addSubview:headerLine];

        [headerLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.equalTo(@0.5f);
        }];

        thumbnailIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image_empty.png"]];
        [thumbnailIV borderWidth:0.5f color:[UIColor colorWithHexString:@"#EEEEEE"] cornerRadius:4];
        [self addSubview:thumbnailIV];
        [thumbnailIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(self).offset(10);
            make.width.height.equalTo(@80);
        }];

        nameLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor darkGrayColor] fontSize:14];
        nameLbl.numberOfLines = 2;
        [self addSubview:nameLbl];
        [nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(thumbnailIV.mas_right).offset(10);
            make.right.equalTo(self).offset(-10);
            make.top.equalTo(self).offset(20);
        }];

    }
    return self;
}

- (void)configData:(ReturnedOrderItem *)returnedOrderItem {
    [thumbnailIV sd_setImageWithURL:[NSURL URLWithString:returnedOrderItem.thumbnail]
                          placeholderImage:[UIImage imageNamed:@"image_empty"]];
    nameLbl.text = returnedOrderItem.goodsName;
}


@end