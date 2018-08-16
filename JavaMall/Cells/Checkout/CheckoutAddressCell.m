//
// Created by Dawei on 5/31/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "CheckoutAddressCell.h"
#import "Address.h"
#import "ESLabel.h"
#import "ESButton.h"
#import "View+MASAdditions.h"


@implementation CheckoutAddressCell {
    ESLabel *nodataLbl;

    UIView *addressView;
    UIImageView *nameIV;
    UIImageView *mobileIV;
    ESLabel *nameLbl;
    ESLabel *mobileLbl;
    ESLabel *addressLbl;
    UIImageView *arrowIV;
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

        nodataLbl = [[ESLabel alloc] initWithText:@"请新建收货地址以确保商品顺利到达" textColor:[UIColor darkGrayColor] fontSize:14];
        [nodataLbl setHidden:YES];
        [self addSubview:nodataLbl];

        [nodataLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.centerX.equalTo(self);
        }];

        //地址信息
        nameIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"address_name_icon.png"]];
        [addressView addSubview:nameIV];

        nameLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor darkGrayColor] fontSize:14];
        [addressView addSubview:nameLbl];

        mobileIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"address_phone_icon.png"]];
        [addressView addSubview:mobileIV];

        mobileLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor darkGrayColor] fontSize:14];
        [addressView addSubview:mobileLbl];

        addressLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor darkGrayColor] fontSize:12];
        addressLbl.numberOfLines = 2;
        [addressView addSubview:addressLbl];

        arrowIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right_arrow.png"]];
        [addressView addSubview:arrowIV];

        [nameIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(addressView).offset(10);
            make.top.equalTo(addressView).offset(20);
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
            make.right.equalTo(addressView).offset(-30);
        }];

        [addressLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(nameIV.mas_bottom).offset(5);
            make.left.equalTo(addressView).offset(10);
            make.right.equalTo(mobileLbl);
            make.height.equalTo(@44);
        }];

        [arrowIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@9);
            make.height.equalTo(@15);
            make.centerY.equalTo(addressView);
            make.right.equalTo(addressView).offset(-10);
        }];
    }
    return self;
}

- (void)configData:(Address *)address {
    if(address){
        [nodataLbl setHidden:YES];
        [addressView setHidden:NO];
        nameLbl.text = address.name;
        mobileLbl.text = address.mobile;
        addressLbl.text = [NSString stringWithFormat:@"%@ %@ %@ %@", address.province, address.city, address.region, address.address];
        return;
    }
    [nodataLbl setHidden:NO];
    [addressView setHidden:YES];
}

@end