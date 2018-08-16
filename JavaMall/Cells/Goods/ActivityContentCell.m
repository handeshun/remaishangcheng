//
// Created by Dawei on 10/29/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "ActivityContentCell.h"
#import "ESLabel.h"


@implementation ActivityContentCell {
    UIImageView *iconIv;
    ESLabel *titleLbl;
    ESLabel *contentLbl;

    UIView *footerLine;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        iconIv = [UIImageView new];
        [self addSubview:iconIv];

        titleLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor blackColor] fontSize:12];
        [self addSubview:titleLbl];

        contentLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor darkGrayColor] fontSize:12];
        contentLbl.numberOfLines = 2;
        [self addSubview:contentLbl];

        footerLine = [UIView new];
        footerLine.backgroundColor = [UIColor colorWithHexString:kBorderLineColor];
        [self addSubview:footerLine];

        [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self).offset(10);
            make.width.height.equalTo(@(12));
        }];

        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconIv.mas_right).offset(10);
            make.top.equalTo(self).offset(10);
            make.right.equalTo(self).offset(-10);
        }];

        [contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconIv);
            make.right.equalTo(self).offset(-10);
            make.top.equalTo(titleLbl.mas_bottom).offset(7);
//            make.height.equalTo(@35);
        }];

        [footerLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.equalTo(@0.5f);
        }];
    }
    return self;
}

- (void)configData:(NSString *)title content:(NSString *)content icon:(UIImage *)icon {
    [iconIv setImage:icon];
    titleLbl.text = title;
    contentLbl.text = content;
}

@end