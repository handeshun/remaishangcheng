//
// Created by Dawei on 7/3/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "ReturnedOrderRemarkCell.h"
#import "Masonry.h"
#import "ESLabel.h"
#import "ESTextView.h"
#import "UIView+Common.h"

@implementation ReturnedOrderRemarkCell {
    UIView *headerLine;
    UIView *footerLine;

    ESLabel *titleLbl;
}

@synthesize remarkTV;

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

        titleLbl = [[ESLabel alloc] initWithText:@"问题描述" textColor:[UIColor darkGrayColor] fontSize:14];
        [self addSubview:titleLbl];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self).offset(10);
        }];

        remarkTV = [ESTextView new];
        remarkTV.placeholder = @"请您在此详细描述问题";
        [remarkTV borderWidth:0.5f color:[UIColor grayColor] cornerRadius:4];
        [self addSubview:remarkTV];
        [remarkTV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLbl);
            make.top.equalTo(titleLbl.mas_bottom).offset(10);
            make.bottom.equalTo(self).offset(-10);
            make.right.equalTo(self).offset(-10);
        }];

    }
    return self;
}
@end