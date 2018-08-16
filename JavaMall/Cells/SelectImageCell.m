//
// Created by Dawei on 5/31/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "SelectImageCell.h"
#import "ESLabel.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "UIView+Common.h"


@implementation SelectImageCell {
    ESLabel *titleLbl;
    UIImageView *imageIV;
    UIImageView *arrowIv;

    UIView *footerLine;
    UIView *headerLine;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        titleLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor colorWithHexString:@"#676767"] fontSize:14];
        [self addSubview:titleLbl];

        imageIV = [UIImageView new];
        [self addSubview:imageIV];

        arrowIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right_arrow.png"]];
        [self addSubview:arrowIv];

        headerLine = [UIView new];
        headerLine.backgroundColor = [UIColor colorWithHexString:@"#e4e5e7"];
        [self addSubview:headerLine];

        footerLine = [UIView new];
        footerLine.backgroundColor = [UIColor colorWithHexString:@"#e4e5e7"];
        [self addSubview:footerLine];

        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.centerY.equalTo(self);
        }];

        [arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-10);
            make.centerY.equalTo(self);
        }];

        [imageIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(arrowIv.mas_left).offset(-10);
            make.top.equalTo(self).offset(10);
            make.width.height.equalTo(@60);
        }];

        [headerLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.equalTo(@0.5f);
        }];

        [footerLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.equalTo(headerLine);
        }];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    titleLbl.text = title;
}

- (void)setImageURL:(NSString *)imageUrl {
    [imageIV sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                          placeholderImage:[UIImage imageNamed:@"image_empty"]];
}

- (void)setImage:(UIImage *)image {
    [imageIV setImage:image];
}

- (void)setImageBorder:(UIColor *)color circle:(BOOL)circle width:(float)width {
    if(circle){
        [imageIV borderWidth:width color:color cornerRadius:30];
    }else{
        [imageIV borderWidth:width color:color cornerRadius:4];
    }
}

- (void)showLine:(BOOL)showHeaderLine footerLine:(BOOL)showFooterLine {
    [headerLine setHidden:!showHeaderLine];
    [footerLine setHidden:!showFooterLine];
}


@end