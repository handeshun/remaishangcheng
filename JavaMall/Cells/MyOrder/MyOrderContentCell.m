//
// Created by Dawei on 7/3/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "MyOrderContentCell.h"
#import "Masonry.h"
#import "ESLabel.h"
#import "Order.h"


@implementation MyOrderContentCell {
    UIView *headerLine;
    UIView *footerLine;

    ESLabel *contentLbl;
}

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

        contentLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor darkGrayColor] fontSize:14];
        [self addSubview:contentLbl];
        [contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-10);
        }];
    }
    return self;
}

- (void)configData:(NSString *)content headerLine:(BOOL)showHeaderLine footerLine:(BOOL)showFooterLine {
    contentLbl.text = content;
    [headerLine setHidden:!showHeaderLine];
    [footerLine setHidden:!showFooterLine];
}


@end