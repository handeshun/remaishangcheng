//
//  MagicDialog.m
//  JavaMall
//
//  Created by LDD on 17/7/19.
//  Copyright © 2017年 Enation. All rights reserved.
//

#import "MagicDialog.h"
#import "Masonry.h"
#import "ESLabel.h"

@implementation MagicDialog
{
    /**
     *  Dialog背景视图
     */
    UIView      *background;
    
    /**
     *  提示Dialog 确定回调
     */
    void (^thisVoidSuccess)(void);
    
    /**
     *  提示Dialog 取消回调
     */
    void (^thisVoidFailure)(void);
    
    /**
     *  调用方UIViewController
     */
    UIViewController *viewCon;
}
/**
 *  初始化提示Dialog
 *
 *  @param vc      调用方的ViewContorl
 *  @param title   提示文字
 *  @param success 确定键的block
 *  @param failure 取消键的block
 *  @param yesHint 确定键的提示文字
 *  @param noHint  取消减的提示文字
 *  @return MagicDialog对象
 */
-(instancetype) initWithOrdinary:(UIViewController *)vc title:(NSString *)title yesHint:(NSString*)yesHint noHint:(NSString *)noHint success:(void (^)(void))success failure:(void (^)(void))failure{
    viewCon =vc;
    thisVoidSuccess = success;
    thisVoidFailure = failure;
    self = [super init];
    if (self) {
        self.frame=CGRectMake(0,0, kScreen_Width, kScreen_Height);
        self.tag=777;
        self.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];
        [self addTarget:self action:@selector(BackViewClick) forControlEvents:UIControlEventTouchUpInside];
        [self ordinaryDraw:title yesHint:yesHint noHint:noHint];
    }
    return self;
}

/**
 *  初始化提示Dialog(静态方法，不需要初始化对象)
 *
 *  @param vc      调用方的ViewContorl
 *  @param title   提示文字
 *  @param success 确定键的block
 *  @param failure 取消键的block
 *  @param yesHint 确定键的提示文字
 *  @param noHint  取消减的提示文字
 *  @return MagicDialog对象
 */
+(instancetype)initWithOrdinary:(UIViewController *)vc title:(NSString *)title yesHint:(NSString*)yesHint noHint:(NSString *)noHint success:(void (^)(void))success failure:(void (^)(void))failure{
    return [[self alloc]initWithOrdinary:vc title:title yesHint:yesHint noHint:noHint  success:success failure:failure];
}

/**
 *  绘制提示Dialog
 *
 *  @param hint 提示文字
 *  @param yesHint 确定键的提示文字
 *  @param noHint  取消减的提示文字
 */
-(void) ordinaryDraw :(NSString *)hint yesHint:(NSString*)yesHint noHint:(NSString *)noHint {
    background = [[UIView alloc]initWithFrame:CGRectMake(kScreen_Width*0.15,kScreen_Height*0.3, kScreen_Width*0.7, kScreen_Height*0.25)];
    background.backgroundColor = [UIColor whiteColor];
    background.layer.cornerRadius=5;
    [self addSubview:background];
    
    UIView *titleBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width*0.7, kScreen_Height*0.05)];
    titleBar.backgroundColor = [UIColor colorWithHexString:@"#fff15353"];
    [background addSubview:titleBar];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:titleBar.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5,5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = titleBar.bounds;
    maskLayer.path = maskPath.CGPath;
    titleBar.layer.mask = maskLayer;
    ESLabel *title =[[ESLabel alloc] initWithText:@"提示" textColor:[UIColor whiteColor] fontSize:14];
    [titleBar addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(titleBar);
    }];
    
    ESLabel *hintLabel =[[ESLabel alloc] initWithText:hint textColor:[UIColor blackColor] fontSize:14];
    [background addSubview:hintLabel];
    [hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(titleBar);
        make.centerY.equalTo(self).offset(-kScreen_Height*0.1);
    }];
    ESLabel *canceltitle =[[ESLabel alloc] initWithText:noHint textColor:[UIColor blackColor] fontSize:14];
    ESLabel *confirmtitle =[[ESLabel alloc] initWithText:yesHint textColor:[UIColor whiteColor] fontSize:14];
    UIView *cancel = [[UIControl alloc]initWithFrame:CGRectMake(0, kScreen_Height*0.20, kScreen_Width*0.35, kScreen_Height*0.05)];
    [(UIControl *)cancel addTarget:self action:@selector(VoidFailure) forControlEvents:UIControlEventTouchUpInside];
    [cancel addSubview:canceltitle];
    [canceltitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(cancel);
    }];
    cancel.backgroundColor=[UIColor whiteColor];
    [background addSubview:cancel];
    UIBezierPath *cancelmaskPath = [UIBezierPath bezierPathWithRoundedRect:cancel.bounds byRoundingCorners:UIRectCornerBottomLeft cornerRadii:CGSizeMake(5,5)];
    CAShapeLayer *cancelmaskLayer = [[CAShapeLayer alloc] init];
    cancelmaskLayer.frame = cancel.bounds;
    cancelmaskLayer.path = cancelmaskPath.CGPath;
    cancel.layer.mask = cancelmaskLayer;
    UIView *confrim = [[UIControl alloc]initWithFrame:CGRectMake(kScreen_Width*0.35, kScreen_Height*0.20, kScreen_Width*0.35, kScreen_Height*0.05)];
    [(UIControl *)confrim addTarget:self action:@selector(VoidSuccess) forControlEvents:UIControlEventTouchUpInside];
    [confrim addSubview:confirmtitle];
    [confirmtitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(confrim);
    }];
    confrim.backgroundColor=[UIColor colorWithHexString:@"#fff15353"];
    [background addSubview:confrim];
    UIBezierPath *confrimmaskPath = [UIBezierPath bezierPathWithRoundedRect:confrim.bounds byRoundingCorners:UIRectCornerBottomRight cornerRadii:CGSizeMake(5,5)];
    CAShapeLayer *confrimmaskLayer = [[CAShapeLayer alloc] init];
    confrimmaskLayer.frame = confrim.bounds;
    confrimmaskLayer.path = confrimmaskPath.CGPath;
    confrim.layer.mask = confrimmaskLayer;
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, kScreen_Height*0.20, kScreen_Width*0.7, 1)];
    line.backgroundColor = [UIColor colorWithHexString:kBorderLineColor];
    [background addSubview:line];
}
/**
 *  提示Dialog 确定按钮响应事件
 */
-(IBAction)VoidSuccess{
    [self hideDialog];
    thisVoidSuccess();
}

/**
 *  提示Dialog 取消按钮响应事件
 */
-(IBAction)VoidFailure{
    [self hideDialog];
    thisVoidFailure();
}
/**
 *  点击背景View，隐藏掉dialog
 */
-(IBAction)BackViewClick{
  [self hideDialog];
}

/**
 * 显示MagicDialog
 */
-(void) showDialog{
    if( [viewCon.view viewWithTag:777] ){
        [[viewCon.view viewWithTag:777]removeFromSuperview];
    }
    [viewCon.view addSubview:self];
    // 第一步：将view宽高缩至无限小（点）
    background.transform = CGAffineTransformScale(CGAffineTransformIdentity,
                                                  0.01, 0.01);
    [UIView animateWithDuration:0.3
                     animations:^{
                         // 第二步： 以动画的形式将view慢慢放大至原始大小的1.2倍
                         background.transform =
                         CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.2
                                          animations:^{
                                              // 第三步： 以动画的形式将view恢复至原始大小
                                              background.transform = CGAffineTransformIdentity;
                                          }];
                     }];
    
}

/**
 * 移除MagicDialog
 */
-(IBAction)hideDialog{
    [UIView animateWithDuration:0.2
                     animations:^{
                         // 第一步： 以动画的形式将view慢慢放大至原始大小的1.2倍
                         background.transform =
                         CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.3
                                          animations:^{
                                              // 第二步： 以动画的形式将view缩小至原来的1/1000分之1倍
                                              background.transform = CGAffineTransformScale(
                                                                                            CGAffineTransformIdentity, 0.001, 0.001);
                                          }
                                          completion:^(BOOL finished) {
                                              // 第三步： 移除
                                              if( [viewCon.view viewWithTag:777] ){
                                                  [[viewCon.view viewWithTag:777]removeFromSuperview];
                                              }
                                          }];
                     }];
    
}


@end
