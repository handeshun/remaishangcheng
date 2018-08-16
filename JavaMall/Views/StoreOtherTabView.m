//
// Created by Dawei on 11/3/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "StoreOtherTabView.h"
#import "NSString+Common.h"


@implementation StoreOtherTabView {
    UILabel *countLbl;
    UILabel *titleLbl;

    NSString *title;
}
- (instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title1{
    self = [super initWithFrame:frame];
    if (self) {
        [self setFrame:frame];
        title = title1;
        [self createUI];
    }
    return self;
}
/**
 * 创建界面
 */
- (void)createUI {
    countLbl = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width-10)/2, 10, self.frame.size.width, 20)];
    countLbl.text = @"0";
    countLbl.textColor = [UIColor darkGrayColor];
    countLbl.font = [UIFont systemFontOfSize:12];
    [self addSubview:countLbl];

    float titleWidth = [title getSizeWithFont:[UIFont systemFontOfSize:12]].width;
    titleLbl = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width- titleWidth)/2, 30, self.frame.size.width, 20)];
    titleLbl.text = title;
    titleLbl.textColor = [UIColor darkGrayColor];
    titleLbl.font = [UIFont systemFontOfSize:12];
    [self addSubview:titleLbl];
}

- (void)setSelected:(BOOL)selected {
    if(selected){
        titleLbl.textColor = [UIColor colorWithHexString:@"#f23839"];
        countLbl.textColor = [UIColor colorWithHexString:@"#f23839"];
    }else{
        countLbl.textColor = [UIColor darkGrayColor];
        titleLbl.textColor = [UIColor darkGrayColor];
    }
}


- (void)setCount:(NSString *)count {
    countLbl.text = count;
    float width = [count getSizeWithFont:[UIFont systemFontOfSize:12]].width;
    countLbl.frame = CGRectMake((self.frame.size.width- width)/2, 10, self.frame.size.width, 20);
}


@end