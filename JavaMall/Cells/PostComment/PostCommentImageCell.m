//
// Created by Dawei on 6/30/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "PostCommentImageCell.h"


@implementation PostCommentImageCell {
    UIView *headerLine;
    UIView *footerLine;

    UIImageView *photoIV;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        footerLine = [UIView new];
        footerLine.backgroundColor = [UIColor colorWithHexString:@"#e4e5e7"];
        [self addSubview:footerLine];

        [footerLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self);
            make.height.equalTo(@0.5f);
        }];

        photoIV = [UIImageView new];
        photoIV.contentMode = UIViewContentModeScaleAspectFill;
        photoIV.clipsToBounds = YES;
        [self addSubview:photoIV];
        [photoIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self).offset(10);
            make.right.bottom.equalTo(self).offset(-10);
        }];

    }
    return self;
}

- (void)configData:(UIImage *)image {
    [photoIV setImage:image];
}

@end