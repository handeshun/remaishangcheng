//
// Created by Dawei on 6/19/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "SelectAddressCell.h"
#import "ESLabel.h"
#import "ESButton.h"
#import "View+MASAdditions.h"
#import "Address.h"


@implementation SelectAddressCell {

    UIImageView *selectIV;

    ESLabel *nameLbl;
    ESLabel *mobileLbl;
    ESLabel *addressLbl;

    UIView *editLine;
    UIView *footerView;

}

@synthesize editBtn;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        editBtn = [[ESButton alloc] initWithTitle:@"" color:[UIColor whiteColor] fontSize:14];
        [editBtn setImage:[UIImage imageNamed:@"order_address_edit.png"] forState:UIControlStateNormal];
        [self addSubview:editBtn];
        [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-10);
            make.centerY.equalTo(self);
            make.width.height.equalTo(@16);
        }];

        editLine = [UIView new];
        editLine.backgroundColor = [UIColor colorWithHexString:@"#dfdfdf"];
        [self addSubview:editLine];
        [editLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(20);
            make.bottom.equalTo(self).offset(-20);
            make.right.equalTo(editBtn.mas_left).offset(-10);
            make.width.equalTo(@0.5f);
        }];

        selectIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"address_select_icon.png"]];
        [self addSubview:selectIV];
        [selectIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@20);
            make.height.equalTo(@15);
            make.left.equalTo(self).offset(10);
            make.centerY.equalTo(self);
        }];

        nameLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor darkGrayColor] fontSize:14];
        [self addSubview:nameLbl];
        [nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(selectIV.mas_right).offset(10);
            make.top.equalTo(self).offset(10);
            make.width.equalTo(@100);
        }];

        mobileLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor darkGrayColor] fontSize:14];
        [self addSubview:mobileLbl];
        [mobileLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nameLbl.mas_right).offset(20);
            make.top.equalTo(nameLbl);
            make.right.equalTo(editLine).offset(-5);
        }];

        addressLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor colorWithHexString:@"#626262"] fontSize:12];
        addressLbl.numberOfLines = 2;
        [self addSubview:addressLbl];
        [addressLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nameLbl);
            make.top.equalTo(nameLbl.mas_bottom).offset(5);
            make.bottom.equalTo(self);
            make.right.equalTo(editLine.mas_left).offset(-5);
        }];

        footerView = [UIView new];
        footerView.backgroundColor = [UIColor colorWithHexString:@"#dfdfdf"];
        [self addSubview:footerView];
        [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0.5f);
            make.left.right.bottom.equalTo(self);
        }];

    }
    return self;
}

- (void)configData:(Address *)address index:(NSInteger)row{
    nameLbl.text = address.name;
    mobileLbl.text = address.mobile;
    addressLbl.text = [NSString stringWithFormat:@"%@ %@ %@ %@", address.province, address.city, address.region, address.address];
    editBtn.tag = row;
    if(address.isDefault){
        [selectIV setHidden:NO];
        [selectIV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@20);
            make.height.equalTo(@15);
            make.left.equalTo(self).offset(10);
            make.centerY.equalTo(self);
        }];
    }else{
        [selectIV setHidden:YES];
        [selectIV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@20);
            make.height.equalTo(@15);
            make.right.equalTo(self.mas_left);
            make.centerY.equalTo(self);
        }];
    }
    [selectIV setHidden:!address.isDefault];
}

@end