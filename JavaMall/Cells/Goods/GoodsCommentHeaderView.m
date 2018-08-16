//
// Created by Dawei on 2/3/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "GoodsCommentHeaderView.h"
#import "Masonry.h"
#import "UIView+Common.h"
#import "UIColor+HexString.h"
#import "Goods.h"


@implementation GoodsCommentHeaderView {
    UILabel *commentPercentLabel;
    UILabel *commentCountLabel;
}

- (instancetype)initWithGoods:(Goods *)goods {
    self = [super init];
    if (self) {
        [self setFrame:CGRectMake(0, 0, kScreen_Width, 60)];
        self.backgroundColor = [UIColor whiteColor];

        UILabel *headerTitle = [UILabel new];
        headerTitle.text = @"商品评价";
        headerTitle.font = [UIFont systemFontOfSize:14];
        headerTitle.textColor = [UIColor darkGrayColor];
        [self addSubview:headerTitle];

        UILabel *commentPercentTitle = [UILabel new];
        commentPercentTitle.textColor = [UIColor blackColor];
        commentPercentTitle.font = [UIFont systemFontOfSize:13];
        commentPercentTitle.text = @"好评度";
        [self addSubview:commentPercentTitle];

        commentPercentLabel = [UILabel new];
        commentPercentLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
        commentPercentLabel.textColor = [UIColor redColor];

        [self addSubview:commentPercentLabel];

        commentCountLabel = [UILabel new];
        commentCountLabel.font = [UIFont systemFontOfSize:13];
        commentCountLabel.textColor = [UIColor darkGrayColor];

        [self addSubview:commentCountLabel];

        UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right_arrow"]];
        [self addSubview:arrow];
        [self configData:goods];

        [headerTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(self).offset(8);
        }];

        [commentPercentTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headerTitle.mas_bottom).offset(10);
            make.left.equalTo(headerTitle);
        }];

        [commentPercentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(commentPercentTitle);
            make.left.equalTo(commentPercentTitle.mas_right).offset(5);
        }];

        [commentCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(commentPercentTitle);
            make.left.equalTo(commentPercentLabel.mas_right).offset(10);
        }];

        [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headerTitle).offset(5);
            make.right.equalTo(self).offset(-10);
        }];

        [self bottomBorder:[UIColor colorWithHexString:kBorderLineColor]];
        [self topBorder:[UIColor colorWithHexString:kBorderLineColor]];

    }
    return self;
}

- (void)configData:(Goods *)goods {
    commentPercentLabel.text = goods.goodCommentPercent;
    commentCountLabel.text = [NSString stringWithFormat:@"%d人评价", goods.commentCount];
}
@end
