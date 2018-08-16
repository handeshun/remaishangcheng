//
// Created by Dawei on 6/30/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "PostCommentContentCell.h"
#import "Masonry.h"
#import "ESTextView.h"
#import "ESLabel.h"

@implementation PostCommentContentCell {
    ESLabel *charCountLbl;
    UIView *footerLineView;
}

@synthesize contentTV;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];

        footerLineView = [UIView new];
        footerLineView.backgroundColor = [UIColor colorWithHexString:@"#e4e5e7"];
        [self addSubview:footerLineView];

        [footerLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self);
            make.height.equalTo(@0.5f);
        }];

        contentTV = [ESTextView new];
        contentTV.placeholder = @"写下购买体会和使用感受来帮助其它小伙伴~";
        contentTV.delegate = self;
        [self addSubview:contentTV];
        [contentTV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.right.equalTo(self).offset(-10);
            make.top.equalTo(self);
            make.bottom.equalTo(self).offset(-20);
        }];

        charCountLbl = [[ESLabel alloc] initWithText:@"500" textColor:[UIColor grayColor] fontSize:10];
        [self addSubview:charCountLbl];
        [charCountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-5);
            make.bottom.equalTo(self).offset(-5);
        }];
    }
    return self;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return textView.text.length + (text.length - range.length) <= 500;
}

- (void)textChanged:(NSNotification *)notification{
    charCountLbl.text = [NSString stringWithFormat:@"%d", (500-contentTV.text.length)];
}

@end