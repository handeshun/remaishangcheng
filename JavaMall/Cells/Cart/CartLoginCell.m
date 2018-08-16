//
// Created by Dawei on 5/26/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "CartLoginCell.h"
#import "ESButton.h"
#import "ESLabel.h"
#import "Masonry.h"
#import "UIButton+Common.h"
#import "UIView+Common.h"

@implementation CartLoginCell {
    ESLabel *tipsLbl;
}

@synthesize loginBtn;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#fffaf4"];

        loginBtn = [[ESButton alloc] initWithTitle:@"登录" color:[UIColor colorWithHexString:@"#6e6f71"] fontSize:14];
        [loginBtn borderWidth:0.5f color:[UIColor colorWithHexString:@"#a1a09e"] cornerRadius:4];
        [loginBtn setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [loginBtn setBackgroundColor:[UIColor colorWithHexString:@"#eeeeee"] forState:UIControlStateHighlighted];
        [self addSubview:loginBtn];

        tipsLbl = [[ESLabel alloc] initWithText:@"您可以在登录后同步电脑与手机购物车中的商品" textColor:[UIColor blackColor] fontSize:14];
        tipsLbl.numberOfLines = 2;
        [self addSubview:tipsLbl];

        UIView *lineView = [UIView new];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#e7e0d8"];
        [self addSubview:lineView];

        [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.centerY.equalTo(self);
            make.width.equalTo(@60);
            make.height.equalTo(@25);
        }];

        [tipsLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(loginBtn.mas_right).offset(10);
            make.right.equalTo(self).offset(-10);
        }];

        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0.5f);
            make.left.right.equalTo(self);
            make.bottom.equalTo(self).offset(-0.5f);
        }];

    }
    return self;
}

@end