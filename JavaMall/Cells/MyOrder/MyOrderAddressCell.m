//
// Created by Dawei on 5/31/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "MyOrderAddressCell.h"
#import "Address.h"
#import "ESLabel.h"
#import "ESButton.h"
#import "View+MASAdditions.h"
#import "Order.h"


@implementation MyOrderAddressCell {
    UIView *addressView;
    UIImageView *nameIV;
    UIImageView *mobileIV;
    ESLabel *nameLbl;
    ESLabel *mobileLbl;
    ESLabel *addressLbl;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        UIColor *backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"address_info_bg.png"]];
        [self setBackgroundColor:backgroundColor];

        addressView = [UIView new];
        [self addSubview:addressView];
        [addressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];

        //地址信息
        nameIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"address_name_icon.png"]];
        [self addSubview:nameIV];

        nameLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor darkGrayColor] fontSize:14];
        [self addSubview:nameLbl];

        mobileIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"address_phone_icon.png"]];
        [self addSubview:mobileIV];

        mobileLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor darkGrayColor] fontSize:14];
        [self addSubview:mobileLbl];

        addressLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor darkGrayColor] fontSize:12];
        addressLbl.numberOfLines = 2;
        [self addSubview:addressLbl];


        [nameIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(self).offset(20);
            make.width.height.equalTo(@14);
        }];

        [nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nameIV.mas_right).offset(10);
            make.centerY.equalTo(nameIV);
            make.width.equalTo(@100);
        }];

        [mobileIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nameLbl.mas_right).offset(10);
            make.centerY.equalTo(nameLbl);
            make.size.equalTo(nameIV);
        }];

        [mobileLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(mobileIV.mas_right).offset(10);
            make.centerY.equalTo(mobileIV);
            make.right.equalTo(self).offset(-30);
        }];

        [addressLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(nameIV.mas_bottom).offset(5);
            make.left.equalTo(self).offset(10);
            make.right.equalTo(mobileLbl);
            make.height.equalTo(@44);
        }];

    }
    return self;
}

- (void)configData:(Order *)order {
    nameLbl.text = order.name;
    mobileLbl.text = order.mobile;
    addressLbl.text = [NSString stringWithFormat:@"%@ %@", order.area, order.address];
}

@end