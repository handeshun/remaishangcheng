//
// Created by Dawei on 6/30/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "PostCommentAddImageCell.h"
#import "ESButton.h"
#import "UIView+Common.h"


@implementation PostCommentAddImageCell {
    UIView *footerLineView;
}

@synthesize imageBtn;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        footerLineView = [UIView new];
        footerLineView.backgroundColor = [UIColor colorWithHexString:@"#e4e5e7"];
        [self addSubview:footerLineView];

        [footerLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self);
            make.height.equalTo(@0.5f);
        }];

        imageBtn = [[ESButton alloc] initWithTitle:@"添加晒单照片" color:[UIColor colorWithHexString:@"#d04353"] fontSize:12];
        [imageBtn borderWidth:0.5f color:[UIColor colorWithHexString:@"#d04353"] cornerRadius:4];
        [imageBtn setImage:[UIImage imageNamed:@"add_image_icon.png"] forState:UIControlStateNormal];
        [imageBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        [self addSubview:imageBtn];
        [imageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-10);
            make.centerX.equalTo(self);
            make.width.equalTo(@100);
            make.height.equalTo(@24);
        }];

    }
    return self;
}


@end