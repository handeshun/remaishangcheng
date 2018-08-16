//
// Created by Dawei on 7/3/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "MyOrderGiftCell.h"
#import "Masonry.h"
#import "OrderItem.h"
#import "ESLabel.h"
#import "UIView+Common.h"
#import "UIView+Layout.h"
#import "ActivityGift.h"


@implementation MyOrderGiftCell {
    UIView *footerLine;

    UIImageView *thumbnailIV;
    ESLabel *nameLbl;
    ESLabel *priceLbl;
    ESLabel *totalLbl;

    ESLabel *giftLbl;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#fbfbfb"];

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

        giftLbl = [[ESLabel alloc] initWithText:@"赠品" textColor:[UIColor whiteColor] fontSize:12];
        giftLbl.textAlignment = NSTextAlignmentCenter;
        giftLbl.backgroundColor = [UIColor colorWithHexString:@"#e1321f"];
        [self addSubview:giftLbl];

        priceLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor redColor] fontSize:14];
        priceLbl.textAlignment = NSTextAlignmentRight;
        [self addSubview:priceLbl];

        totalLbl = [[ESLabel alloc] initWithText:@"x 1" textColor:[UIColor grayColor] fontSize:12];
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

        [giftLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(thumbnailIV);
            make.width.equalTo(@30);
            make.height.equalTo(@18);
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


    }
    return self;
}

- (void)configData:(ActivityGift *)gift {
    [thumbnailIV sd_setImageWithURL:[NSURL URLWithString:gift.img]
                   placeholderImage:[UIImage imageNamed:@"image_empty"]];
    nameLbl.text = gift.name;

    //中划线
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%.2f", gift.price] attributes:attribtDic];
    priceLbl.attributedText = attribtStr;
}


@end