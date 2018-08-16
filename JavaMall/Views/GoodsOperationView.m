//
// Created by Dawei on 3/23/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "GoodsOperationView.h"
#import "Masonry.h"
#import "NSString+Common.h"
#import "ESButton.h"
#import "Constants.h"
#import "Setting.h"

@implementation GoodsOperationView {
    UILabel *badgeLabel;
    UIButton *addCartBtn;
    ESButton *storeBtn;
    ESButton *cartBtn;
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
    addCartBtn = [UIButton new];
    addCartBtn.backgroundColor = [[UIColor colorWithHexString:@"#f15352"] colorWithAlphaComponent:1.0];
    addCartBtn.titleLabel.font = [UIFont systemFontOfSize:16];;
    [addCartBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addCartBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    [self addSubview:addCartBtn];


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


    //购物车
    cartBtn = [ESButton new];
    UIImage *cartImage = [UIImage imageNamed:@"cart_bottom"];
    CGFloat cartWidth = [@"购物车" getSizeWithFont:[UIFont systemFontOfSize:12]].width;
    [cartBtn setImage:cartImage forState:UIControlStateNormal];
    cartBtn.titleLabel.font = [UIFont systemFontOfSize:12];;
    [cartBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cartBtn setTitle:@"购物车" forState:UIControlStateNormal];
    [cartBtn setTitleEdgeInsets:UIEdgeInsetsMake(cartImage.size.height, -cartImage.size.width, 0, 0)];
    [cartBtn setImageEdgeInsets:UIEdgeInsetsMake(-15, 0, 0, -cartWidth)];

    //角标
    badgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, -8, 20, 14)];
    [badgeLabel setFont:[UIFont systemFontOfSize:11]];
    [badgeLabel setText:[NSString stringWithFormat:@"%d", 0]];
    [badgeLabel setBackgroundColor:[UIColor whiteColor]];
    [badgeLabel setTextColor:[UIColor redColor]];
    [badgeLabel setTextAlignment:NSTextAlignmentCenter];
    badgeLabel.layer.cornerRadius = 6;
    badgeLabel.layer.masksToBounds = YES;
    badgeLabel.hidden = YES;
    [cartBtn addSubview:badgeLabel];
    [self addSubview:cartBtn];

    //关注
    favoriteBtn = [ESButton new];
    CGFloat favoriteWidth = [@"收藏" getSizeWithFont:[UIFont systemFontOfSize:12]].width;
    favoriteBtn.titleLabel.font = [UIFont systemFontOfSize:12];;
    [favoriteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setFavorited:NO];
    [self addSubview:favoriteBtn];

    spaceCustomer2Favorite = [UIView new];
    spaceFavorite2Cart = [UIView new];
    [self addSubview:spaceCustomer2Favorite];
    [self addSubview:spaceFavorite2Cart];

    //布局
    [addCartBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.and.top.and.bottom.equalTo(self);
        make.width.equalTo(@115);
    }];


    [storeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self).offset(12);
        make.right.equalTo(spaceCustomer2Favorite.mas_left);
    }];
    [favoriteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(spaceCustomer2Favorite.mas_right);
        make.right.equalTo(spaceFavorite2Cart.mas_left);
        make.top.equalTo(self).offset(12);
    }];
    [cartBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(addCartBtn.mas_left).offset(-10);
        make.left.equalTo(spaceFavorite2Cart.mas_right);
        make.top.equalTo(favoriteBtn);
    }];

    //布局间距视图
    [spaceCustomer2Favorite mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(spaceFavorite2Cart);
    }];
    [spaceFavorite2Cart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
    }];

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

/**
 * 设置购物车商品数量
 */
- (void) setCartCount:(NSInteger) cartCount{
    if(cartCount > 0) {
        badgeLabel.hidden = NO;
        badgeLabel.text = [NSString stringWithFormat:@"%d", cartCount];
    }else{
        badgeLabel.hidden = YES;
    }
}

- (void)setFavoriteAction:(SEL)action {
    [favoriteBtn addTarget:[self viewController] action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)setCartAction:(SEL)action {
    [cartBtn addTarget:[self viewController] action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)setStoreAction:(SEL)action {
    [storeBtn addTarget:[self viewController] action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)setAddCartAction:(SEL)action {
    [addCartBtn addTarget:[self viewController] action:action forControlEvents:UIControlEventTouchUpInside];
}

@end