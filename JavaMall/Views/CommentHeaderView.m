//
// Created by Dawei on 3/23/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "CommentHeaderView.h"
#import "UIView+Common.h"
#import "Masonry.h"
#import "ESButton.h"

@implementation CommentHeaderView {
    ESButton *allBtn;
    ESButton *goodBtn;
    ESButton *generalBtn;
    ESButton *poorBtn;
    ESButton *imageBtn;

    UIView *spaceAll2Good;
    UIView *spaceGood2General;
    UIView *spaceGeneral2Poor;
    UIView *spacePoor2Image;

    UIColor *normalColor;
    UIColor *selectedColor;
}

@synthesize allNumber, goodNumber, generalNumber, poorNumber, imageNumber;
@synthesize touchAtIndex;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    normalColor = [UIColor blackColor];
    selectedColor = [UIColor redColor];

    if (self) {
        [self setFrame:frame];
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.backgroundColor = [UIColor whiteColor];

    allBtn = [[ESButton alloc] initWithTitle:@"全部\n106" color:normalColor fontSize:12];
    allBtn.titleLabel.numberOfLines = 0;
    allBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [allBtn setTitleColor:selectedColor forState:UIControlStateSelected];
    [allBtn addTarget:self action:@selector(loadComment:) forControlEvents:UIControlEventTouchUpInside];
    allBtn.tag = 1;
    [allBtn setSelected:YES];

    goodBtn = [[ESButton alloc] initWithTitle:@"好评\n0" color:normalColor fontSize:12];
    goodBtn.titleLabel.numberOfLines = 0;
    goodBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [goodBtn setTitleColor:selectedColor forState:UIControlStateSelected];
    [goodBtn addTarget:self action:@selector(loadComment:) forControlEvents:UIControlEventTouchUpInside];
    goodBtn.tag = 2;

    generalBtn = [[ESButton alloc] initWithTitle:@"中评\n0" color:normalColor fontSize:12];
    generalBtn.titleLabel.numberOfLines = 0;
    generalBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [generalBtn setTitleColor:selectedColor forState:UIControlStateSelected];
    [generalBtn addTarget:self action:@selector(loadComment:) forControlEvents:UIControlEventTouchUpInside];
    generalBtn.tag = 3;

    poorBtn = [[ESButton alloc] initWithTitle:@"差评\n0" color:normalColor fontSize:12];
    poorBtn.titleLabel.numberOfLines = 0;
    poorBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [poorBtn setTitleColor:selectedColor forState:UIControlStateSelected];
    [poorBtn addTarget:self action:@selector(loadComment:) forControlEvents:UIControlEventTouchUpInside];
    poorBtn.tag = 4;

    imageBtn = [[ESButton alloc] initWithTitle:@"晒图\n0" color:normalColor fontSize:12];
    imageBtn.titleLabel.numberOfLines = 0;
    imageBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [imageBtn setTitleColor:selectedColor forState:UIControlStateSelected];
    [imageBtn addTarget:self action:@selector(loadComment:) forControlEvents:UIControlEventTouchUpInside];
    imageBtn.tag = 5;

    [self addSubview:allBtn];
    [self addSubview:goodBtn];
    [self addSubview:generalBtn];
    [self addSubview:poorBtn];
    [self addSubview:imageBtn];

    //间距视图
    spaceAll2Good = [UIView new];
    spaceGood2General = [UIView new];
    spaceGeneral2Poor = [UIView new];
    spacePoor2Image = [UIView new];
    [self addSubview:spaceAll2Good];
    [self addSubview:spaceGood2General];
    [self addSubview:spaceGeneral2Poor];
    [self addSubview:spacePoor2Image];

    [allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.top.equalTo(self).offset(0);
        make.right.equalTo(spaceAll2Good.mas_left);
    }];

    [goodBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(allBtn);
        make.left.equalTo(spaceAll2Good.mas_right);
        make.right.equalTo(spaceGood2General.mas_left);
    }];

    [generalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(allBtn);
        make.left.equalTo(spaceGood2General.mas_right);
        make.right.equalTo(spaceGeneral2Poor.mas_left);
    }];

    [poorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(allBtn);
        make.left.equalTo(spaceGeneral2Poor.mas_right);
        make.right.equalTo(spacePoor2Image.mas_left);
    }];

    [imageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-20);
        make.top.equalTo(allBtn);
        make.left.equalTo(spacePoor2Image.mas_right);
    }];

    //布局间距视图
    [spaceAll2Good mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(spacePoor2Image.mas_width);
    }];
    [spaceGood2General mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(spacePoor2Image.mas_width);
    }];
    [spaceGeneral2Poor mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(spacePoor2Image.mas_width);
    }];
    [spacePoor2Image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
    }];
}

- (void)layoutSubviews {
    [self bottomBorder:[UIColor colorWithHexString:kBorderLineColor]];
}

- (void)setAllNumber:(NSInteger)_allNumber {
    allNumber = _allNumber;
    [allBtn setTitle:[NSString stringWithFormat:@"全部\n%d", allNumber] forState:UIControlStateNormal];
}

- (void)setGoodNumber:(NSInteger)_goodNumber {
    goodNumber = _goodNumber;
    [goodBtn setTitle:[NSString stringWithFormat:@"好评\n%d", goodNumber] forState:UIControlStateNormal];
}

- (void)setGeneralNumber:(NSInteger)_generalNumber {
    generalNumber = _generalNumber;
    [generalBtn setTitle:[NSString stringWithFormat:@"中评\n%d", generalNumber] forState:UIControlStateNormal];
}

- (void)setPoorNumber:(NSInteger)_poorNumber {
    poorNumber = _poorNumber;
    [poorBtn setTitle:[NSString stringWithFormat:@"差评\n%d", poorNumber] forState:UIControlStateNormal];
}

- (void)setImageNumber:(NSInteger)_imageNumber {
    imageNumber = _imageNumber;
    [imageBtn setTitle:[NSString stringWithFormat:@"晒图\n%d", imageNumber] forState:UIControlStateNormal];
}

/**
 * 点击按钮,载入不同的评论列表
 */
- (void) loadComment:(UIButton *)sender{
    [allBtn setSelected:NO];
    [goodBtn setSelected:NO];
    [generalBtn setSelected:NO];
    [poorBtn setSelected:NO];
    [imageBtn setSelected:NO];

    [sender setSelected:YES];

    if(self.touchAtIndex != NULL){
        self.touchAtIndex(sender.tag);
    }
}

@end