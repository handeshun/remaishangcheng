//
// Created by Dawei on 7/3/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "ReturnedOrderReasonCell.h"
#import "Masonry.h"
#import "ESLabel.h"

@implementation ReturnedOrderReasonCell {
    UIView *headerLine;
    UIView *footerLine;

    ESLabel *titleLbl;
    ESLabel *textLbl;
    UIImageView *arrowIv;
}

@synthesize reason;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    reason = @"";

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

        titleLbl = [[ESLabel alloc] initWithText:@"退款原因" textColor:[UIColor darkGrayColor] fontSize:14];
        [self addSubview:titleLbl];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.centerY.equalTo(self);
        }];

        arrowIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right_arrow.png"]];
        [self addSubview:arrowIv];
        [arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-10);
            make.centerY.equalTo(self);
            make.width.equalTo(@9);
            make.height.equalTo(@15);
        }];

        textLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor darkGrayColor] fontSize:14];
        textLbl.textAlignment = NSTextAlignmentRight;
        [self addSubview:textLbl];
        [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(titleLbl.mas_right).offset(10);
            make.right.equalTo(arrowIv.mas_left).offset(-10);
        }];

    }
    return self;
}

- (void)setTitle:(NSString *)title {
    titleLbl.text = title;
}

- (void)setValue:(NSString *)value {
    textLbl.text = value;
}

@end