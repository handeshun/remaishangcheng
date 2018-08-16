//
//  MagicDialog.h
//  JavaMall
//
//  Created by LDD on 17/7/19.
//  Copyright © 2017年 Enation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MagicDialog : UIControl
/**
 *  初始化提示Dialog
 *
 *  @param vc      调用方的ViewContorl
 *  @param title   提示文字
 *  @param success 确定键的block
 *  @param failure 取消键的block
 *  @param yesHint 确定键的提示文字
 *  @param noHint  取消减的提示文字
 *
 *  @return MagicDialog对象
 */
-(instancetype)initWithOrdinary :(UIViewController *)vc title:(NSString *)title yesHint:(NSString*)yesHint noHint:(NSString *)noHint success:(void(^)(void))success failure:(void(^)(void))failure;
/**
 *  初始化提示Dialog(静态方法，不需要初始化对象)
 *
 *  @param vc      调用方的ViewContorl
 *  @param title   提示文字
 *  @param success 确定键的block
 *  @param failure 取消键的block
 *  @param yesHint 确定键的提示文字
 *  @param noHint  取消减的提示文字
 *
 *  @return MagicDialog对象
 */
+(instancetype)initWithOrdinary :(UIViewController *)vc title:(NSString *)title yesHint:(NSString*)yesHint noHint:(NSString *)noHint success:(void(^)(void))success failure:(void(^)(void))failure;
/**
 * 移除MagicDialog
 */
-(IBAction) hideDialog;

/**
 * 显示MagicDialog
 */
-(void) showDialog;
@end
