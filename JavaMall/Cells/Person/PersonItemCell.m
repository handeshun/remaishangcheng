//
// Created by Dawei on 6/28/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "PersonItemCell.h"
#import "ESLabel.h"
#import "Masonry.h"


@implementation PersonItemCell {
    UIImageView *iconIV;
    ESLabel *titleLbl;
    ESLabel *remarkLbl;
    UIImageView *arrowIV;

    UIView *headerView;
    UIView *footerView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
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

        iconIV = [[UIImageView alloc] init];
        [self addSubview:iconIV];
        [iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.width.height.equalTo(@18);
            make.left.equalTo(self).offset(10);
        }];

        titleLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor darkGrayColor] fontSize:14];
        [self addSubview:titleLbl];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(iconIV.mas_right).offset(10);
        }];

        remarkLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor grayColor] fontSize:12];
        remarkLbl.textAlignment = NSTextAlignmentRight;
        [self addSubview:remarkLbl];
        [remarkLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(arrowIV.mas_left).offset(-10);
            make.centerY.equalTo(self);
            make.left.equalTo(titleLbl.mas_right).offset(10);
        }];
    }
    return self;
}

- (void)configData:(NSString *)title icon:(UIImage *)icon remark:(NSString *)remark headLine:(BOOL)showHeaderLine footerLine:(BOOL)showFooterLine {
    [headerView setHidden:!(showHeaderLine)];
    [footerView setHidden:!(showFooterLine)];
    [iconIV setImage:icon];
    titleLbl.text = title;
    remarkLbl.text = remark;
}


@end