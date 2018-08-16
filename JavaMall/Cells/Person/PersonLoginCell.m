//
// Created by Dawei on 6/28/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "SDImageCache.h"
#import "PersonLoginCell.h"
#import "Masonry.h"
#import "ESButton.h"
#import "UIView+Common.h"
#import "ESLabel.h"
#import "Member.h"
#import "UIButton+WebCache.h"

@implementation PersonLoginCell {
    UIImageView *containerView;

    ESLabel *nameLbl;
    ESLabel *levelLbl;
}

@synthesize loginBtn, faceBtn, favoriteBtn, pointBtn, mpBtn, favoriteStoreBtn, signBtn;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        containerView = [UIImageView new];
        containerView.image = [UIImage imageNamed:@"my_unlogin_bg.png"];
        [self addSubview:containerView];
        [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];

        loginBtn = [[ESButton alloc] initWithTitle:@"" color:[UIColor darkGrayColor] fontSize:14];
        [loginBtn setBackgroundImage:[UIImage imageNamed:@"person_login_bg_normal.png"] forState:UIControlStateNormal];
        [loginBtn setBackgroundImage:[UIImage imageNamed:@"person_login_bg_selected.png"] forState:UIControlStateSelected];
        [loginBtn borderWidth:3 color:[UIColor colorWithWhite:0.5 alpha:0.3] cornerRadius:30];
        [self addSubview:loginBtn];
        [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).offset(20);
            make.width.height.equalTo(@60);
        }];

        faceBtn = [ESButton new];
        [faceBtn setImage:[UIImage imageNamed:@"my_head_default.png"] forState:UIControlStateNormal];
        [faceBtn borderWidth:3 color:[UIColor colorWithWhite:0.5 alpha:0.3] cornerRadius:30];
        [self addSubview:faceBtn];
        [faceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.top.equalTo(self).offset(20);
            make.width.height.equalTo(@60);
        }];

        nameLbl = [[ESLabel alloc] initWithText:@"用户名" textColor:[UIColor whiteColor] fontSize:14];
        [self addSubview:nameLbl];
        [nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(faceBtn.mas_right).offset(10);
            make.top.equalTo(faceBtn).offset(10);
        }];

        levelLbl = [[ESLabel alloc] initWithText:@"普通会员" textColor:[UIColor whiteColor] fontSize:12];
        [self addSubview:levelLbl];
        [levelLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nameLbl);
            make.top.equalTo(nameLbl.mas_bottom).offset(5);
        }];
        
        signBtn = [[ESButton alloc] initWithTitle:@"" color:[UIColor whiteColor] fontSize:11];
        [signBtn setTitle:@"立即打卡" forState:UIControlStateNormal];
        [signBtn setTitle:@"今日已打" forState:UIControlStateDisabled];
        [signBtn setBackgroundImage:[UIImage imageNamed:@"unsignBackColor.png"] forState:UIControlStateNormal];
        [signBtn setBackgroundImage:[UIImage imageNamed:@"signBackColor.png"] forState:UIControlStateDisabled];
        signBtn.layer.masksToBounds = YES;
        signBtn.layer.cornerRadius = 5;
        [self addSubview:signBtn];
        [signBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(faceBtn);
            make.right.equalTo(self).offset(-15);
            make.width.equalTo(@70);
            make.height.equalTo(@24);
        }];

        favoriteBtn = [[ESButton alloc] initWithTitle:@"0\n收藏商品" color:[UIColor whiteColor] fontSize:12];
        favoriteBtn.titleLabel.numberOfLines = 0;
        favoriteBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        favoriteBtn.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.3];
        [self addSubview:favoriteBtn];
        [favoriteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(self);
            make.height.equalTo(@45);
            make.width.equalTo(@((kScreen_Width-1.5)/4));
        }];

        favoriteStoreBtn = [[ESButton alloc] initWithTitle:@"0\n关注店铺" color:[UIColor whiteColor] fontSize:12];
        favoriteStoreBtn.titleLabel.numberOfLines = 0;
        favoriteStoreBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        favoriteStoreBtn.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.3];
        [self addSubview:favoriteStoreBtn];
        [favoriteStoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(favoriteBtn.mas_right).offset(0.5f);
            make.width.bottom.height.equalTo(favoriteBtn);
        }];

        pointBtn = [[ESButton alloc] initWithTitle:@"0\n等级积分" color:[UIColor whiteColor] fontSize:12];
        pointBtn.titleLabel.numberOfLines = 0;
        pointBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        pointBtn.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.3];
        [self addSubview:pointBtn];
        [pointBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(favoriteStoreBtn.mas_right).offset(0.5f);
            make.width.bottom.height.equalTo(favoriteBtn);
        }];

        mpBtn = [[ESButton alloc] initWithTitle:@"0\n消费积分" color:[UIColor whiteColor] fontSize:12];
        mpBtn.titleLabel.numberOfLines = 0;
        mpBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        mpBtn.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.3];
        [self addSubview:mpBtn];
        [mpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            make.left.equalTo(pointBtn.mas_right).offset(0.5f);
            make.bottom.height.width.equalTo(favoriteBtn);
        }];

    }
    return self;
}

- (void)configData:(Member *)member {
    if(member == nil){
        containerView.image = [UIImage imageNamed:@"my_unlogin_bg.png"];
        [loginBtn setHidden:NO];
        [faceBtn setHidden:YES];
        [nameLbl setHidden:YES];
        [levelLbl setHidden:YES];
        [signBtn setHidden:YES];
        [favoriteBtn setTitle:@"收藏商品" forState:UIControlStateNormal];
        [favoriteStoreBtn setTitle:@"关注店铺" forState:UIControlStateNormal];
        [pointBtn setTitle:@"等级积分" forState:UIControlStateNormal];
        [mpBtn setTitle:@"消费积分" forState:UIControlStateNormal];
    }else{
        containerView.image = [UIImage imageNamed:@"my_login_bg.png"];
        [loginBtn setHidden:YES];
        [faceBtn setHidden:NO];
        [nameLbl setHidden:NO];
        [levelLbl setHidden:NO];
        [signBtn setHidden:NO];
        nameLbl.text = member.userName;
        levelLbl.text = member.levelName;
        
        if (member.issign == 0) {
            signBtn.enabled = YES;
        }else {
            signBtn.enabled = NO;
        }
        if(member.face == nil || member.face.length == 0){
            [faceBtn setImage:[UIImage imageNamed:@"my_head_default.png"] forState:UIControlStateNormal];
        }else{
            [faceBtn sd_setImageWithURL:[NSURL URLWithString:member.face] forState:UIControlStateNormal];
        }
        [favoriteBtn setTitle:[NSString stringWithFormat:@"%d\n收藏商品", member.favoriteCount] forState:UIControlStateNormal];
        [favoriteStoreBtn setTitle:[NSString stringWithFormat:@"%d\n关注店铺", member.favoriteStoreCount] forState:UIControlStateNormal];
        [pointBtn setTitle:[NSString stringWithFormat:@"%d\n等级积分", member.point] forState:UIControlStateNormal];
        [mpBtn setTitle:[NSString stringWithFormat:@"%d\n消费积分", member.mp] forState:UIControlStateNormal];
    }
}


@end
