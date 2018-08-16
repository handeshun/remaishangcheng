//
//  LBoprationView.h
//  JavaMall
//
//  Created by Guo Hero on 2017/11/27.
//  Copyright © 2017年 Enation. All rights reserved.
//

#import "BaseView.h"

@interface LBoprationView : BaseView

@property (nonatomic,strong)UIButton *addCartBtn;;

- (instancetype)initWithFrame:(CGRect)frame;

/**
 * 设置是否已经关注
 */
- (void)setFavorited:(BOOL)favorited;

/**
 * 设置立即秒杀
 */
- (void)setAddCartAction:(SEL)action;

/**
 * 设置店铺事件
 */
- (void)setStoreAction:(SEL)action;

/**
 * 设置关注事件
 */
- (void)setFavoriteAction:(SEL)action;
@end
