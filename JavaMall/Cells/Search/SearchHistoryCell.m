//
// Created by Dawei on 7/17/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "SearchHistoryCell.h"
#import "ESLabel.h"


@implementation SearchHistoryCell {
    ESLabel *keywordLbl;

    UIView *footerLine;

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#f4f4f4"];

        footerLine = [UIView new];
        footerLine.backgroundColor = [UIColor colorWithHexString:@"#d4d4d4"];
        [self addSubview:footerLine];
        [footerLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(self);
            make.left.equalTo(self).offset(10);
            make.height.equalTo(@0.5f);
        }];

        keywordLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor colorWithHexString:@"#5e5e5e"] fontSize:12];
        [self addSubview:keywordLbl];
        [keywordLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.right.equalTo(self).offset(-10);
            make.centerY.equalTo(self);
        }];
    }
    return self;
}

- (void)configData:(NSString *)keyword {
    keywordLbl.text = keyword;
}

@end