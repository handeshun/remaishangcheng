//
// Created by Dawei on 6/30/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "ReturnedOrderCell.h"
#import "Masonry.h"
#import "ESLabel.h"
#import "Order.h"
#import "OrderItem.h"
#import "ESButton.h"
#import "UIView+Common.h"

@implementation ReturnedOrderCell {
    UIView *footerLine;

    UIImageView *thumbnailIV;
    ESLabel *nameLbl;
    ESLabel *numberLbl;
    ESLabel *stateLbl;
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
        [thumbnailIV borderWidth:0.5f color:[UIColor grayColor] cornerRadius:4];
        [self addSubview:thumbnailIV];
        [thumbnailIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self).offset(10);
            make.width.height.equalTo(@60);
        }];

        nameLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor darkGrayColor] fontSize:12];
        nameLbl.numberOfLines = 2;
        [self addSubview:nameLbl];
        [nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(thumbnailIV.mas_right).offset(10);
            make.top.equalTo(thumbnailIV).offset(2);
            make.right.equalTo(self).offset(-10);
        }];

        numberLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor grayColor] fontSize:12];
        [self addSubview:numberLbl];
        [numberLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(nameLbl);
            make.top.equalTo(nameLbl.mas_bottom).offset(10);
        }];

        stateLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor colorWithHexString:@"#d04353"] fontSize:14];
        stateLbl.textAlignment = NSTextAlignmentRight;
        [self addSubview:stateLbl];
        [stateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-10);
            make.bottom.equalTo(self).offset(-10);
            make.height.equalTo(@24);
            make.width.equalTo(@150);
        }];
    }
    return self;
}

- (void)configData:(OrderItem *)orderItem order:(Order *)order {
    [thumbnailIV sd_setImageWithURL:[NSURL URLWithString:orderItem.thumbnail] placeholderImage:[UIImage imageNamed:@"image_empty.png"]];
    nameLbl.text = orderItem.name;
    numberLbl.text = [NSString stringWithFormat:@"数量:%d", orderItem.number];
}


@end