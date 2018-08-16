//
// Created by Dawei on 6/30/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "PostCommentGradeCell.h"
#import "ESLabel.h"
#import "Masonry.h"
#import "ESButton.h"
#import "Goods.h"


@implementation PostCommentGradeCell {
    UIView *headerLineView;
    UIView *footerLineView;

    UIImageView *thumbnailIV;
    ESLabel *titleLbl;

    ESButton *gradeBtn1;
    ESButton *gradeBtn2;
    ESButton *gradeBtn3;
    ESButton *gradeBtn4;
    ESButton *gradeBtn5;

    NSMutableArray *gradeBtnArray;
}

@synthesize grade;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        gradeBtnArray = [NSMutableArray arrayWithCapacity:5];
        grade = 3;

        headerLineView = [UIView new];
        headerLineView.backgroundColor = [UIColor colorWithHexString:@"#e4e5e7"];
        [self addSubview:headerLineView];

        footerLineView = [UIView new];
        footerLineView.backgroundColor = [UIColor colorWithHexString:@"#e4e5e7"];
        [self addSubview:footerLineView];

        [headerLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.equalTo(@0.5f);
        }];

        [footerLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self);
            make.height.equalTo(headerLineView);
        }];

        thumbnailIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image_empty.png"]];
        [self addSubview:thumbnailIV];
        [thumbnailIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(self).offset(10);
            make.width.height.equalTo(@70);
        }];

        titleLbl = [[ESLabel alloc] initWithText:@"评分:" textColor:[UIColor darkGrayColor] fontSize:14];
        [self addSubview:titleLbl];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(thumbnailIV.mas_right).offset(10);
            make.top.equalTo(thumbnailIV).offset(10);
        }];

        gradeBtn1 = [[ESButton alloc] initWithTitle:@"" color:[UIColor darkGrayColor] fontSize:12];
        [gradeBtn1 setImage:[UIImage imageNamed:@"post_comment_star_off.png"] forState:UIControlStateNormal];
        [gradeBtn1 setImage:[UIImage imageNamed:@"post_comment_star_on.png"] forState:UIControlStateSelected];
        [gradeBtn1 setSelected:YES];
        gradeBtn1.tag = 1;
        [gradeBtn1 addTarget:self action:@selector(star:) forControlEvents:UIControlEventTouchUpInside];
        [gradeBtnArray addObject:gradeBtn1];
        [self addSubview:gradeBtn1];
        [gradeBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLbl);
            make.top.equalTo(titleLbl.mas_bottom).offset(10);
        }];

        gradeBtn2 = [[ESButton alloc] initWithTitle:@"" color:[UIColor darkGrayColor] fontSize:12];
        [gradeBtn2 setImage:[UIImage imageNamed:@"post_comment_star_off.png"] forState:UIControlStateNormal];
        [gradeBtn2 setImage:[UIImage imageNamed:@"post_comment_star_on.png"] forState:UIControlStateSelected];
        [gradeBtn2 setSelected:YES];
        gradeBtn2.tag = 2;
        [gradeBtn2 addTarget:self action:@selector(star:) forControlEvents:UIControlEventTouchUpInside];
        [gradeBtnArray addObject:gradeBtn2];
        [self addSubview:gradeBtn2];
        [gradeBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(gradeBtn1.mas_right).offset(10);
            make.top.equalTo(gradeBtn1);
        }];

        gradeBtn3 = [[ESButton alloc] initWithTitle:@"" color:[UIColor darkGrayColor] fontSize:12];
        [gradeBtn3 setImage:[UIImage imageNamed:@"post_comment_star_off.png"] forState:UIControlStateNormal];
        [gradeBtn3 setImage:[UIImage imageNamed:@"post_comment_star_on.png"] forState:UIControlStateSelected];
        [gradeBtn3 setSelected:YES];
        gradeBtn3.tag = 3;
        [gradeBtn3 addTarget:self action:@selector(star:) forControlEvents:UIControlEventTouchUpInside];
        [gradeBtnArray addObject:gradeBtn3];
        [self addSubview:gradeBtn3];
        [gradeBtn3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(gradeBtn2.mas_right).offset(10);
            make.top.equalTo(gradeBtn1);
        }];

        gradeBtn4 = [[ESButton alloc] initWithTitle:@"" color:[UIColor darkGrayColor] fontSize:12];
        [gradeBtn4 setImage:[UIImage imageNamed:@"post_comment_star_off.png"] forState:UIControlStateNormal];
        [gradeBtn4 setImage:[UIImage imageNamed:@"post_comment_star_on.png"] forState:UIControlStateSelected];
        [gradeBtn4 setSelected:YES];
        gradeBtn4.tag = 4;
        [gradeBtn4 addTarget:self action:@selector(star:) forControlEvents:UIControlEventTouchUpInside];
        [gradeBtnArray addObject:gradeBtn4];
        [self addSubview:gradeBtn4];
        [gradeBtn4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(gradeBtn3.mas_right).offset(10);
            make.top.equalTo(gradeBtn1);
        }];

        gradeBtn5 = [[ESButton alloc] initWithTitle:@"" color:[UIColor darkGrayColor] fontSize:12];
        [gradeBtn5 setImage:[UIImage imageNamed:@"post_comment_star_off.png"] forState:UIControlStateNormal];
        [gradeBtn5 setImage:[UIImage imageNamed:@"post_comment_star_on.png"] forState:UIControlStateSelected];
        [gradeBtn5 setSelected:YES];
        gradeBtn5.tag = 5;
        [gradeBtn5 addTarget:self action:@selector(star:) forControlEvents:UIControlEventTouchUpInside];
        [gradeBtnArray addObject:gradeBtn5];
        [self addSubview:gradeBtn5];
        [gradeBtn5 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(gradeBtn4.mas_right).offset(10);
            make.top.equalTo(gradeBtn1);
        }];

    }
    return self;
}

- (IBAction)star:(ESButton *)sender {
    for(int i = 0; i < gradeBtnArray.count; i++){
        ESButton *gradeBtn = (ESButton *) [gradeBtnArray objectAtIndex:i];
        [gradeBtn setSelected:(i < sender.tag)];
    }
    switch (sender.tag) {
        case 1:
            grade = 1;
            break;
        case 2:
            grade = 1;
            break;
        case 3:
            grade = 2;
            break;
        case 4:
            grade = 2;
            break;
        case 5:
            grade = 3;
            break;
    }
}

- (void)configData:(Goods *)goods {
    [thumbnailIV sd_setImageWithURL:[NSURL URLWithString:goods.thumbnail] placeholderImage:[UIImage imageNamed:@"image_empty.png"]];
}

@end