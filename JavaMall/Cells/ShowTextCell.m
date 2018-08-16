//
// Created by Dawei on 7/12/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "ShowTextCell.h"
#import "ESLabel.h"
#import "ESTextView.h"
#import "NSString+Common.h"
#import "MMPlaceHolder.h"


@implementation ShowTextCell {
    UIView *headerLine;
    UIView *footerLine;
}

@synthesize titleLbl, textView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        headerLine = [UIView new];
        headerLine.backgroundColor = [UIColor colorWithHexString:@"#e4e5e7"];
        [self addSubview:headerLine];

        footerLine = [UIView new];
        footerLine.backgroundColor = [UIColor colorWithHexString:@"#e4e5e7"];
        [self addSubview:footerLine];

        [headerLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.equalTo(@0.5f);
        }];

        [footerLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self);
            make.height.equalTo(headerLine);
        }];

        titleLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor grayColor] fontSize:14];
        [self addSubview:titleLbl];

        textView = [ESTextView new];
        [textView setFont:[UIFont systemFontOfSize:14]];
        textView.editable = NO;
//        textView.contentInset = UIEdgeInsetsMake(-7.0,0.0,0,0.0);
//        [textView setContentOffset:CGPointMake(0, -7) animated:NO];
        [self addSubview:textView];

        [self reLayout];
    }
    return self;
}

-(void)reLayout{
    [titleLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(10);
    }];
    [textView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLbl.mas_right).offset(10);
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(self).offset(5);
        make.bottom.equalTo(self).offset(-5);
    }];
}

- (void)setTitle:(NSString *)title {
    titleLbl.text = title;
    [self reLayout];
}

- (void)setText:(NSString *)text {
    if([text isKindOfClass:[NSString class]] && text.length > 0) {
        [textView setText:text];
    }else{
        [textView setText:@""];
    }
    [self reLayout];
}

- (void)showLine:(BOOL)_headerLine footerLine:(BOOL)_footerLine {
    [headerLine setHidden:!_headerLine];
    [footerLine setHidden:_footerLine];
}

+ (CGFloat)cellHeightWithTitle:(NSString *)title text:(NSString *)text{
    float titleWidth = [title getSizeWithFont:[UIFont systemFontOfSize:14]].width;
    float textHeight = 0;
    if([text isKindOfClass:[NSString class]] && text.length > 0){
        textHeight = [text getSizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kScreen_Width-30-titleWidth, 500)].height;
    }
    if(textHeight + 20 < 44){
        return 44;
    }
    return textHeight + 20;
}

@end