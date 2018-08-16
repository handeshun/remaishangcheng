//
// Created by Dawei on 6/21/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "CheckoutSelectCell.h"
#import "ESLabel.h"
#import "Masonry.h"
#import "NSString+Common.h"
#import "ESCheckButton.h"


@implementation CheckoutSelectCell {
    UIView *headerView;
    UIView *footerView;
}

@synthesize buttons, titleLbl;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        buttons = [NSMutableArray arrayWithCapacity:0];

        headerView = [UIView new];
        headerView.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
        [self addSubview:headerView];
        [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.equalTo(@0.5f);
        }];

        titleLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor darkGrayColor] fontSize:14];
        [self addSubview:titleLbl];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(self).offset(10);
        }];

        footerView = [UIView new];
        footerView.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
        [self addSubview:footerView];
        [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.bottom.equalTo(self);
            make.height.equalTo(@0.5f);
        }];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    titleLbl.text = title;
}


- (void)configData:(NSMutableArray *)nameArray {
    int topOffset = 10;
    int leftOffset = 20;
    int i = 0;
    [buttons removeAllObjects];
    for (NSString *name in nameArray) {
        ESCheckButton *button = [ESCheckButton new];
        [button setTitle:name];
        button.tag = i;
        NSLog(@"==============================================================%@",name);
        [self addSubview:button];
        [buttons addObject:button];

        float buttonWidth = [name getSizeWithFont:[UIFont systemFontOfSize:13]].width + 30;
        if (i > 0 && leftOffset + buttonWidth + 10 > kScreen_Width - 30) {
            leftOffset = 20;
            topOffset += 35;
        }

        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(leftOffset);
            make.top.equalTo(titleLbl.mas_bottom).offset(topOffset);
            make.height.equalTo(@25);
            make.width.equalTo(@(buttonWidth));
        }];
        leftOffset += buttonWidth + 10;
        i++;
    }
}

- (void)showLine:(BOOL)header footer:(BOOL)footer {
    [headerView setHidden:!header];
    [footerView setHidden:!footer];
}


+ (CGFloat)cellHeightWithObj:(NSMutableArray *)nameArray {
    int topOffset = 0;
    int leftOffset = 20;
    int i = 0;
    for (NSString *name in nameArray) {
        float buttonWidth = [name getSizeWithFont:[UIFont systemFontOfSize:13]].width + 30;
        if (i > 0 && leftOffset + buttonWidth + 10 > kScreen_Width - 30) {
            leftOffset = 20;
            topOffset += 35;
        }
        leftOffset += buttonWidth + 10;
        i++;
    }
    topOffset += 35;
    return topOffset + 40;
}

@end
