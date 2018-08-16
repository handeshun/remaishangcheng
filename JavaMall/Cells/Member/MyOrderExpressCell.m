//
// Created by Dawei on 9/23/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "MyOrderExpressCell.h"
#import "Express.h"
#import "ESLabel.h"
#import "NSString+Common.h"


@implementation MyOrderExpressCell {
    ESLabel *contentLbl;
    ESLabel *timeLbl;

    UIView *footerLineView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        contentLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor grayColor] fontSize:14];
        contentLbl.numberOfLines = 0;
        [self addSubview:contentLbl];
        [contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self).offset(10);
            make.right.equalTo(self).offset(-10);
        }];

        timeLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor grayColor] fontSize:14];
        [self addSubview:timeLbl];
        [timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentLbl);
            make.top.equalTo(contentLbl.mas_bottom).offset(5);
        }];

        footerLineView = [UIView new];
        footerLineView.backgroundColor = [UIColor colorWithHexString:@"#e4e5e7"];
        [self addSubview:footerLineView];
        [footerLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self);
            make.height.equalTo(@0.5f);
        }];
    }
    return self;
}

+ (CGFloat)cellHeightWithObj:(Express *)express {
    float contentHeight = [express.content getSizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kScreen_Width-20, 100)].height;
    return contentHeight + 40;
}

- (void)configData:(Express *)express row:(NSInteger)row{
    contentLbl.text = express.content;
    timeLbl.text = express.time;

    float contentHeight = [express.content getSizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kScreen_Width-20, 100)].height;
    [contentLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.height.equalTo(@(contentHeight));
    }];

    contentLbl.textColor = (row == 0) ? [UIColor blackColor] : [UIColor grayColor];
    timeLbl.textColor = (row == 0) ? [UIColor blackColor] : [UIColor grayColor];
}

@end