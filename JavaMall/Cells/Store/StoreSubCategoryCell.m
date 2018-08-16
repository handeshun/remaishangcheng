//
// Created by Dawei on 11/6/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "StoreSubCategoryCell.h"
#import "ESLabel.h"
#import "Masonry.h"


@implementation StoreSubCategoryCell {
    ESLabel *titleLbl;
    UIImageView *arrowIv;

    UIView *footerView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        titleLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor colorWithHexString:@"#676767"] fontSize:12];
        [self addSubview:titleLbl];

        arrowIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right_arrow.png"]];
        [self addSubview:arrowIv];

        footerView = [UIView new];
        footerView.backgroundColor = [UIColor colorWithHexString:@"#e4e5e7"];
        [self addSubview:footerView];

        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(30);
            make.centerY.equalTo(self);
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

@end