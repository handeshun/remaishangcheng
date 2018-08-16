//
//  LBSecLineLable.m
//  yingXiongReNv
//
//  Created by Guo Hero on 17/4/24.
//  Copyright © 2017年 李斌. All rights reserved.
//

#import "LBSecLineLable.h"

@implementation LBSecLineLable

- (void)drawRect:(CGRect)rect{
    // 调用super的drawRect:方法,会按照父类绘制label的文字
    [super drawRect:rect];
    // 取文字的颜色作为删除线的颜色
    [self.textColor set];
    CGFloat w = rect.size.width;
    CGFloat h = rect.size.height;
    // 绘制(0.35是label的中间位置,可以自己调整)
    UIRectFill(CGRectMake(0, h * 0.5, w - 2, 1));
}

@end
