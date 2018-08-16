//
// Created by Dawei on 6/3/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "RedButtonCell.h"
#import "ESRedButton.h"
#import "Masonry.h"


@implementation RedButtonCell {
}

@synthesize button;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        button = [[ESRedButton alloc] initWithTitle:@""];
        button.enabled = NO;
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.right.equalTo(self).offset(-20);
            make.centerX.centerY.equalTo(self);
            make.height.equalTo(@40);
        }];
    }
    return self;
}

@end