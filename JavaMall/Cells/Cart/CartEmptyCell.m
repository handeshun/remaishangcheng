//
// Created by Dawei on 5/26/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "CartEmptyCell.h"
#import "ESLabel.h"
#import "ESButton.h"
#import "UIView+Common.h"
#import "UIButton+Common.h"
#import "Masonry.h"


@implementation CartEmptyCell {
    ESLabel *emptyLbl;
    UIImageView *emptyImg;
}

@synthesize indexBtn;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        emptyImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cart_empty"]];
        emptyLbl = [[ESLabel alloc] initWithText:@"购物车是空的,您可以" textColor:[UIColor colorWithHexString:@"#bebebe"] fontSize:12];

        indexBtn = [[ESButton alloc] initWithTitle:@"逛逛首页" color:[UIColor colorWithHexString:@"#6e6f71"] fontSize:12];
        [indexBtn borderWidth:0.5f color:[UIColor colorWithHexString:@"#a1a09e"] cornerRadius:4];
        [indexBtn setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [indexBtn setBackgroundColor:[UIColor colorWithHexString:@"#eeeeee"] forState:UIControlStateHighlighted];

        [self addSubview:emptyImg];
        [self addSubview:emptyLbl];
        [self addSubview:indexBtn];

        [emptyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self).offset(-40);
            make.centerY.equalTo(self);
        }];

        [emptyImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(emptyLbl.mas_left).offset(-10);
            make.centerY.equalTo(self);
            make.width.equalTo(@46);
            make.height.equalTo(@38);
        }];

        [indexBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(emptyLbl.mas_right).offset(10);
            make.centerY.equalTo(self);
            make.height.equalTo(@20);
            make.width.equalTo(@75);
        }];
    }
    return self;
}

@end