//
// Created by Dawei on 10/29/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "ActivityContentDescCell.h"
#import "ESLabel.h"
#import "Masonry.h"


@implementation ActivityContentDescCell {
    UIImageView *iconIv;
    ESLabel *titleLbl;
    UIWebView *contentWv;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        iconIv = [UIImageView new];
        [self addSubview:iconIv];

        titleLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor darkGrayColor] fontSize:12];
        [self addSubview:titleLbl];

        contentWv = [UIWebView new];
        contentWv.scrollView.bounces = NO;
        contentWv.backgroundColor = [UIColor whiteColor];
        [self addSubview:contentWv];

        [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self).offset(10);
            make.width.height.equalTo(@(12));
        }];

        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconIv.mas_right).offset(10);
            make.top.equalTo(self).offset(10);
            make.right.equalTo(self).offset(-10);
        }];

        [contentWv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconIv);
            make.right.equalTo(self).offset(-10);
            make.top.equalTo(titleLbl.mas_bottom).offset(10);
            make.bottom.equalTo(self).offset(2);
        }];
    }
    return self;
}

- (void)configData:(NSString *)title content:(NSString *)content icon:(UIImage *)icon {
    [iconIv setImage:icon];
    titleLbl.text = title;
    [contentWv loadHTMLString:content baseURL:nil];
}

@end