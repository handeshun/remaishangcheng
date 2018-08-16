//
// Created by Dawei on 6/30/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "MyCommentOrderCell.h"
#import "ESLabel.h"
#import "ESButton.h"
#import "Masonry.h"
#import "UIView+Common.h"
#import "Goods.h"


@implementation MyCommentOrderCell {
    UIView *headerLineView;
    UIView *footerLineView;

    UIImageView *thumbnailIV;
    ESLabel *nameLbl;
}

@synthesize commentBtn;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        headerLineView = [UIView new];
        headerLineView.backgroundColor = [UIColor colorWithHexString:@"#e4e5e7"];
        [self addSubview:headerLineView];

        footerLineView = [UIView new];
        footerLineView.backgroundColor = [UIColor colorWithHexString:@"#e4e5e7"];
        [self addSubview:footerLineView];

        [headerLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.equalTo(@0.5f);
        }];

        [footerLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self);
            make.height.equalTo(headerLineView);
        }];

        thumbnailIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image_empty.png"]];
        [self addSubview:thumbnailIV];
        [thumbnailIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(self).offset(10);
            make.width.height.equalTo(@80);
        }];

        nameLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor darkGrayColor] fontSize:14];
        nameLbl.numberOfLines = 2;
        [self addSubview:nameLbl];
        [nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(thumbnailIV.mas_right).offset(10);
            make.right.equalTo(self).offset(-10);
            make.top.equalTo(self).offset(20);
        }];

        commentBtn = [[ESButton alloc] initWithTitle:@"评价晒单" color:[UIColor colorWithHexString:@"#d04353"] fontSize:12];
        [commentBtn borderWidth:0.5f color:[UIColor colorWithHexString:@"#d04353"] cornerRadius:4];
        [commentBtn setImage:[UIImage imageNamed:@"comment_btn_icon.png"] forState:UIControlStateNormal];
        [self addSubview:commentBtn];
        [commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-10);
            make.bottom.equalTo(self).offset(-10);
            make.height.equalTo(@24);
            make.width.equalTo(@70);
        }];

    }
    return self;
}

- (void)configData:(Goods *)goods {
    nameLbl.text = goods.name;
    [thumbnailIV sd_setImageWithURL:[NSURL URLWithString:goods.thumbnail] placeholderImage:[UIImage imageNamed:@"image_empty.png"]];
}

@end