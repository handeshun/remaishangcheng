//
// Created by Dawei on 5/31/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "SelectTextCell.h"
#import "ESLabel.h"
#import "Masonry.h"


@implementation SelectTextCell {
    ESLabel *textLbl;
    ESLabel *titleLbl;
    UIImageView *arrowIv;

    UIView *footerView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        titleLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor colorWithHexString:@"#676767"] fontSize:14];
        [self addSubview:titleLbl];

        textLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor darkGrayColor] fontSize:14];
        [self addSubview:textLbl];

        arrowIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right_arrow.png"]];
        [self addSubview:arrowIv];

        footerView = [UIView new];
        footerView.backgroundColor = [UIColor colorWithHexString:@"#e4e5e7"];
        [self addSubview:footerView];

        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.centerY.equalTo(self);
        }];

        [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.right.height.equalTo(self);
            make.left.equalTo(titleLbl.mas_right).offset(10);
        }];

        [arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-10);
            make.centerY.equalTo(self);
        }];

        [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.equalTo(@0.5f);
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