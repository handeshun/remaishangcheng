//
// Created by Dawei on 7/14/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "MyAddressCell.h"
#import "ESRadioButton.h"
#import "ESLabel.h"
#import "Masonry.h"
#import "Address.h"
#import "MMPlaceHolder.h"


@implementation MyAddressCell {

    UIView *headerLine;
    UIView *line;
    UIView *footerLine;

    ESLabel *nameLbl;
    ESLabel *mobileLbl;
    ESLabel *addressLbl;

}

@synthesize defaultBtn, editBtn, deleteBtn;

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
            make.bottom.left.right.equalTo(self);
            make.height.equalTo(headerLine);
        }];

        nameLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor darkGrayColor] fontSize:14];
        [self addSubview:nameLbl];
        [nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(self).offset(10);
            make.height.equalTo(@20);
            make.width.equalTo(@100);
        }];

        mobileLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor darkGrayColor] fontSize:14];
        [self addSubview:mobileLbl];
        [mobileLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nameLbl.mas_right).offset(20);
            make.top.equalTo(nameLbl);
            make.right.equalTo(self).offset(-10);
        }];

        addressLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor colorWithHexString:@"#626262"] fontSize:12];
        addressLbl.numberOfLines = 2;
        [self addSubview:addressLbl];
        [addressLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nameLbl);
            make.top.equalTo(nameLbl.mas_bottom).offset(5);
            make.right.equalTo(self).offset(-10);
            make.height.equalTo(@40);
        }];

        line = [UIView new];
        line.backgroundColor = [UIColor colorWithHexString:@"#e4e5e7"];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(addressLbl.mas_bottom);
            make.right.equalTo(self);
            make.height.equalTo(headerLine);
        }];

        defaultBtn = [ESRadioButton new];
        [defaultBtn setTitle:@"设为默认"];
        [defaultBtn setFontSize:12];
        [self addSubview:defaultBtn];
        [defaultBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.bottom.equalTo(self).offset(-10);
            make.width.equalTo(@80);
        }];

        deleteBtn = [[ESButton alloc] initWithTitle:@"删除" color:[UIColor darkGrayColor] fontSize:12];
        [deleteBtn setImage:[UIImage imageNamed:@"address_delete.png"] forState:UIControlStateNormal];
        deleteBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        [self addSubview:deleteBtn];
        [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-10);
            make.bottom.equalTo(defaultBtn);
            make.width.equalTo(@50);
        }];

        editBtn = [[ESButton alloc] initWithTitle:@"编辑" color:[UIColor darkGrayColor] fontSize:12];
        [editBtn setImage:[UIImage imageNamed:@"address_edit.png"] forState:UIControlStateNormal];
        editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        [self addSubview:editBtn];
        [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(defaultBtn);
            make.right.equalTo(deleteBtn.mas_left).offset(-10);
            make.width.equalTo(deleteBtn);
        }];


    }
    return self;
}

- (void)configData:(Address *)address{
    nameLbl.text = address.name;
    mobileLbl.text = address.mobile;
    addressLbl.text = [NSString stringWithFormat:@"%@ %@ %@ %@", address.province, address.city, address.region, address.address];
    [defaultBtn setSelected:address.isDefault];
    if(address.isDefault){
        [defaultBtn setTitle:@"默认地址"];
    }else{
        [defaultBtn setTitle:@"设为默认"];
    }
}

@end