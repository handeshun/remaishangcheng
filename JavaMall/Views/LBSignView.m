//
//  LBSignView.m
//  JavaMall
//
//  Created by Guo Hero on 2017/11/25.
//  Copyright © 2017年 Enation. All rights reserved.
//

#import "LBSignView.h"
#import "View+MASAdditions.h"
#import "AdaptationKit.h"

@implementation LBSignView{
    UIImageView *iconImgView;
    UIButton    *cancerBtn;
    UIButton    *signBtn;
    UILabel     *timeLab;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder])
        [self setupUI];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame])
        [self setupUI];
    return self;
}

/**
 * 创建UI界面
 */
- (void)setupUI {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    
    iconImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jcdkbjt"]];
    [self addSubview:iconImgView];
    [iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(132);
        make.centerX.equalTo(self);
    }];
    
    NSDateFormatter *dateFor = [[NSDateFormatter alloc] init];
    dateFor.dateFormat=@"yyyy年MM月dd日";
    NSDate *dateNow = [NSDate date];
    
    timeLab = [[UILabel alloc]init];
    timeLab.font = LBFont(51);
    timeLab.textColor = LBColor(238, 230, 52);
    timeLab.text = [dateFor stringFromDate:dateNow];
    [self addSubview:timeLab];
    [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImgView).offset(58);
        make.centerX.equalTo(iconImgView.mas_centerX);
    }];
    
    cancerBtn = [UIButton new];
    [cancerBtn setImage:[UIImage imageNamed:@"lbcancer"] forState:UIControlStateNormal];
    [self addSubview:cancerBtn];
    [cancerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImgView.mas_top).offset(-9);
        make.right.equalTo(iconImgView.mas_right).offset(9);
        make.width.height.equalTo(@37);
    }];
    
    signBtn = [UIButton new];
    [signBtn setImage:[UIImage imageNamed:@"lbdaka"] forState:UIControlStateNormal];
    [self addSubview:signBtn];
    [signBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImgView.mas_bottom).offset(-67);
        make.centerX.equalTo(iconImgView.mas_centerX);
        make.width.height.equalTo(@109);
    }];
}

- (void)setCancerAction:(SEL)action {
    [cancerBtn addTarget:[self viewController] action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSignAction:(SEL)action {
    [signBtn addTarget:[self viewController] action:action forControlEvents:UIControlEventTouchUpInside];
}

@end
