//
// Created by Dawei on 7/17/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "SearchClearCell.h"
#import "ESLabel.h"
#import "ESButton.h"
#import "UIView+Common.h"


@implementation SearchClearCell {
}

@synthesize clearBtn;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#f4f4f4"];

        clearBtn = [[ESButton alloc] initWithTitle:@"清空历史搜索" color:[UIColor darkGrayColor] fontSize:12];
        [clearBtn borderWidth:0.5f color:[UIColor colorWithHexString:@"#646464"] cornerRadius:4];
        [self addSubview:clearBtn];
        [clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.right.equalTo(self).offset(-20);
            make.height.equalTo(@40);
            make.centerY.equalTo(self);
        }];
    }
    return self;
}

@end