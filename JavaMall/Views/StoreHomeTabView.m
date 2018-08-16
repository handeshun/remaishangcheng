//
// Created by Dawei on 11/3/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "StoreHomeTabView.h"
#import "NSString+Common.h"


@implementation StoreHomeTabView {
    UIImageView *imageView;
    UILabel *titleLbl;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setFrame:frame];
        [self createUI];
    }
    return self;
}

/**
 * 创建界面
 */
- (void)createUI {
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width-20)/2, 10, 20, 20)];
    [imageView setImage:[UIImage imageNamed:@"store_red.png"]];
    [self addSubview:imageView];

    NSString *title = @"店铺首页";
    float titleWidth = [title getSizeWithFont:[UIFont systemFontOfSize:12]].width;
    titleLbl = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width- titleWidth)/2, 30, self.frame.size.width, 20)];
    titleLbl.text = title;
    titleLbl.textColor = [UIColor colorWithHexString:@"#f23839"];
    titleLbl.font = [UIFont systemFontOfSize:12];
    [self addSubview:titleLbl];
}

- (void)setSelected:(BOOL)selected {
    if(selected){
        [imageView setImage:[UIImage imageNamed:@"store_red.png"]];
        titleLbl.textColor = [UIColor colorWithHexString:@"#f23839"];
    }else{
        [imageView setImage:[UIImage imageNamed:@"store.png"]];
        titleLbl.textColor = [UIColor darkGrayColor];
    }
}

@end