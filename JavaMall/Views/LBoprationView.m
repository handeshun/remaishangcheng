//
//  LBoprationView.m
//  JavaMall
//
//  Created by Guo Hero on 2017/11/27.
//  Copyright © 2017年 Enation. All rights reserved.
//

#import "LBoprationView.h"
#import "Masonry.h"
#import "NSString+Common.h"
#import "ESButton.h"
#import "Constants.h"
#import "Setting.h"

@implementation LBoprationView {
    UILabel *badgeLabel;
    ESButton *storeBtn;
    ESButton *favoriteBtn;
    
    UIView *spaceCustomer2Favorite;
    UIView *spaceFavorite2Cart;
}

- (instancetype) initWithFrame:(CGRect) frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setFrame:frame];
        [self createUI];
    }
    return self;
}

- (void) createUI{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    
    //添加到购物车
    _addCartBtn = [UIButton new];
    _addCartBtn.backgroundColor = [[UIColor colorWithHexString:@"#f15352"] colorWithAlphaComponent:1.0];
    _addCartBtn.titleLabel.font = [UIFont systemFontOfSize:16];;
    [_addCartBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:_addCartBtn];
    
    
    //店铺
    storeBtn = [ESButton new];
    UIImage *customerImage = [UIImage imageNamed:@"store_bottom.png"];
    CGFloat customerWidth = [@"店铺" getSizeWithFont:[UIFont systemFontOfSize:12]].width;
    [storeBtn setImage:customerImage forState:UIControlStateNormal];
    storeBtn.titleLabel.font = [UIFont systemFontOfSize:12];;
    [storeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [storeBtn setTitle:@"店铺" forState:UIControlStateNormal];
    [storeBtn setTitleEdgeInsets:UIEdgeInsetsMake(customerImage.size.height, -customerImage.size.width, 0, 0)];
    [storeBtn setImageEdgeInsets:UIEdgeInsetsMake(-15, 0, 0, -customerWidth)];
    [self addSubview:storeBtn];
    
    //关注
    favoriteBtn = [ESButton new];
    CGFloat favoriteWidth = [@"收藏" getSizeWithFont:[UIFont systemFontOfSize:12]].width;
    favoriteBtn.titleLabel.font = [UIFont systemFontOfSize:12];;
    [favoriteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setFavorited:NO];
    [self addSubview:favoriteBtn];
    
//    spaceCustomer2Favorite = [UIView new];
//    spaceFavorite2Cart = [UIView new];
//    [self addSubview:spaceCustomer2Favorite];
//    [self addSubview:spaceFavorite2Cart];
    
    //布局
    [_addCartBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.and.top.and.bottom.equalTo(self);
        make.width.equalTo(@(kScreen_Width/3));
    }];
    
    
    [storeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.top.equalTo(self);
        make.width.equalTo(@(kScreen_Width/3));
    }];
    [favoriteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(storeBtn.mas_right);
        make.width.equalTo(@(kScreen_Width/3));
        make.top.bottom.equalTo(self);
    }];
    
//    //布局间距视图
//    [spaceCustomer2Favorite mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(spaceFavorite2Cart);
//    }];
//    [spaceFavorite2Cart mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self);
//    }];
    
}

/**
 * 设置是否收藏
 */
- (void) setFavorited:(BOOL) favorited{
    favoriteBtn.selected = favorited;
    UIImage *image = nil;
    NSString *title = @"收藏";
    if(favorited){
        image = [UIImage imageNamed:@"favorite_bottom"];
        title = @"已收藏";
    }else{
        image = [UIImage imageNamed:@"unfavorite_bottom"];
        title = @"收藏";
    }
    [favoriteBtn setImage:image forState:UIControlStateNormal];
    [favoriteBtn setTitle:title forState:UIControlStateNormal];
    CGFloat favoriteWidth = [title getSizeWithFont:[UIFont systemFontOfSize:12]].width;
    [favoriteBtn setTitleEdgeInsets:UIEdgeInsetsMake(image.size.height, -image.size.width, 0, 0)];
    [favoriteBtn setImageEdgeInsets:UIEdgeInsetsMake(-15, 0, 0, -favoriteWidth)];
}

- (void)setFavoriteAction:(SEL)action {
    [favoriteBtn addTarget:[self viewController] action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)setStoreAction:(SEL)action {
    [storeBtn addTarget:[self viewController] action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)setAddCartAction:(SEL)action {
    if ([_addCartBtn.currentTitle isEqualToString:@"立即秒杀"]) {
        [_addCartBtn addTarget:[self viewController] action:action forControlEvents:UIControlEventTouchUpInside];
    }
}
@end
