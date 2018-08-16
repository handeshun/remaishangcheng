//
// Created by Dawei on 5/31/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "CheckoutGoodsCell.h"
#import "Masonry.h"
#import "ESLabel.h"
#import "Cart.h"
#import "CartGoods.h"
#import "UIView+Common.h"
#import "Store.h"


@implementation CheckoutGoodsCell {
    UIView *headerView;
    UIView *footerView;

    UIView *goodsView;
    UIImageView *arrowIV;
    ESLabel *totalLbl;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];

        headerView = [UIView new];
        headerView.backgroundColor = [UIColor colorWithHexString:@"#e4e5e7"];
        [self addSubview:headerView];

        footerView = [UIView new];
        footerView.backgroundColor = [UIColor colorWithHexString:@"#e4e5e7"];
        [self addSubview:footerView];

        [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.equalTo(@0.5f);
        }];

        [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self);
            make.height.equalTo(headerView);
        }];

        arrowIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right_arrow.png"]];
        [self addSubview:arrowIV];
        [arrowIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.width.equalTo(@9);
            make.height.equalTo(@15);
            make.right.equalTo(self).offset(-10);
        }];

        totalLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor darkGrayColor] fontSize:12];
        totalLbl.textAlignment = NSTextAlignmentRight;
        [self addSubview:totalLbl];
        [totalLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(arrowIV.mas_left).offset(-10);
            make.width.equalTo(@45);
        }];

        goodsView = [UIView new];
        [self addSubview:goodsView];
        [goodsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(self).offset(10);
            make.bottom.equalTo(self).offset(-10);
            make.right.equalTo(totalLbl.mas_left).offset(-10);
        }];

    }
    return self;
}

- (void)configData:(Cart *)cart {
    NSInteger count = 0;
    for(Store *store in cart.storeList){
        for(CartGoods *cartGoods in store.goodsList){
            count++;
        }
    }
    totalLbl.text = [NSString stringWithFormat:@"共%d件", count];

    for(UIView *subview in goodsView.subviews){
        [subview removeFromSuperview];
    }
    int showGoodsCount = (kScreen_Width - 110) / 70;
    int startX = 0;
    int i = 0;
    for(Store *store in cart.storeList) {
        for (CartGoods *cartGoods in store.goodsList) {
            if (i >= showGoodsCount)
                break;
            UIImageView *goodsIV = [[UIImageView alloc] initWithFrame:CGRectMake(startX, 10, 60, 60)];
            [goodsIV sd_setImageWithURL:[NSURL URLWithString:cartGoods.thumbnail]
                       placeholderImage:[UIImage imageNamed:@"image_empty"]];
            [goodsIV borderWidth:0.5f color:[UIColor colorWithHexString:@"#d5d2c9"] cornerRadius:5];
            [goodsView addSubview:goodsIV];
            startX += 70;
            i++;
        }
    }
    if(showGoodsCount < cart.count){
        UIImageView *moreIV = [[UIImageView alloc] initWithFrame:CGRectMake(startX+(totalLbl.frame.origin.x-startX-20)/2, 30, 20, 20)];
        [moreIV setImage:[UIImage imageNamed:@"more_icon.png"]];
        [goodsView addSubview:moreIV];
    }

}


@end